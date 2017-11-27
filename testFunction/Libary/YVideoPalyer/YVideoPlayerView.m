//
//  YVideoPlayerView.m
//  YVideoPlayer
//
//  Created by 彦鹏 on 16/3/30.
//  Copyright © 2016年 Huyp. All rights reserved.
//

#import "YVideoPlayerView.h"

YVideoPlayerView * selfView;
NSString * instanceName;
CGRect instanceFrame;
NSString * instancePath;
UIViewController * onViewController;
#define ORIENTATION [UIDevice currentDevice].orientation

@interface YVideoPlayerView()

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenButton;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIImageView *centerImage;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIImageView *leftArrow;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet UILabel *brightLabel;

@end

@implementation YVideoPlayerView

@synthesize playerView,bottomView,currentLabel,leftLabel,playButton,fullScreenButton,progressSlider,topView,titleLabel,backButton,centerImage,centerLabel,isPlaying,isMaxing,isTopAndBottomShowing,canOrientationChange,topGradientLayer,bottomGradientLayer,panGesture,tapGesture,bottomViewPanGesture,topAndBottomViewHiddenTimer,hiddenCenterViewTimer,playTimer,hiddenBottomViewTimer,panDirection,panX,panY,brightness,volumeness,volumeViewSlider,volumeView,isTopAndBottomShouldShow,touchTime,leftArrow,volumeLabel,rightArrow,brightLabel,progressView;

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame VideoName:(NSString *)name Path:(NSString *)path OnViewController:(UIViewController *)OnViewController {
    self = [super initWithFrame:frame];
    if (self) {
        instanceName = name;
        instanceFrame = frame;
        instancePath = path;
        onViewController = OnViewController;
        //开始监听方向改变
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        selfView = [[NSBundle mainBundle] loadNibNamed:@"YVideoPlayerView" owner:nil options:nil].firstObject;
    }
    return self;
}

- (instancetype)initNewVideoWithName:(NSString *)name path:(NSString *)path onViewController:(UIViewController *)OnViewController{
    [[[UIApplication sharedApplication] keyWindow] willRemoveSubview:self];
    if (self != nil) {
        [self removeFromSuperview];
        [self clean];
        self = [[YVideoPlayerView alloc]initWithFrame:instanceFrame VideoName:name Path:path OnViewController:OnViewController];
    }
    return self;
}

- (void)awakeFromNib {
    
    //开始播放
    [self playWithPath:instancePath];
    
    //开始播放通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlay:) name:@"startPlay" object:nil];
    
    //播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //方向变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //初始化界面大小 开启这个view 必须先竖屏
    self.frame = instanceFrame;
    
    //超出父视图不显示
    self.clipsToBounds = YES;

    //加载所在ViewController后开启横竖屏切换
    canOrientationChange = YES;

    //多功能键
    [fullScreenButton addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    //返回键
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置渐变色图层
    [self initCAGradientLayer];
    
    //视频名称
    titleLabel.text = instanceName;
    
    //进度条归0
    progressSlider.value = 0.0f;

    //设置进度图片
    UIImage * thumbImage = [UIImage imageNamed:@"slider.png"];
    thumbImage = [self OriginImage:thumbImage scaleToSize:CGSizeMake(20, 20)];
    [progressSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    [progressSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];

    //添加点击屏幕弹出上下View事件
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self addGestureRecognizer:tapGesture];
    
    //设置isTopAndBottomShouldShow  //1:应该隐藏  2:保持显示
    isTopAndBottomShouldShow = @"2";
    [self addObserver:self forKeyPath:@"isTopAndBottomShouldShow" options:NSKeyValueObservingOptionNew context:nil];
    
    //隐藏centerView和centerLabel
    centerImage.hidden = YES;
    centerLabel.hidden = YES;
    
    //记录进入这个页面前的亮度
    brightness = [UIScreen mainScreen].brightness;
    
    //记录进入这个页面前的音量
    volumeness = volumeViewSlider.value;
    
    //显示视图
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}
#pragma mark - 删除提示箭头
- (void)removeArrow:(id)sender {
    [leftArrow removeFromSuperview];
    [rightArrow removeFromSuperview];
    [volumeLabel removeFromSuperview];
    [brightLabel removeFromSuperview];
}

#pragma mark - 设置图片大小
- (UIImage*)OriginImage:(UIImage*)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);//size为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    return scaledImage;
}

