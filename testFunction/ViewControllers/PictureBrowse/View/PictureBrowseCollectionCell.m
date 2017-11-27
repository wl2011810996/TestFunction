//
//  PictureBrowseCollectionCell.m
//  testFunction
//
//  Created by 拓视 on 2017/11/22.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "PictureBrowseCollectionCell.h"

#import "UIImageView+WebCache.h"
#import "PictureBrowserModel.h"

@implementation PictureBrowseCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    UIImageView *imageView = [UIImageView new];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    self.backgroundColor = [UIColor orangeColor];
}

- (void)setItem:(PictureBrowserModel *)item
{
    _item = item;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.thumbnail_pic]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}


@end
