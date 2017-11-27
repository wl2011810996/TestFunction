//
//  PictureBrowseCollectionCell.h
//  testFunction
//
//  Created by 拓视 on 2017/11/22.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PictureBrowserModel;

@interface PictureBrowseCollectionCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, strong)PictureBrowserModel *item;

@end