- (void)playWithPath:(NSString *)path {
    //初始化player
    playerView = [[PlayerView alloc]initWithFrame:CGRectMake(0, 0, instanceFrame.size.width, instanceFrame.size.height) Path:path];
    //添加在线视频缓冲通知
    [playerView.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    //添加player到view的最下层,开始播放
    [self insertSubview:playerView atIndex:0];
}

#pragma mark - 接收通知
//开始播放
- (void)startPlay:(id)sender {
    //正在播放
    isPlaying = YES;
    //初始化开始播放和进度条事件
    [self setButtonAction:nil];
    //添加平移手势识别
//    panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panOnScreen:)];
//    [self addGestureRecognizer:panGesture];
    //初始化进度条
    progressSlider.maximumValue = (CGFloat)CMTimeGetSeconds(playerView.playerItem.duration);
    progressSlider.minimumValue =  (CGFloat)CMTimeGetSeconds(playerView.playerItem.currentTime);
    //初始化起止时间Label
    currentLabel.text = [self timeFormatted:(int)(CMTimeGetSeconds(playerView.playerItem.currentTime))];
    leftLabel.text = [self timeFormatted:(int)(CMTimeGetSeconds(playerView.playerItem.duration))];

    //进度条随播放进度移动
    playTimer = [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(progressSliderMove:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:playTimer forMode:NSDefaultRunLoopMode];
    [playTimer fire];
    
    //显示提示箭头
    leftArrow.hidden = NO;
    rightArrow.hidden = NO;
    volumeLabel.hidden = NO;
    brightLabel.hidden = NO;
    //开始隐藏提示箭头
    [self performSelector:@selector(removeArrow:) withObject:nil afterDelay:3];
    //隐藏上下View
    [self topAndBottomViewWillDisAppear:nil];
    isTopAndBottomShowing = YES;
    
    [self playOrPause:nil];
}
//结束播放
- (void)playEnd:(id)sender {
    //进度归0
    progressSlider.value = 0.0;
    
    [playerView.player seekToTime:kCMTimeZero];
    
    [self topAndBottomViewDidAppear:nil];
    
    [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    
    [playerView.player pause];
    
    [playTimer setFireDate:[NSDate distantFuture]];
    
    isPlaying = NO;
    
    currentLabel.text = [self timeFormatted:(int)(CMTimeGetSeconds(playerView.playerItem.currentTime))];
    leftLabel.text = [self timeFormatted:(int)(CMTimeGetSeconds(playerView.playerItem.duration))];
}

#pragma mark - 进度条
- (void)progressSliderMove:(id)sender {

    //进度条
    progressSlider.value = (CGFloat)CMTimeGetSeconds([playerView.player currentTime]);
    //当前时间
    currentLabel.text = [self timeFormatted:(int)(CMTimeGetSeconds(playerView.playerItem.currentTime))];
    //剩余时间
    CGFloat leftTimeValue = (CGFloat)CMTimeGetSeconds([playerView.playerItem duration]) - (CGFloat)(CMTimeGetSeconds(playerView.playerItem.currentTime));
    if (leftTimeValue>0) {
        NSString * leftTime = [self timeFormatted:leftTimeValue];
        leftLabel.text = leftTime;
    }
}
//拖动进度条
- (void)progressSliderChange:(id)sender {
    [hiddenBottomViewTimer invalidate];
    [topAndBottomViewHiddenTimer invalidate];  //拖动时取消隐藏
    CMTime cmTime = CMTimeMake(progressSlider.value, 1);
    [playerView.player seekToTime:cmTime];
    currentLabel.text = [self timeFormatted:(int)(CMTimeGetSeconds(playerView.playerItem.currentTime))];
    CGFloat leftTimeValue = (CGFloat)CMTimeGetSeconds([playerView.playerItem duration]) - (CGFloat)(CMTimeGetSeconds(playerView.playerItem.currentTime));
    if (leftTimeValue>0) {
        NSString * leftTime = [self timeFormatted:leftTimeValue];
        leftLabel.text = leftTime;
    }
    hiddenBottomViewTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(topAndBottomViewDisAppear:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:hiddenBottomViewTimer forMode:NSDefaultRunLoopMode];
}

#pragma mark - 时间转换
- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = totalSeconds / 60;
    
    return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
}

#pragma mark - 手势识别
//点击屏幕
- (void)tapScreen:(id)sender {
    if (isTopAndBottomShowing) { //正在显示上下View
        [topAndBottomViewHiddenTimer invalidate];
        [self topAndBottomViewDisAppear:nil];
    }
    else {  //没有显示上下View
        [topAndBottomViewHiddenTimer invalidate];
        [self topAndBottomViewDidAppear:nil];
    }
}
//手指在屏幕上滑动
- (void)panOnScreen:(UIPanGestureRecognizer *)sender {
    //根据在view上Pan的位置，确定是调音量还是亮度
    CGPoint locationPoint = [sender locationInView:self];
    //NSLog(@"locationPoint %@",NSStringFromCGPoint(locationPoint));
    // 我们要响应水平移动和垂直移动
    // 根据上次和本次移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [sender velocityInView:self];
    CGFloat x = fabs(veloctyPoint.x);
    CGFloat y = fabs(veloctyPoint.y);

    if (panGesture.numberOfTouches == 0) {
        //2秒消失中间的view&label
        [hiddenCenterViewTimer invalidate];
        hiddenCenterViewTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hiddenCenterView) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:hiddenCenterViewTimer forMode:NSRunLoopCommonModes];
        //调整进度
        if (self.panDirection == PanDirectionVerticalMoved) {
            progressSlider.value = touchTime;
            CMTime cmTime = CMTimeMake(touchTime, 1);
            [playerView.player seekToTime:cmTime];
            if (isPlaying) {
                [playerView.player play];
            }
        }
    }
    
    // 判断是垂直移动还是水平移动
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{ // 开始移动
            //NSLog(@"x:%f  y:%f",veloctyPoint.x, veloctyPoint.y);
            // 使用绝对值来判断移动的方向
            if ((x < y)) { // 竖直移动
                panDirection = PanDirectionHorizontalMoved;
                //屏幕左侧 --> 调节亮度
                if (locationPoint.x < [UIScreen mainScreen].bounds.size.width/2) {
                    // 取消隐藏
                    centerImage.image = [UIImage imageNamed:@"brightness"];
                    // 给sumTime初值
                    centerLabel.text = [NSString stringWithFormat:@"%@/%@",currentLabel.text,[self timeFormatted:(int)CMTimeGetSeconds([playerView.playerItem duration])]];
                    centerImage.hidden = NO;
                    centerLabel.hidden = NO;
                    if (volumeView) {
                        [volumeView removeFromSuperview];
                    }
                }
                //屏幕右侧 --> 调节音量
                if (locationPoint.x > [UIScreen mainScreen].bounds.size.width/2) {
                    centerImage.hidden = YES;
                    centerLabel.hidden = YES;
                    [self configureVolume];
                }
            }
            if ((x > y)) { //水平移动
                self.panDirection = PanDirectionVerticalMoved;
                //记录开始触摸时候的时间进度
                touchTime = (int)(CMTimeGetSeconds(playerView.playerItem.currentTime));
                centerLabel.hidden = NO;
                centerImage.hidden = YES;
            }
        }
        case UIGestureRecognizerStateChanged: {
            [hiddenCenterViewTimer invalidate];
            if (self.panDirection == PanDirectionHorizontalMoved) { // 竖直移动
                //屏幕左侧 --> 调节亮度
                if (locationPoint.x < [UIScreen mainScreen].bounds.size.width/2) {
                    if (locationPoint.y < panY) {
                        [UIScreen mainScreen].brightness  += 0.01;
                    }
                    else if (locationPoint.y > panY) {
                        [UIScreen mainScreen].brightness  -= 0.01;
                    }
                    centerLabel.text = [NSString stringWithFormat:@"%d%%",(int)([UIScreen mainScreen].brightness*100)];
                    panY = locationPoint.y;
                }
                if (locationPoint.x > [UIScreen mainScreen].bounds.size.width/2) {
                    if (locationPoint.y < panY) {
                        volumeViewSlider.value  += 0.01;
                    }
                    else if (locationPoint.y > panY) {
                        volumeViewSlider.value  -= 0.01;
                    }
                    panY = locationPoint.y;
                }
            }
            if (self.panDirection == PanDirectionVerticalMoved) {//水平移动
                [self topAndBottomViewDidAppear:nil];
                self.panDirection = PanDirectionVerticalMoved;
                if (locationPoint.x > panX) {  //快进
                    if (touchTime >= (int)(CMTimeGetSeconds(playerView.playerItem.duration))) {
                        return;
                    }
                    touchTime += 1;
                    centerLabel.text = [NSString stringWithFormat:@"%@/%@",[self timeFormatted:touchTime],[self timeFormatted:(int)(CMTimeGetSeconds(playerView.playerItem.duration))]];
                }
                else if (locationPoint.x < panX) {  //后退
                    if (touchTime <= 0.0) {
                        return;
                    }
                    touchTime -= 1;
                    centerLabel.text = [NSString stringWithFormat:@"%@/%@",[self timeFormatted:touchTime],[self timeFormatted:(int)(CMTimeGetSeconds(playerView.playerItem.duration))]];
                }
                panX = locationPoint.x;
            }
        }
        case UIGestureRecognizerStateEnded: {

        };
    }
}
#pragma mark - centerImage&Label.hidden
- (void)hiddenCenterView {
    centerImage.hidden = YES;
    centerLabel.hidden = YES;
}

