//
//  UITextViewTest.m
//  testFunction
//
//  Created by 拓视 on 2017/8/21.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "UITextViewTest.h"
#import "TestViewController.h"

@interface UITextViewTest ()

@end

@implementation UITextViewTest

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (IBAction)buttonClick:(id)sender {
    TestViewController *testVC = [[TestViewController alloc]init];
    [self.navigationController pushViewController:testVC animated:YES];
}


@end
