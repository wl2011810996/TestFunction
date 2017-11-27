//
//  CarouselPlayerController.m
//  testFunction
//
//  Created by 拓视 on 2017/11/23.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "CarouselPlayerController.h"
#import "YVideoPlayerView.h"


@interface CarouselPlayerController ()
{
    YVideoPlayerView * yVideoPlayerView;
}

@property (strong, nonatomic)UIView *videoView;

@end



@implementation CarouselPlayerController

-(UIView *)videoView
{
    if (!_videoView) {
        _videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kMainScreenWidth, 200)];
        [self.view addSubview:_videoView];
    }
    return _videoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

     yVideoPlayerView = [[YVideoPlayerView alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 200) VideoName:@"网络视频" Path:@"http://www.ybanerlv.com/02926b1240854ee78c07fa8ef3265896/2ec9a016aa0c4419bce01d4896e2ae3b-5287d2089db37e62345123a1be272f8b.mp4" OnViewController:self];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //加载第一个视频
//    yVideoPlayerView = [[YVideoPlayerView alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 200) VideoName:@"网络视频" Path:@"http://www.ybanerlv.com/02926b1240854ee78c07fa8ef3265896/2ec9a016aa0c4419bce01d4896e2ae3b-5287d2089db37e62345123a1be272f8b.mp4" OnViewController:self];

    
    NSLog(@"yVideoPlayerView=%@",yVideoPlayerView);
}


@end
