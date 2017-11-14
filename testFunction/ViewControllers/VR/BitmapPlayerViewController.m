//
//  BitmapPlayerViewController.m
//  MD360Player4iOS
//
//  Created by ashqal on 16/5/21.
//  Copyright © 2016年 ashqal. All rights reserved.
//

#import "BitmapPlayerViewController.h"

@interface BitmapPlayerViewController ()<IMDImageProvider>

@end

@implementation BitmapPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initPlayer{
    
    /////////////////////////////////////////////////////// MDVRLibrary
    MDVRConfiguration* config = [MDVRLibrary createConfig];
    
    [config displayMode:MDModeDisplayNormal];
    [config interactiveMode:MDModeInteractiveTouch];
    [config projectionMode:MDModeProjectionDome180];
    [config asImage:self];
    
    [config setContainer:self view:self.view];
    [config pinchEnabled:true];
    
    self.vrLibrary = [config build];
    /////////////////////////////////////////////////////// MDVRLibrary
   
}

-(void) onProvideImage:(id<TextureCallback>)callback {
    //
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:self.mURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if ( image && finished) {
            // do something with image
            if ([callback respondsToSelector:@selector(texture:)]) {
                
                [callback texture:image];
                
                
            }
        }

    }];
//    [downloader downloadImageWithURL:self.mURL options:0
//                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                                NSLog(@"progress:%ld/%ld",(long)receivedSize,(long)expectedSize);
//                                // progression tracking code
//                            }
//                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//                               if ( image && finished) {
//                                   // do something with image
//                                   if ([callback respondsToSelector:@selector(texture:)]) {
//                                       
//                                        [callback texture:image];
//                    
//                                       
//                                   }
//                               }
//                           }];
    
    
}


- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return  UIInterfaceOrientationPortrait;
    
}

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscapeRight;
//}
//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}



@end
