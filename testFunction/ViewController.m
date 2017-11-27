//
//  ViewController.m
//  testFunction
//
//  Created by 拓视 on 2017/8/21.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "ViewController.h"
#import "UITextViewTest.h"
#import "NoteFunctionController.h"
#import "MovieViewController.h"
#import "BackgroundViewController.h"
#import "VRViewController.h"
#import "GoogleVRController.h"
#import "VRListController.h"

#import "BaseTabBarController.h"
#import "IPhoneXController.h"
#import "PhotoClipController.h"
#import "WeiXinController.h"
#import "CalanderController.h"
#import "PictureBrowseController.h"
#import "CarouselAndVideoController.h"
#import "SmallWidgetController.h"
#import "PictureSelectController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *mtableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UITabBarController *tabbarController;

@end


@implementation ViewController

-(NSMutableArray *)dataArray{
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@"UITextView功能测试"];
        [_dataArray addObject:@"小黄车提示功能"];
        [_dataArray addObject:@"视频播放Demo"];
        [_dataArray addObject:@"VR背景图Demo"];
        [_dataArray addObject:@"GoogleVRDemo"];
        [_dataArray addObject:@"iPhoneX适配"];
        [_dataArray addObject:@"图片裁剪"];
        [_dataArray addObject:@"微信绑定"];
        [_dataArray addObject:@"时间选择器"];
        [_dataArray addObject:@"图片浏览器"];
        [_dataArray addObject:@"视频图片轮播器"];
         [_dataArray addObject:@"小控件测试"];
         [_dataArray addObject:@"图片多选"];
    }
    return _dataArray;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor cyanColor];
    
    UITableView *mtableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    mtableView.delegate = self;
    mtableView.dataSource = self;
    
    [self.view addSubview:mtableView];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        UITextViewTest *test = [[UITextViewTest alloc]initWithNibName:@"UITextViewTest" bundle:nil];
        [self.navigationController pushViewController:test animated:YES];
    }else if (indexPath.row==1){
        NoteFunctionController *noteFunctionVC = [[NoteFunctionController alloc]init];
        [self.navigationController pushViewController:noteFunctionVC animated:YES];
    }else if (indexPath.row == 2)
    {
        //[[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
//        MovieViewController *movieVC = [[MovieViewController alloc]init];
        MovieViewController *movieVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MovieViewController"];
        movieVC.videoURL = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456665467509qingshu.mp4"];
        [self.navigationController pushViewController:movieVC animated:YES];
    }else if (indexPath.row ==3)
    {
        VRViewController *VRVC = [[VRViewController alloc]initWithNibName:@"VRViewController" bundle:nil];
//      VRViewController *VRVC =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"VRViewController"];
//        BackgroundViewController *backgroundVC = [[BackgroundViewController alloc]init];
        [self.navigationController pushViewController:VRVC animated:YES];
    }else if (indexPath.row == 4)
    {
//        GoogleVRController *GoogleVRVC = [[GoogleVRController alloc]initWithNibName:@"GoogleVRController" bundle:nil];
//        GoogleVRController *GoogleVRVC = [[GoogleVRController alloc]init];
//        //      VRViewController *VRVC =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"VRViewController"];
//        //        BackgroundViewController *backgroundVC = [[BackgroundViewController alloc]init];
//        [self.navigationController pushViewController:GoogleVRVC animated:YES];
        
        VRListController *VRList = [[VRListController alloc]init];
        [self.navigationController pushViewController:VRList animated:YES];
    }else if (indexPath.row == 5)
    {
        //        GoogleVRController *GoogleVRVC = [[GoogleVRController alloc]initWithNibName:@"GoogleVRController" bundle:nil];
        //        GoogleVRController *GoogleVRVC = [[GoogleVRController alloc]init];
        //        //      VRViewController *VRVC =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"VRViewController"];
        //        //        BackgroundViewController *backgroundVC = [[BackgroundViewController alloc]init];
        //        [self.navigationController pushViewController:GoogleVRVC animated:YES];
        
        IPhoneXController *iphoneX = [[IPhoneXController alloc]init];
        [self.navigationController pushViewController:iphoneX animated:YES];
    }else if (indexPath.row == 6)
    {
//        PhotoClipController *photoClipVC = [[UIStoryboard storyboardWithName:@"PhotoStoryboard" bundle:nil]instantiateViewControllerWithIdentifier:@"PhotoClipController"];
//        [self.navigationController pushViewController:photoClipVC animated:YES];
//
        PhotoClipController *photoClipVC = [[PhotoClipController alloc]initWithNibName:@"PhotoClipController" bundle:nil];
        [self.navigationController pushViewController:photoClipVC animated:YES];
//        [self presentViewController:photoClipVC animated:YES completion:nil];
        
    }else if (indexPath.row == 7)
    {
        WeiXinController *weixinVC = [[WeiXinController alloc]initWithNibName:@"WeiXinController" bundle:nil];
        [self.navigationController pushViewController:weixinVC animated:YES];
        
    }else if (indexPath.row == 8)
    {
        CalanderController *calanderVC = [[CalanderController alloc]initWithNibName:@"CalanderController" bundle:nil];
        [self.navigationController pushViewController:calanderVC animated:YES];
        
    }else if (indexPath.row == 9)
    {
        PictureBrowseController *picturebrowseVC = [[PictureBrowseController alloc]initWithNibName:@"PictureBrowseController" bundle:nil];
        [self.navigationController pushViewController:picturebrowseVC animated:YES];
        
    }else if (indexPath.row == 10)
    {
        CarouselAndVideoController *carouseAndvideoVC = [[CarouselAndVideoController alloc]initWithNibName:@"CarouselAndVideoController" bundle:nil];
        [self.navigationController pushViewController:carouseAndvideoVC animated:YES];
    }else if (indexPath.row == 11)
    {
        SmallWidgetController *smallWidgetVC = [[SmallWidgetController alloc]initWithNibName:@"SmallWidgetController" bundle:nil];
        [self.navigationController pushViewController:smallWidgetVC animated:YES];
    }else if (indexPath.row == 12)
    {
        PictureSelectController *pictureselectVC = [[PictureSelectController alloc]init];
        [self.navigationController pushViewController:pictureselectVC animated:YES];
    }

}

@end
