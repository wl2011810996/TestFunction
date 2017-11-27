//
//  PictureBrowseController.m
//  testFunction
//
//  Created by 拓视 on 2017/11/22.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "PictureBrowseController.h"
#import "PictureBrowseCollectionCell.h"
#import "SDPhotoBrowser.h"
#import "PictureBrowserModel.h"

@interface PictureBrowseController ()<SDPhotoBrowserDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation PictureBrowseController


static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray =[NSArray array];
   
    [self setupConfig];
    
}

-(void)setupConfig
{
    
    CGFloat margin = 20;
    int perRowItemCount = 3;
    CGFloat w = ([UIScreen mainScreen].bounds.size.width - (perRowItemCount - 1) * margin) / perRowItemCount;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(w, 100);
    layout.minimumInteritemSpacing = 10;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    
    
      [self.collectionView registerClass:[PictureBrowseCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    NSArray *srcStringArray = @[@"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
                                @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                                @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
                                @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                                @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                                @"http://ww1.sinaimg.cn/thumbnail/9be2329dgw1etlyb1yu49j20c82p6qc1.jpg"
                                ];
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < 30; i++) {
        int index = arc4random_uniform((int)srcStringArray.count);
        PictureBrowserModel *item = [PictureBrowserModel new];
        item.thumbnail_pic = srcStringArray[index];
        [temp addObject:item];
    }
    
    self.dataArray = [temp copy];
    
    [self.collectionView reloadData];
    
}

#pragma mark <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PictureBrowseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.item = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = self.dataArray.count;
    photoBrowser.sourceImagesContainerView = self.collectionView;
    
    [photoBrowser show];
}


#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    PictureBrowseCollectionCell *cell = (PictureBrowseCollectionCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    return cell.imageView.image;
    
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [[self.dataArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}



@end
