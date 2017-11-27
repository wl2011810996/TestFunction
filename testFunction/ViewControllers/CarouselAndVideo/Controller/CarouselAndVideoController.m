//
//  CarouselAndVideoController.m
//  testFunction
//
//  Created by 拓视 on 2017/11/23.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "CarouselAndVideoController.h"
#import "CarouselPlayerController.h"
#import "MovieViewController.h"

#import "YVideoPlayerView.h"


#import <MediaPlayer/MediaPlayer.h>
#import <Masonry/Masonry.h>
#import <ZFDownload/ZFDownloadManager.h>
#import "ZFPlayer.h"
#import "UINavigationController+ZFFullscreenPopGesture.h"

#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CarouselAndVideoController ()<UIScrollViewDelegate,ZFPlayerDelegate>
{
    /// 引导页图片数组
    NSArray * picArray;
    /// 滚动视图
    UIScrollView * guideScrollView;
    
    int TimeNum;
    BOOL Tend;
    
    //    /// 立即体验button
    //
    //    UIButton * expenriceButton;
    
    YVideoPlayerView * yVideoPlayerView;
    
}

//滑动显示第几个和一共几个；
@property (nonatomic,retain) UIPageControl * pageCtrl;

@property (nonatomic, strong) UIButton * expenriceButton;

@property (nonatomic, strong) CarouselPlayerController *CarouselPlayer;

@property (nonatomic, strong) UIView *playView;

//@property(nonatomic,strong) CarouselPlayerController *vc;

@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) ZFPlayerModel *playerModel;

@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pictureButton;


@property (nonatomic, assign) BOOL isPlayCheck;

@end

@implementation CarouselAndVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    picArray = @[@"daoyou1",@"daoyou2",@"daoyou3"];
    
    //播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [self setUI];
    
    [self add];
    //    [NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(handleTimer:)  userInfo:nil  repeats: YES];
    _expenriceButton.userInteractionEnabled = YES;
}

-(void)playEnd
{
    [self.playView removeFromSuperview];
}

