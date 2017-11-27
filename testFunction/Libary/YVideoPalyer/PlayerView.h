//
//  YPPlayer.h
//  视频播放
//
//  Created by 彦鹏 on 16/3/10.
//  Copyright © 2016年 Huyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerView : UIView 

@property (strong,nonatomic) AVPlayer * player;

@property (strong,nonatomic) AVPlayerItem * playerItem;

@property (strong,nonatomic) AVPlayerLayer *playerLayer;

@property (strong,nonatomic) AVAsset * movieAsset;

- (instancetype)initWithFrame:(CGRect)frame Path:(NSString *)path;
- (void)preparePlayWithPath:(NSString *) path;
- (void)back:(id)sender;
@end
