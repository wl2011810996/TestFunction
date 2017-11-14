//
//  GoogleVRController.m
//  testFunction
//
//  Created by 拓视 on 2017/9/25.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "GoogleVRController.h"

#import "GVROverlayView.h"
#import <GVRKit/GVRKit.h>

#import <AVKit/AVKit.h>
#import "GVRPanoramaView.h"

static const CGFloat kMargin = 16;
static const CGFloat kPanoViewHeight = 250;

@interface GoogleVRController ()<GVRRendererViewControllerDelegate>
@property(nonatomic) GVRRendererView *panoView;
@property(nonatomic,strong)GVRPanoramaView *imagePanoramaView;

@end

@implementation GoogleVRController



- (void)viewDidLoad {
    [super viewDidLoad];
    /*******************************************模态推出的控制器展示RV全屏有问题*********************************************/
    self.view.backgroundColor  = [UIColor whiteColor];
    
    GVRRendererViewController *viewController = [[GVRRendererViewController alloc] init];
    viewController.delegate = self;
    
    
    
        viewController.rendererView.overlayView.hidesFullscreenButton = NO;
    //    viewController.rendererView.overlayView.hidesWatermark = YES;
    _panoView = viewController.rendererView;

    [self.view addSubview:_panoView];
    
    [self addChildViewController:viewController];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    _panoView.frame = CGRectMake(kMargin,
                                 64+ kMargin,
                                 CGRectGetWidth(self.view.bounds) - 2 * kMargin,
                                 kPanoViewHeight);

    
}

#pragma mark - GVRRendererViewControllerDelegate
- (BOOL)shouldHideTransitionView
{
    return YES;
}


- (GVRRenderer *)rendererForDisplayMode:(GVRDisplayMode)displayMode {
    
    UIImage *image = [UIImage imageNamed:@"test17.jpeg"];
    GVRImageRenderer *imageRenderer = [[GVRImageRenderer alloc] initWithImage:image];
    
    [imageRenderer setSphericalMeshOfRadius:50
                                  latitudes:12
                                 longitudes:24
                                verticalFov:180
                              horizontalFov:360
                                   meshType:kGVRMeshTypeMonoscopic];
 
    GVRSceneRenderer *sceneRenderer = [[GVRSceneRenderer alloc] init];
    [sceneRenderer.renderList addRenderObject:imageRenderer];
    
    // Hide reticle in embedded display mode.
    if (displayMode == kGVRDisplayModeEmbedded) {
//        sceneRenderer.hidesReticle = YES;
    }
    
    return sceneRenderer;
}



@end