-(void)setUI{
    /// 滚动视图
    guideScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, 200+40)];
    
    guideScrollView.backgroundColor = [UIColor orangeColor];
    guideScrollView.contentSize = CGSizeMake(kMainScreenWidth * picArray.count,0);
    guideScrollView.showsHorizontalScrollIndicator = NO;
    guideScrollView.showsVerticalScrollIndicator = NO;
    guideScrollView.delegate = self;
    guideScrollView.bounces = NO;
    guideScrollView.pagingEnabled = YES;
    guideScrollView.userInteractionEnabled = YES;
    [self.view addSubview:guideScrollView];
    
    //滑动时显示的点
    self.pageCtrl=[[UIPageControl alloc] initWithFrame:CGRectMake((kMainScreenWidth-100)/2, kMainScreenHeight-30, 100, 20)];
    self.pageCtrl=[[UIPageControl alloc] initWithFrame:CGRectMake((kMainScreenWidth-100)/2, kMainScreenHeight, 100, 20)];
    self.pageCtrl.backgroundColor=[UIColor clearColor];
    self.pageCtrl.numberOfPages=picArray.count;
    self.pageCtrl.currentPage=0;
    self.pageCtrl.currentPageIndicatorTintColor = [UIColor colorWithRed:0/255.f green:224/255.f blue:153/255.f alpha:1];
    self.pageCtrl.pageIndicatorTintColor = [UIColor colorWithRed:246/255.f green:246/255.f blue:246/255.f alpha:1];
    //    [self.view addSubview:self.pageCtrl];
    
    //    /// 立即体验button
    //
    //    expenriceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    expenriceButton.frame = CGRectMake((kMainScreenWidth - 180)/2, kMainScreenHeight -94+25 , 180, 40);
    //    [expenriceButton setTitle:@"立即体验" forState:UIControlStateNormal];
    //    expenriceButton.backgroundColor = [UIColor blueColor];
    //    expenriceButton.userInteractionEnabled = NO;
    //    [expenriceButton addTarget:self action:@selector(expenrienceAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:expenriceButton];
    

    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    playButton.backgroundColor = [UIColor greenColor];
    playButton.frame = CGRectMake(30, 64+200+10, 60, 20);
    [playButton setImage:[UIImage imageNamed:@"daoyou1"]  forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"daoyou2"]  forState:UIControlStateSelected];
    playButton.selected = YES;
    [playButton addTarget:self action:@selector(videoSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    self.playButton = playButton;
    
    
    UIButton *pictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pictureButton.backgroundColor = [UIColor greenColor];
    pictureButton.frame = CGRectMake(kMainScreenWidth/2+ 30, 64+200+10, 60, 20);
    [pictureButton setImage:[UIImage imageNamed:@"daoyou1"]  forState:UIControlStateNormal];
       [pictureButton setImage:[UIImage imageNamed:@"daoyou2"]  forState:UIControlStateSelected];
        [pictureButton addTarget:self action:@selector(pictureSelected) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pictureButton];
    self.pictureButton = pictureButton;
    
}

-(void)pictureSelected
{
    [guideScrollView setContentOffset:CGPointMake(kMainScreenWidth,0) animated:YES];
}

-(void)videoSelected
{
     [guideScrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark - scrollView && page
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageCtrl.currentPage=scrollView.contentOffset.x/kMainScreenWidth;
    
    if (!_isPlayCheck) {
        
         if (self.pageCtrl.currentPage>=1) {
             [self.playButton setSelected:NO];
             [self.pictureButton setSelected:YES];
         }else{
             [self.playButton setSelected:YES];
             [self.pictureButton setSelected:NO];
         }
        
        return;
    }
    
    if (self.pageCtrl.currentPage>=1) {
        
        if ([self.playerView state] == ZFPlayerStatePlaying ) {
            [self.playerView pause];
            [self.playButton setSelected:NO];
            [self.pictureButton setSelected:YES];
        }
        
     
    }else{
        if ([self.playerView state] == ZFPlayerStatePause) {
            [self.playerView play];
            [self.playButton setSelected:YES];
            [self.pictureButton setSelected:NO];
        }
  
    }
    
}
#pragma mark - 5秒换图片
- (void) handleTimer: (NSTimer *) timer
{
    if (TimeNum % picArray.count == 0 ) {
        
        if (!Tend) {
            self.pageCtrl.currentPage++;
            
            if (self.pageCtrl.currentPage==self.pageCtrl.numberOfPages-1) {
                Tend=YES;
            }
        }else{
            self.pageCtrl.currentPage--;
            if (self.pageCtrl.currentPage==0) {
                Tend=NO;
            }
            
            
            
        }
        
        [UIView animateWithDuration:0.7 //速度0.7秒
                         animations:^{//修改坐标
                             guideScrollView.contentOffset = CGPointMake(self.pageCtrl.currentPage*kMainScreenWidth,0);
                         }];
    }
    
    
    TimeNum ++;
}


/**
 *@brief  进入应用手势方法
 **
 */
- (void)expenrienceAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *@brief  添加引导页图片
 **
 */
- (void)add{
    
    
    /// 立即体验button
    
    //    _expenriceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _expenriceButton.frame = CGRectMake((kMainScreenWidth - 180)/2, kMainScreenHeight -94+25 , 180, 40);
    //    [_expenriceButton setTitle:@"立即体验" forState:UIControlStateNormal];
    //
    //
    //    [_expenriceButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    //    [_expenriceButton setBackgroundColor:[UIColor whiteColor]];
    //
    //    //_expenriceButton.userInteractionEnabled = YES;
    //
    //    [_expenriceButton addTarget:self action:@selector(expenrienceAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    for (int i = 0; i < picArray.count; i++) {
        
      
        
        UIImageView * guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kMainScreenWidth,0, kMainScreenWidth,198)];
        
        [guideImageView setImage:[UIImage imageNamed:picArray[i]]];
        guideImageView.contentMode = UIViewContentModeScaleToFill;
        
        if (i==0) {
            
            UIView *playerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kMainScreenWidth,200)];
            playerView.backgroundColor= [UIColor yellowColor];
            playerView.userInteractionEnabled = YES;
            guideImageView.userInteractionEnabled = YES;
            
            
            UIButton *playerButton = [UIButton buttonWithType:UIButtonTypeCustom];
            playerButton.center = guideImageView.center;
            playerButton.bounds = CGRectMake(0, 0, 60, 60);
            playerButton.backgroundColor = [UIColor redColor];
            [playerView addSubview:guideImageView];
            [playerView addSubview:playerButton];
            
         
            
            [playerButton addTarget:self action:@selector(playerBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.playView addSubview:guideImageView];
            
           self.playView= playerView;
            
            [guideScrollView addSubview: self.playView];
            
            
            continue;
        }
        
        [guideScrollView addSubview:guideImageView];
        
        if (i == picArray.count-1) {
            guideImageView.userInteractionEnabled = YES;
            
            [self addGestureWithView:guideImageView andSelector:@selector(expenrienceAction:)];
            
            // [guideImageView addSubview:_expenriceButton];
        }
        
    }
}


-(void)playerBtnClick
{
//    CarouselPlayerController *vc = [[CarouselPlayerController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    
    NSLog(@"playerBtnClick");
    
    _isPlayCheck = YES;
    // 自动播放，默认不自动播放
    [self.playerView autoPlayTheVideo];
}


///手势
-(void)addGestureWithView:(UIView *)anView andSelector:(SEL)selctor{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:selctor];
    [anView addGestureRecognizer:tap];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView==guideScrollView) {
        long int theNum=guideScrollView.contentOffset.x/kMainScreenWidth;
        _pageCtrl.currentPage=theNum;
        if (theNum == picArray.count-1) {
            _expenriceButton.userInteractionEnabled = YES;
        }
    }
}


#pragma mark - Getter

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = @"这里设置视频标题";
        _playerModel.videoURL         = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ybanerlv.com/02926b1240854ee78c07fa8ef3265896/2ec9a016aa0c4419bce01d4896e2ae3b-5287d2089db37e62345123a1be272f8b.mp4"]];
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playView;
        //          _playerModel.fatherView       = self.playerFatherView;
        //        _playerModel.resolutionDic = @{@"高清" : self.videoURL.absoluteString,
        //                                       @"标清" : self.videoURL.absoluteString};
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = YES;
        
        // 打开预览图
        self.playerView.hasPreviewView = YES;
        
    }
    return _playerView;
}


@end
