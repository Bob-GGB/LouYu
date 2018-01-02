//
//  AppDelegate.m
//  LouYu
//
//  Created by barby on 2017/7/14.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "AppDelegate.h"

#import "RootTabController.h"

#import "LoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <JPUSHService.h>
#import "RegularBusinessTools.h"
#import "WarnDetailViewController.h"
#import "EventDetailViewController.h"
@interface AppDelegate ()<JPUSHRegisterDelegate>
@property(nonatomic,strong)NSNumber *tokenStr;
@property(nonatomic,copy)NSString *aliasStr;
@property (nonatomic,strong) NSNumber *codeNum;
@property (nonatomic,strong) NSNumber *warnIDNum;
@property (nonatomic,strong) NSNumber *workIDNum;

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //设置状态栏颜色
    //设置状态栏字体颜色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    ;
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    [self.window makeKeyAndVisible];
    
    //以iphone5，5s，5c为基本机型，其他型号机器按比例系数做乘法.
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    if(KscreenHeight > 480){ // 这里以(iPhone4S)为准
        app.autoSizeScaleX = KscreenWidth/320;
        app.autoSizeScaleY = KscreenHeight/568;
    }else{
        app.autoSizeScaleX = 1.0;
        app.autoSizeScaleY = 1.0;
    }
    


    /*******************************友盟分享·初始化*************************************/
    
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];

    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[defaults dictionaryForKey:@"UserInfoDic"];
    //取到userInfo
    NSDictionary *userDic=dic[@"content"][@"userInfo"];
    self.aliasStr=[NSString stringWithFormat:@"%@",userDic[@"userID"]];
    if (userDic[@"roleID"]!=NULL) {
        [self.window setRootViewController:[[RootTabController alloc] init]];
        
    }
    else{
        
        [self.window setRootViewController:[[LoginViewController alloc] init]];
        
        
    }
#pragma mark ========== 推送代码==========
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"59f1b24f26cd43f6ee0cba29"
                          channel:@"App Store"
                 apsForProduction:true
            advertisingIdentifier:nil];
   
    
    #pragma mark ========== 自定义消息推送设置==========
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    #pragma mark ========== 版本检查更新==========
     [RegularBusinessTools CheckTheUpdateWithAppID:@"1289101655"];//APPID 1289101655
   
    
    return YES;
}
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
   
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx22006fc61e72b8f5" appSecret:@"7c1a46e201136f34172bd20d7c5671d3" redirectURL:nil];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone appKey:@"1106316999"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    
}

//系统回调
//#define __IPHONE_10_0    100000
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响。
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark ========== 推送代理方法==========
#pragma mark -- 点击通知中心里面的远程推送，使App从后台进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
   
   
}

// iOS 10 Support

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    NSLog(@"userInfo------:%@",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSString *types=[userInfo valueForKey:@"type"];
        NSError *err;
        NSData *jsonData = [types dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        self.codeNum=dic[@"code"];
        self.warnIDNum=dic[@"warnID"];
        self.workIDNum=dic[@"workID"];
        
           [self goToMssageViewController];
    }
    completionHandler();  // 系统要求执行这个方法
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
        
        [self goToMssageViewController];
    }else{
        [self goToMssageViewController];
    }
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
   
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
    
     [self goToMssageViewController];
   
}
#pragma mark ========== 自定义消息方法==========
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
   NSString *types=[extras valueForKey:@"type"];
//
//    NSMutableArray *topLevelArray = [NSMutableArray arrayWithArray:types];
//    NSDictionary *dict = topLevelArray[0];
//    for (NSDictionary * subDic in dict) {
//        self.codeNum=subDic[@"code"];
//        self.warnIDNum=@([[subDic valueForKey:@"warnID"] integerValue]);
//
//    }
    NSError *err;
    NSData *jsonData = [types dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
   
            self.codeNum=dic[@"code"];
            self.warnIDNum=dic[@"warnID"];
            self.workIDNum=dic[@"workID"];
//     NSLog(@"-----------codeNum:%@,warnIDNum:%@",self.codeNum,self.warnIDNum);
    [ClearCache showHUDWithText:content];
    
}


#pragma mark ========== 点击通知跳转相应的界面==========

- (void)goToMssageViewController{
   
//    NSLog(@"codeNum:%@,warnIDNum:%@",self.codeNum,self.warnIDNum);
    WarnDetailViewController *warnVC=[[WarnDetailViewController alloc] init];
    [warnVC setHidesBottomBarWhenPushed:YES];

    EventDetailViewController *eventVC=[[EventDetailViewController alloc]init];
    [eventVC setHidesBottomBarWhenPushed:YES];
    if ([_codeNum isEqualToNumber:@2]) {

        warnVC.warnIDStr=_warnIDNum;
        [[self topViewController].navigationController pushViewController:warnVC animated:YES];
        
    }
   if ([_codeNum isEqualToNumber:@1]){
//       NSLog( @"-----%@",self.warnIDNum);
        eventVC.workIDnum=_workIDNum;
        eventVC.statusNum=@1;
        [[self topViewController].navigationController pushViewController:eventVC animated:YES];
       
    }
    
}
#pragma mark   通过我下面的函数可以获取当前的controller
- (UIViewController*)topViewController{
    return [self topViewControllerWithRootViewController:self.window.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}




- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
