//
//  SmallWidgetController.m
//  testFunction
//
//  Created by 拓视 on 2017/11/23.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "SmallWidgetController.h"
#import "PPNumberButton.h"

#import "DropDownListView.h"

@interface SmallWidgetController ()<PPNumberButtonDelegate>
{
    NSMutableArray *chooseArray;
}

@end

@implementation SmallWidgetController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self example1];
    [self example2];
    [self example3];
    [self example4];
    
    [self example5];
}

/**
 自定义加减按钮文字标题
 */
- (void)example1
{
    PPNumberButton *numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(100, 100, 110, 30)];
    // 开启抖动动画
    numberButton.shakeAnimation = YES;
    // 设置最小值
    numberButton.minValue = 2;
    // 设置最大值
    numberButton.maxValue = 10;
    // 设置输入框中的字体大小
    numberButton.inputFieldFont = 23;
    numberButton.increaseTitle = @"＋";
    numberButton.decreaseTitle = @"－";
    numberButton.currentNumber = 777;
    numberButton.delegate = self;
    numberButton.longPressSpaceTime = CGFLOAT_MAX;
    
    numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        NSLog(@"%ld",num);
    };
    [self.view addSubview:numberButton];
}

- (void)pp_numberButton:(__kindof UIView *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus
{
    NSLog(@"%@",increaseStatus ? @"加运算":@"减运算");
}

/**
 边框状态
 */
- (void)example2
{
    PPNumberButton *numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(100, 160, 150, 30)];
    //设置边框颜色
    numberButton.borderColor = [UIColor grayColor];
    numberButton.increaseTitle = @"＋";
    numberButton.decreaseTitle = @"－";
    numberButton.currentNumber = 777;
    numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        NSLog(@"%ld",num);
    };
    
    [self.view addSubview:numberButton];
}


/**
 自定义加减按钮背景图片
 */
- (void)example3
{
    PPNumberButton *numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(100, 220, 100, 30)];
    numberButton.shakeAnimation = YES;
    numberButton.increaseImage = [UIImage imageNamed:@"increase_taobao"];
    numberButton.decreaseImage = [UIImage imageNamed:@"decrease_taobao"];
    
    numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        NSLog(@"%ld",num);
    };
    
    [self.view addSubview:numberButton];
}

/**
 饿了么,美团外卖,百度外卖样式
 */
- (void)example4
{
    PPNumberButton *numberButton = [PPNumberButton numberButtonWithFrame:CGRectMake(100, 280, 100, 30)];
    // 初始化时隐藏减按钮
    numberButton.decreaseHide = YES;
    numberButton.increaseImage = [UIImage imageNamed:@"increase_meituan"];
    numberButton.decreaseImage = [UIImage imageNamed:@"decrease_meituan"];
    numberButton.currentNumber = -777;
    numberButton.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
        NSLog(@"%ld",num);
    };
    
    [self.view addSubview:numberButton];
}

-(void)example5
{
    
    chooseArray = [NSMutableArray arrayWithArray:@[@[@"超清",@"高清",@"标清",@"省流",@"自动"],]];
    
    //这个dropDownView是下拉菜单的点击视图  点击该视图可以显示下拉菜单
    DropDownListView * dropDownView = [[DropDownListView alloc] initWithFrame:CGRectMake(200,400, 60, 20) dataSource:self delegate:self];
    
    
    
    
    //因为不清楚显示下拉菜单的frame 但是我们可以借助一个视图将下拉菜单视图加载到我们想要放置的位置的视图上
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(200, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    
    [self.view addSubview:superView];
    self.view.backgroundColor = [UIColor whiteColor];
    //下拉菜单添加到superView的frame上
    
    dropDownView.mSuperView = superView;
    
    [self.view addSubview:dropDownView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark -- dropDownListDelegate
//码率切换请求方法
-(void) chooseAtSection:(NSInteger)section index:(NSInteger)index
{
    NSLog(@"童大爷选了section:%d ,index:%d",section,index);
    if (index == 0) {
        NSLog(@"切换超清");
    }
    if (index == 1) {
        NSLog(@"切换高清");
    }
    if (index == 2) {
        NSLog(@"切换标清");
    }
    if (index == 3) {
        NSLog(@"切换省流");
    }
    if (index == 4) {
        NSLog(@"切换自动");
    }
}


#pragma mark -- dropdownList DataSource
-(NSInteger)numberOfSections
{
    return [chooseArray count];
}
-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry =chooseArray[section];
    return [arry count];
}
-(NSString *)titleInSection:(NSInteger)section index:(NSInteger) index
{
    return chooseArray[section][index];
}
-(NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}



@end
