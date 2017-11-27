//
//  YVideoPlayerView.h
//  YVideoPlayer
//
//  Created by 彦鹏 on 16/3/30.
//  Copyright © 2016年 Huyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface YVideoPlayerView : UIView

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, //横向移动
    PanDirectionVerticalMoved    //纵向移动
};

typedef NS_ENUM(NSInteger,TopAndBottomShouldShow) {
    shouldHidden,
    shouldShow,
};

@property (strong,nonatomic) PlayerView * playerView;

@property (assign,nonatomic) BOOL isPlaying;

@property (assign,nonatomic) BOOL isMaxing;

@property (assign,nonatomic) BOOL canOrientationChange;

@property (assign,nonatomic) __block BOOL isTopAndBottomShowing;

@property (assign,nonatomic) __block NSString * isTopAndBottomShouldShow; //1:准备隐藏 2:保持显示

@property (strong,nonatomic) CAGradientLayer * topGradientLayer;

@property (strong,nonatomic) CAGradientLayer * bottomGradientLayer;

@property (strong,nonatomic) UIPanGestureRecognizer * panGesture;

@property (strong,nonatomic) UIGestureRecognizer * bottomViewPanGesture;

@property (strong,nonatomic) UITapGestureRecognizer * tapGesture;

@property (strong,nonatomic) NSTimer * topAndBottomViewHiddenTimer;

@property (strong,nonatomic) NSTimer * playTimer;

@property (strong,nonatomic) NSTimer * hiddenCenterViewTimer;

@property (strong,nonatomic) NSTimer * hiddenBottomViewTimer;

@property (nonatomic, assign) PanDirection panDirection;

@property (assign,nonatomic) CGFloat brightness;

@property (assign,nonatomic) CGFloat volumeness;

@property (strong,nonatomic) MPVolumeView * volumeView;

@property (strong,nonatomic) UISlider * volumeViewSlider;

@property (assign,nonatomic) CGFloat panX;

@property (assign,nonatomic) CGFloat panY;

@property (assign,nonatomic) int touchTime;  //记录滑动开始的时间


- (instancetype)initWithFrame:(CGRect)frame VideoName:(NSString *)name Path:(NSString *)path OnViewController:(UIViewController *)OnViewController;

@property (strong,nonatomic) UIImage * thumbnail;  //在切换视频和返回时记录当前画面

@property (assign,nonatomic) CMTime cmtime;  //在切换视频和返回时记录当前时间

- (instancetype)updateVideoWithName:(NSString *)name path:(NSString *)path onViewController :(UIViewController *)OnViewController;
- (void)back:(id)sender;
- (void)playOrPause:(id)sender ;

- (void)clean;
@end
