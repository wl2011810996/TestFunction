//
//  AppDelegate.m
//  testFunction
//
//  Created by 拓视 on 2017/8/21.
//  Copyright © 2017年 拓视. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"

#import "WXApi.h"

#define KAPPID  @"wxc0353065c5dc7dad"
#define KAppSecret @"8b8d5425a974b70060fd1f0a0cef0da7"

//#define KAPPID  @"wxe09f3dbee2e6ed26"
//#define KAppSecret @"87d42c6b3bb1a606e280798a8227f7bd"

#import "AFNetworking.h"

@interface AppDelegate ()<WXApiDelegate>{
     SendAuthResp *_temp;
    NSString *access_token;
    NSString *openid;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //wx76bc94cd9b0ecc22
    [WXApi registerApp:@"wx76bc94cd9b0ecc22"];
    
    return YES;
}

//请求
-(void) onReq:(BaseReq*)req
{
    
}

//返回
-(void) onResp:(BaseResp*)resp
{
    SendAuthResp *aresp = (SendAuthResp *)resp;
    NSLog(@"%d",aresp.errCode);
    if (aresp.errCode == 0) { // 用户同意
        
        if([resp isKindOfClass:[SendAuthResp class]])
        {
            _temp = (SendAuthResp*)resp;
            
            NSLog(@"%@",_temp.code);
            NSLog(@"%@",_temp.state);
            NSLog(@"%d",_temp.errCode);
            NSLog(@"%@",_temp.lang);
            NSLog(@"%@",_temp.country);
            
            [self firstGetWithUrl];
        }
    }else if (aresp.errCode == -2) //拒绝授权
    {

    }
    else if (aresp.errCode == -4)//取消
    {
        
    }
}

-(void)firstGetWithUrl
{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",KAPPID,KAppSecret,_temp.code];
    //通过code获取access_token
    [self getWithUrl:url];
}

-(void)getWithUrl:(NSString *)url
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //设置相应内容类型
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain" ,nil];
    
    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *refresh_token = dict [@"refresh_token"];
        
        NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",KAPPID,refresh_token];
        
        //刷新或续期access_token使用
        [self getWithUrlNext:url];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


-(void)getWithUrlNext:(NSString *)url
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //设置相应内容类型
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain" ,nil];
    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *dict1 = (NSDictionary *)responseObject;
        access_token = dict1 [@"access_token"];
        openid = dict1[@"openid"];
        
        NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/auth?access_token=%@&openid=%@",access_token,openid];
        //检验授权凭证（access_token）是否有效
        [self getWithUrlThird:url];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)getWithUrlThird:(NSString *)url
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //设置相应内容类型
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain" ,nil];
    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"%@",access_token);
        NSLog(@"%@",openid);
        
        NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
        
        //获取用户个人信息（UnionID机制）
        [self getWithUrlFour:url];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
  
}

-(void)getWithUrlFour:(NSString *)url
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //设置相应内容类型
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain" ,nil];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        

        [self saveWeiXinData:(NSDictionary *)responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


-(void)saveWeiXinData:(NSDictionary *)dict
{

    
    NSLog(@"%@",dict);
    NSString *nickname = dict[@"nickname"];
    NSString *openID = dict[@"openid"];
    NSString *unionid = dict [@"unionid"];
    NSString *sex = dict[@"sex"];
    NSString *headimgurl = @"";
    
    NSString *str = [NSString stringWithFormat:@"nickname:%@ openID:%@ unionid:%@ sex:%@",nickname,openID,unionid,sex];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    [alertView show];
    
 
}

#pragma mark 微信登陆成功后跳转
-(void)WeiXinLogin
{
    
    //    CustomTabbarController *VC = [[CustomTabbarController alloc]init];
    //    self.window.rootViewController=VC;

    
}


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
