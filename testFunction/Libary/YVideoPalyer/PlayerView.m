//
//  YPPlayer.m
//  视频播放
//
//  Created by 彦鹏 on 16/3/10.
//  Copyright © 2016年 Huyp. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

#define W self.frame.size.width
#define H self.frame.size.height

/* 从写初始化方法,初始化的同时,加载视频 */
CGFloat duration;
PlayerView * instace;
CGRect initialframe;

- (instancetype)initWithFrame:(CGRect)frame Path:(NSString *)path{
    
    self = [super initWithFrame:frame];
    if (self) {
        initialframe = frame;
        [self preparePlayWithPath:path];
    }

    return self;
}

/** 播放视频 */
- (void)preparePlayWithPath:(NSString *) path {
    self.frame = initialframe;
    self.userInteractionEnabled = NO;
    //获取文件的路径
//    NSLog(@"path=%@",path);
    NSURL * sourceMovieURL = [[NSURL alloc]init];
    if (path == nil) {
        NSLog(@"视频路径不正确");
        return;
    }
    if ([path hasPrefix:@"http"]) { //如果是本地视频,文件名请不要以http||https开头
        sourceMovieURL = [NSURL URLWithString:path];
    }
    else {
        sourceMovieURL = [NSURL fileURLWithPath:path];
    }
    //创建视频资源
    _movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    //创建播放项
    _playerItem = [AVPlayerItem playerItemWithAsset:_movieAsset];
    //创建播放器
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    //要显示AVPlayer,需要先将它放在一个AVPlayerLayer中,绘制出区域
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    //初始化frame
    self.frame = CGRectMake(0, 0, initialframe.size.width, initialframe.size.height);
    //先等于初始大小
    _playerLayer.frame = initialframe;

    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:_playerLayer];
    
    [_player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [_playerItem addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
//        NSLog(@"_player.status=%ld",(long)_player.status);
        if (_player.status == AVPlayerStatusFailed) {//准备失败
            [[NSNotificationCenter defaultCenter] postNotificationName:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
            return;
        }
        if (_player.status == AVPlayerStatusReadyToPlay) {//准备成功
            [_player play];
            return;
        }
    }
    //加载完成
    else if ([keyPath isEqualToString:@"duration"]) {
//        NSLog(@"(CGFloat)CMTimeGetSeconds(_playerItem.duration)=%f",(CGFloat)CMTimeGetSeconds(_playerItem.duration));
        if ((CGFloat)CMTimeGetSeconds(_playerItem.duration) != duration) {
            duration = (CGFloat)CMTimeGetSeconds(_playerItem.duration);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"startPlay" object:nil];
        }
    }
}

- (void)back:(id)sender {
    [self removeFromSuperview];
    [self removeObserver];
    duration = 0.0;
    _movieAsset = nil;
    _playerItem = nil;
    _player = nil;
    instace = nil;
}

- (void)removeObserver {
    [_player removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"duration"];
}

- (void)dealloc {
    NSLog(@"playerDealloc");
}

@end
