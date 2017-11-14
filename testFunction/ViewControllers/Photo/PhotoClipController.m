////
////  PhotoClipController.m
////  testFunction
////
////  Created by 拓视 on 2017/10/12.
////  Copyright © 2017年 拓视. All rights reserved.
////
//
#import "PhotoClipController.h"
#import "HKClipperHelper.h"

#import "UINavigationController+ZFFullscreenPopGesture.h"

@interface PhotoClipController ()<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoClipController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /********************************************备注**********************************************************/
    
    //拖动裁剪后的图片与全局返回手势冲突,只需将下面的两个方法放到裁剪方法里面去里面去
    self.zf_interactivePopDisabled = YES;  // 关闭某个控制器的pop手势（默认NO）
    self.zf_recognizeSimultaneouslyEnable = YES; //自定义的滑动返回手势是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
    
     /********************************************备注**********************************************************/
    
    
    
    __weak typeof(self)weakSelf = self;
    
    [self configHelperWithNav:self.navigationController
                      imgSize:self.imageView.frame.size
                   imgHandler:^(UIImage *img) {
                       weakSelf.imageView.image = img;
                   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HKClipperHelper

- (void)configHelperWithNav:(UINavigationController *)nav
                    imgSize:(CGSize)size
                 imgHandler:(void(^)(UIImage *img))handler {
    [HKClipperHelper shareManager].nav = nav;
    [HKClipperHelper shareManager].clippedImgSize = size;
    [HKClipperHelper shareManager].clippedImageHandler = handler;
}

#pragma mark - UIActionSheet

- (void)takePhoto {
    UIActionSheet *_sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照", @"相机胶卷", nil];
    [_sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    dispatch_after(0., dispatch_get_main_queue(), ^{
        if (buttonIndex == 0) {
            [[HKClipperHelper shareManager] photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else if(buttonIndex == 1) {
            [[HKClipperHelper shareManager] photoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    });
}

- (IBAction)buttonClick:(id)sender {
    
    [HKClipperHelper shareManager].clipperType = ClipperTypeImgStay;
    [HKClipperHelper shareManager].systemEditing = NO;
    [HKClipperHelper shareManager].isSystemType = NO;
    [self takePhoto];
}

@end

