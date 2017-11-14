//
//  NoteFunctionController.m
//  testFunction
//
//  Created by 拓视 on 2017/9/8.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "NoteFunctionController.h"

@interface NoteFunctionController ()

@property(nonatomic,strong)UIView *noteView;

@property(nonatomic,strong)UIImageView *noteImg;

@property(nonatomic,assign)BOOL isClick;

@end

@implementation NoteFunctionController

- (void)viewDidLoad {
 
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    UIView *noteView = [[UIView alloc]init];
    noteView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 100, [UIScreen mainScreen].bounds.size.width, 50);
    [self.view addSubview:noteView];
    noteView.backgroundColor = [UIColor clearColor];
    self.noteView = noteView;
    
    UIImageView *noteImg = [[UIImageView alloc]init];
    noteImg.backgroundColor = [UIColor colorWithRed:26.0/255 green:25.0/255 blue:31.0/255 alpha:1];
    noteImg.frame = noteView.bounds;
    noteImg.layer.cornerRadius = 25;
    [noteView addSubview:noteImg];
    
    UILabel *notelabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, [UIScreen mainScreen].bounds.size.width-145, 50)];
    notelabel.numberOfLines = 0;
    notelabel.font = [UIFont systemFontOfSize:10];
    [notelabel setTextColor:[UIColor whiteColor]];
    notelabel.text = @"提示:测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据";
    [self.noteView addSubview:notelabel];
    
    
    UIButton *noteBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    noteBtn.frame = CGRectMake(0,0, 40, 50);
    noteBtn.backgroundColor = [UIColor clearColor];
    [noteView addSubview:noteBtn];
    [noteBtn addTarget:self action:@selector(hideOrShow:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void)hideOrShow:(id)sender
{
    NSLog(@"hideOrShow");
    if (!_isClick) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect = self.noteView.frame;
            rect.origin.x = 100;
            self.noteView.frame = rect;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            CGRect rect = self.noteView.frame;
            rect.origin.x =  [UIScreen mainScreen].bounds.size.width - 40;
            self.noteView.frame = rect;
        }];
    }
    
    
    _isClick=!_isClick;

    
    

    
   
}






@end