#pragma mark - 获取系统音量
- (void)configureVolume
{
    volumeView = [[MPVolumeView alloc]init];
    volumeView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    [volumeView sizeToFit];
    volumeView.showsVolumeSlider = NO;
    [self addSubview:volumeView];
    [volumeView userActivity];
    for (UIView *view in [volumeView subviews]){
        if ([[view.class description] isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isTopAndBottomShouldShow"]) {
        NSLog(@"isTopAndBottomShouldShow=%@",isTopAndBottomShouldShow);
        if ([change[@"new"] isEqualToString:@"1"]) {
            [self topAndBottomViewWillDisAppear:nil];
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        CMTime duration = playerView.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [progressView setProgress:timeInterval / totalDuration animated:NO];
    }
}
#pragma mark - 计算缓冲进度
- (NSTimeInterval)availableDuration {
    NSArray * ranges = [[playerView.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [ranges.firstObject CMTimeRangeValue];// 获取缓冲区域
    CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
    CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

#pragma mark - topAndBottomView
//显示
- (void)topAndBottomViewDidAppear:(id)sender {
    [topAndBottomViewHiddenTimer invalidate];
    __weak typeof(self) selfweak = self;
    [UIView animateWithDuration:0.2 animations:^{
        topView.transform = CGAffineTransformMakeTranslation(0, 0);
        bottomView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        isTopAndBottomShowing = YES;
        [selfweak setValue:@"1" forKey:@"isTopAndBottomShouldShow"];
    }];
}

//隐藏
- (void)topAndBottomViewWillDisAppear:(id)sender {
    [topAndBottomViewHiddenTimer invalidate];
    topAndBottomViewHiddenTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(topAndBottomViewDisAppear:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:topAndBottomViewHiddenTimer forMode:NSDefaultRunLoopMode];
}
- (void)topAndBottomViewDisAppear:(id)sender {
    __weak typeof(self) selfweak = self;
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        topView.transform = CGAffineTransformMakeTranslation(0,-topView.frame.size.height);
        bottomView.transform = CGAffineTransformMakeTranslation(0, bottomView.frame.size.height);
    } completion:^(BOOL finished) {
        isTopAndBottomShowing = NO;
        [selfweak setValue:@"2" forKey:@"isTopAndBottomShouldShow"];
    }];
}

#pragma mark - 按钮功能
- (void)setButtonAction:(id)sender {
    [playButton addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [progressSlider addTarget:self action:@selector(progressSliderChange:) forControlEvents:UIControlEventValueChanged];
}
//开始键
- (void)playOrPause:(id)sender {
    if (isPlaying == YES) {
        [playerView.player pause];
        [playTimer setFireDate:[NSDate distantFuture]];
        [topAndBottomViewHiddenTimer invalidate];
        [playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        isPlaying = NO;
    }
    else if (isPlaying == NO) {
        [playerView.player play];
        [playTimer setFireDate:[NSDate date]];
        [self topAndBottomViewWillDisAppear:nil];
        [playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        isPlaying = YES;
    }
    [self topAndBottomViewWillDisAppear:nil];
}

//最大化键
- (void)fullScreen:(id)sender {
    if (isMaxing == YES) {
        if (ORIENTATION != UIDeviceOrientationPortrait) {
            if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
                isMaxing = NO;
                SEL selector = NSSelectorFromString(@"setOrientation:");
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:[UIDevice currentDevice]];
                int val = UIInterfaceOrientationPortrait;
                [invocation setArgument:&val atIndex:2];
                [invocation invoke];
            }
        }
        else {
            self.frame = instanceFrame;
            playerView.frame = CGRectMake(0, 0, instanceFrame.size.width, instanceFrame.size.height);
            playerView.playerLayer.frame = CGRectMake(0, 0, instanceFrame.size.width, instanceFrame.size.height);
            isMaxing = NO;
            backButton.hidden = NO;
            //在plist中设置-->View controller-based status bar appearance = NO; 意思是UIApplication 对于status bar 的设置权限高于 UIViewController;
            [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
            [fullScreenButton setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
        }
    }
    else if (isMaxing == NO) {
        playerView.frame = [UIScreen mainScreen].bounds;
        playerView.playerLayer.frame = [UIScreen mainScreen].bounds;
        self.frame = [UIScreen mainScreen].bounds;
        isMaxing = YES;
        backButton.hidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
        [fullScreenButton setImage:[UIImage imageNamed:@"shrinkscreen"] forState:UIControlStateNormal];
    }
    [self topAndBottomViewWillDisAppear:nil];
}


#pragma mark - 获取所在ViewController
- (UIViewController *)superViewController:(id)sender {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - 方向变化
- (void)orientationChange:(id)sender {
    @synchronized (self) {
        if (ORIENTATION == UIDeviceOrientationLandscapeRight ||ORIENTATION == UIDeviceOrientationLandscapeLeft) {
            isMaxing = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
            self.frame = [UIScreen mainScreen].bounds;
            playerView.frame = [UIScreen mainScreen].bounds;
            playerView.playerLayer.frame = [UIScreen mainScreen].bounds;
            [fullScreenButton setImage:[UIImage imageNamed:@"shrinkscreen"] forState:UIControlStateNormal];
            backButton.hidden = YES;
        }
        else if (ORIENTATION == UIDeviceOrientationPortrait) {
            if (isMaxing == YES) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
                self.frame = [UIScreen mainScreen].bounds;
                playerView.frame = [UIScreen mainScreen].bounds;
                playerView.playerLayer.frame = [UIScreen mainScreen].bounds;
                [fullScreenButton setImage:[UIImage imageNamed:@"shrinkscreen"] forState:UIControlStateNormal];
                backButton.hidden = YES;
            }
            else if (isMaxing == NO){
                [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
                self.frame = instanceFrame;
                playerView.frame = CGRectMake(0, 0, instanceFrame.size.width, instanceFrame.size.height);
                playerView.playerLayer.frame = CGRectMake(0, 0, instanceFrame.size.width, instanceFrame.size.height);
                [fullScreenButton setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
                backButton.hidden = NO;
            }
        }
        else if (ORIENTATION == UIDeviceOrientationUnknown) {
            if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
                [[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
                self.frame = [UIScreen mainScreen].bounds;
                playerView.frame = [UIScreen mainScreen].bounds;
                playerView.playerLayer.frame = [UIScreen mainScreen].bounds;
                [fullScreenButton setImage:[UIImage imageNamed:@"shrinkscreen"] forState:UIControlStateNormal];
                backButton.hidden = YES;
            }
        }
        else if (ORIENTATION == UIDeviceOrientationFaceUp || ORIENTATION == UIDeviceOrientationFaceDown || ORIENTATION == UIDeviceOrientationPortraitUpsideDown) {
            return;
        }
        [self upDateCAGradientLayerFrame];
    }
}

#pragma mark - 设置渐变层
- (void)initCAGradientLayer
{
    //初始Top化渐变层
    topGradientLayer = [CAGradientLayer layer];
    topGradientLayer.frame = topView.bounds;
    //设置渐变颜色方向
    topGradientLayer.startPoint = CGPointMake(0, 0);
    topGradientLayer.endPoint = CGPointMake(0, 1);
    //设定颜色组
    topGradientLayer.colors = @[ (__bridge id)[UIColor blackColor].CGColor,
                                  (__bridge id)[UIColor clearColor].CGColor];
    //设定颜色分割点
    topGradientLayer.locations = @[@(0.0f) ,@(1.0f)];
    [topView.layer addSublayer:topGradientLayer];
    
    //初始buttom化渐变层
    bottomGradientLayer = [CAGradientLayer layer];
    bottomGradientLayer.frame = bottomView.bounds;
    //设置渐变颜色方向
    bottomGradientLayer.startPoint = CGPointMake(0, 0);
    bottomGradientLayer.endPoint = CGPointMake(0, 1);
    //设定颜色组
    bottomGradientLayer.colors = @[ (__bridge id)[UIColor clearColor].CGColor,
                                     (__bridge id)[UIColor blackColor].CGColor];
    //设定颜色分割点
    bottomGradientLayer.locations = @[@(0.0f) ,@(1.0f)];
    [bottomView.layer addSublayer:bottomGradientLayer];
}
//更新渐变色条
- (void)upDateCAGradientLayerFrame {
    CGRect tempTop = topView.frame;
    tempTop.size.width = self.frame.size.width;
    topView.frame = tempTop;
    
    CGRect tempBottom = bottomView.frame;
    tempBottom.size.width = self.frame.size.width;
    bottomView.frame = tempBottom;
    
    topGradientLayer.frame = topView.bounds;
    bottomGradientLayer.frame = bottomView.bounds;
}

#pragma mark - 退出
//返回键
- (void)back:(id)sender {
    [self clean];
    //返回上一个页面
    [onViewController dismissViewControllerAnimated:YES completion:nil];
    onViewController = nil;
    NSLog(@"self=%@",self);
}

- (void)clean{
    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    //记录退后时的时间
    self.cmtime = playerView.playerItem.currentTime;
    //记录退后时的画面
    self.thumbnail = [self getThumbnail];
    
    [self removeObserver];
    
    [playerView back:nil];
    
    playerView = nil;
    
    [self removeFromSuperview];
    
    canOrientationChange = NO;
    //还原屏幕亮度
    [UIScreen mainScreen].brightness = brightness;
    //还原声音大小
    volumeViewSlider.value = volumeness;
    //删除动作
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //删除timer
    [topAndBottomViewHiddenTimer invalidate];
    [playTimer invalidate];
    [hiddenCenterViewTimer invalidate];
    [hiddenBottomViewTimer invalidate];
    //清空自己
    selfView = nil;
}

- (UIImage *)getThumbnail {
    AVAssetImageGenerator * imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:playerView.movieAsset];
    CMTime time = CMTimeMakeWithSeconds((CMTimeGetSeconds(playerView.playerItem.currentTime)), 90);
    struct CGImage * cgimage;
    @try {
        cgimage = [imageGenerator copyCGImageAtTime:time actualTime:nil error:nil];
    } @catch (NSException *exception) {
        NSLog(@"exception=%@",exception);
    }
    UIImage * image;
    if (cgimage != nil) {
        image = [UIImage imageWithCGImage:cgimage];
    }
    return image;
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startPlay" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    //移除设备方向改变通知
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    //KVO
    [self removeObserver:self forKeyPath:@"isTopAndBottomShouldShow"];
    [playerView.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (void)dealloc {
    NSLog(@"YVideoDelloc");
}

@end
