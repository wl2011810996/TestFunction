//
//  PictureSelectController.m
//  testFunction
//
//  Created by 拓视 on 2017/11/27.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "PictureSelectController.h"
#import "ZLPhotoActionSheet.h"
//#import <ZLPhotoActionSheet.h>
#import "ZLPhotoConfiguration.h"

@interface PictureSelectController ()

@end

@implementation PictureSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    
    
    
    
    //相册参数配置
    ZLPhotoConfiguration *configuration = [ZLPhotoConfiguration defaultPhotoConfiguration];
    ac.configuration = configuration;
    
#pragma mark - 参数配置 optional，可直接使用 defaultPhotoConfiguration

    //以下参数为自定义参数，均可不设置，有默认值
    configuration.sortAscending = YES;
    configuration.allowSelectImage = YES;
    configuration.allowSelectGif = YES;
    configuration.allowSelectVideo = YES;
    configuration.allowSelectLivePhoto = YES;
    configuration.allowForceTouch = YES;
    configuration.allowEditImage = YES;
    configuration.allowEditVideo = YES;
    configuration.allowSlideSelect = YES;
    configuration.allowMixSelect = YES;
    configuration.allowDragSelect = YES;
    //设置相册内部显示拍照按钮
    configuration.allowTakePhotoInLibrary = YES;
    //设置在内部拍照按钮上实时显示相机俘获画面
    configuration.showCaptureImageOnTakePhotoBtn = YES;
    //设置照片最大预览数
    configuration.maxPreviewCount = 9;
    //设置照片最大选择数
    configuration.maxSelectCount = 9;
    //设置允许选择的视频最大时长
    configuration.maxVideoDuration = 60;
    //设置照片cell弧度
//    configuration.cellCornerRadio = self.cornerRadioTextField.text.floatValue;
    //单选模式是否显示选择按钮
    //    configuration.showSelectBtn = YES;
    //是否在选择图片后直接进入编辑界面
    configuration.editAfterSelectThumbnailImage = YES;
    //设置编辑比例
    //    configuration.clipRatios = @[GetClipRatio(1, 1)];
    //是否在已选择照片上显示遮罩层
    configuration.showSelectedMask = YES;
    //颜色，状态栏样式
    //    configuration.selectedMaskColor = [UIColor purpleColor];
    //    configuration.navBarColor = [UIColor orangeColor];
    //    configuration.navTitleColor = [UIColor blackColor];
    //    configuration.bottomBtnsNormalTitleColor = kRGB(80, 160, 100);
    //    configuration.bottomBtnsDisableBgColor = kRGB(190, 30, 90);
    //    configuration.bottomViewBgColor = [UIColor blackColor];
    //    configuration.statusBarStyle = UIStatusBarStyleDefault;
    //是否允许框架解析图片
    configuration.shouldAnialysisAsset = YES;
    //框架语言
    configuration.languageType = YES;
    //是否使用系统相机
    //    configuration.useSystemCamera = YES;
    //    configuration.sessionPreset = ZLCaptureSessionPreset1920x1080;
    
    //如调用的方法无sender参数，则该参数必传
    ac.sender = self;
    
    //选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        //your codes
    }];
    
    //调用相册
    [ac showPreviewAnimated:YES];
    
//    //预览网络图片
//    [ac previewPhotos:arrNetImages index:0 hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
//        //your codes
//    }];

    
    
    
}


@end
