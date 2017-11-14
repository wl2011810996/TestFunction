//
//  VRListController.m
//  testFunction
//
//  Created by 拓视 on 2017/9/25.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "VRListController.h"

#import "GoogleVRController.h"
#import "VRListCell.h"


@interface VRListController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *mtableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation VRListController

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
        for (int i=0; i<10; i++) {
            [_dataArray addObject:[NSString stringWithFormat:@"VR%d",i]];
        }
    }
    return _dataArray;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 274;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"VRListCell";

    VRListCell *cell = (VRListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"VRListCell" owner:self options:nil]lastObject];
    }
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GoogleVRController *GoogleVRVC = [[GoogleVRController alloc]init];
        GoogleVRController *GoogleVRVC = [[UIStoryboard storyboardWithName:@"GoogleVR" bundle:nil]instantiateViewControllerWithIdentifier:@"GoogleVRController"];
    [self.navigationController pushViewController:GoogleVRVC animated:YES];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.title = @"视频列表";
    
    self.navigationItem.title = @"VR列表";
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    UITableView *mtableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    mtableView.delegate = self;
    mtableView.dataSource = self;
    
    
    
    [self.view addSubview:mtableView];
    
    
}



@end
