//
//  WeiXinController.m
//  testFunction
//
//  Created by 拓视 on 2017/10/16.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "WeiXinController.h"
#import "WXApi.h"

//AppID：wx04d1cfa36ab3630c
@interface WeiXinController ()

@end

@implementation WeiXinController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
}

- (IBAction)weixinBtnClick:(id)sender {
    
    [self sendAuthRequest];
}


-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.state = @"1232";
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

@end
