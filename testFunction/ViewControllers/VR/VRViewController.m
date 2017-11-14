//
//  VRViewController.m
//  testFunction
//
//  Created by 拓视 on 2017/9/18.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "VRViewController.h"
#import "BitmapPlayerViewController.h"

@interface VRViewController ()

@end

@implementation VRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
}

- (IBAction)imageBtnClickThree:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test3" ofType:@"jpeg"];
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"dome_pic" ofType:@"jpg"];
    [self launchAsImage:[NSURL fileURLWithPath:path]];
}

- (IBAction)imageBtnClickTwo:(id)sender {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test2" ofType:@"jpeg"];
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"dome_pic" ofType:@"jpg"];
    [self launchAsImage:[NSURL fileURLWithPath:path]];
}



- (IBAction)imageBtnClick:(id)sender {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"test13" ofType:@"jpg"];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"dome_pic" ofType:@"jpg"];
    [self launchAsImage:[NSURL fileURLWithPath:path]];
}


- (void)launchAsImage:(NSURL*)url {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BitmapPlayer" bundle:nil];
    PlayerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"BitmapPlayerViewController"];
    
    [self presentViewController:vc animated:NO completion:^{
        [vc initParams:url];
    }];
}

@end
