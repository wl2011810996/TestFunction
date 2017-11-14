//
//  IPhoneXController.m
//  testFunction
//
//  Created by 拓视 on 2017/9/29.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "IPhoneXController.h"

@interface IPhoneXController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *mtableView;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation IPhoneXController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _dataArray = [NSMutableArray array];
    
    [self setupNav];

    [self setUIConfig];
    
    self.view.backgroundColor = [UIColor cyanColor];

}


-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
        for (int i=0; i<10; i++) {
            [_dataArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
    }
    return _dataArray;
    
}

-(void)setupNav
{
    UIView *titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor blueColor];
    titleView.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 44);
    titleView.backgroundColor = [UIColor redColor];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-80)/2, 0, 80, 44)];
    [titleLabel setText:@"盗墓笔记"];
    titleLabel.textAlignment = NSTextAlignmentCenter;

    [titleView addSubview:titleLabel];

    self.navigationItem.titleView = titleView;
}

-(void)setUIConfig
{
    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
    UITableView *mtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 88, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height-34-88) style:UITableViewStylePlain];
    mtableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    mtableView.backgroundColor = [UIColor yellowColor];
    
    mtableView.delegate = self;
    mtableView.dataSource = self;
    [self.view addSubview:mtableView];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}


@end
