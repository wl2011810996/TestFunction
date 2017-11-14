//
//  BaseTabBarController.m
//  testFunction
//
//  Created by 拓视 on 2017/9/25.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *vr = [UIStoryboard storyboardWithName:@"GoogleVR" bundle:nil];
    UINavigationController *vrNavi = [vr instantiateInitialViewController];
    vrNavi.tabBarItem.title  = @"VR";
    vrNavi.tabBarItem.image = nil;
    vrNavi.tabBarItem.selectedImage = nil;
    
    [self setViewControllers:[NSArray arrayWithObjects:vrNavi, nil]];
    
    
    return;
}



@end
