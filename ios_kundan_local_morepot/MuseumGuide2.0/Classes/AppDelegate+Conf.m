//
//  AppDelegate+Configure.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/7.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "AppDelegate+Conf.h"
#import <KudanAR/ARAPIKey.h>
#import <MagicalRecord/MagicalRecord.h>
#import <AlibcTradeBiz/AlibcTradeBiz.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "UTMini/AppMonitor.h"
#import <UTMini/AppMonitor.h>
#import <OpenMtopSDK/TBSDKLogUtil.h>
#import <TUnionTradeSDK/TUnionTradeSDK.h>

#define kKuDanKey  @"vh49CYqFPneDV6GO1ZbCIIlSaMhb+VCj8xjWM3t2lrEmoHYtZpXLkO2fPuEZMqHovPvwz+cdUmMeshnaYZ7UTYduQ2WDlwUHyR8p0se/5katFnjbZKin84j2qZjmqU10DS1sXyQNvOTK/0yA1oM7+XDTJEQnGx2o6Y/g8Nxms+AfrRkXF38lhfkI2X+reBO66CXvkyLwSPUzc/lSviR7NOP1tz2RYF2lzXHm5vTqW0kw5gpuP4gYY2t/GoubU5CTr/thwYu6o6+q3oCx5Gkwmzm8+cV+41hwvkBVee5AAt7yB85UJSK1QarqGIK/ht7MdahRo13Jok3gqOmbKTwQMPT1qGlreMr/Vo0Cc+Am0gIOTjspkI+dI08RLuMIWvttELxwZT4JHEwzNLMpvFqW8OQevmiCxIvBxyVk5FqsHMQuDSKv01BaZwtl/QdyXh4DWv0bBDEidj0l9rzMdb9ARK0xy/jtaTGHt+l2B2GuAPMee1Fx7KBU/Mx46fPYspz80hjcnJIIm8Li98T9Glc1DN04/KupgIolPz+4227ooK9lqT9tF5acIFAsEKUrM3tg+uJ/m2jmlJkGmJKx/2zrOLf6u9WbhaDqUDeBnASSnckABcSMLshdV2ra//4YraA7WQRe/26Xk8oUzptMk3aZesipMLFFr21+l6yjFvZnWvI="
//采集工具的key
//#define kKuDanKey  @"ZWvGeBEZvImAoZOfOhMak0J71c9NWFGP8p0sz8SNwkrO+fM+o5OAF/q30k9Y0xUGF8fKW8myCqBzJ/trQCHZnRpXyzlITCfbVCjSqPjnbAVT4KHZgT9yEJ3CdEfjq71tBOxnc9nLfKipzlnYio6IpIiJsIwiWh/iVSe27IbEgQy0HeNWsf5Q0elhGwhTAzhS5SIpGyuTQSi7GHczB9AmVM/h3Tq0rGhZmm3vgmqcj2lpdcccx42JzCAVcMxsXQMOBkv2nvTwbajUFzEnDB57agz9Tnb2NufOtIRKvlVM4yaG4cADN2bnOKnGht0N5/+Cn7mNYWUpHCI/YMCLXQS9QcgxhP1n/hn3ToF7S6R3LjDqYfPR+no69jOMGc7ie7DU7PlemIuJpCp46YFPeQxUYB0nM77GIs7nqFvrAsFAV6/8n2pLFskEAZ8g4Z6uqdxNheVwq4N9eMglfeAm2AGr2jsElKxGuieyyiak4BSjosEDdDCMsf0BLrI81svt57nQ6iMWBdA6Exi824XYFMMoSg5J3Ck2ibGYXI4h7i3gqzEnqJa/wknn4xZ+m+AwudT8nYSMmgWN47JaEge6IToiARRsJaf9TTNGBYIx9NFFxZfLbQTpe755jdq696ZQblZMxJnmUsR8RHJ79bbT+OxlPUdq64uxG7HFXKh9o19UgzQ="

@implementation AppDelegate (Conf)


- (void)configTaobaoke{
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
    [[AlibcTradeSDK sharedInstance] setEnv:AlibcEnvironmentRelease];
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        
    } failure:^(NSError *error) {
        
    }];
    
    // 开发阶段打开日志开关，方便排查错误信息
    //默认调试模式打开日志,release关闭,可以不调用下面的函数
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];
    
    // 配置全局的淘客参数
    //如果没有阿里妈妈的淘客账号,setTaokeParams函数需要调用
    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
    taokeParams.pid = @"mm_126444785_0_0"; //mm_XXXXX为你自己申请的阿里妈妈淘客pid
    [[AlibcTradeSDK sharedInstance] setTaokeParams:taokeParams];
    
    //设置全局的app标识，在电商模块里等同于isv_code
    //没有申请过isv_code的接入方,默认不需要调用该函数
//    [[AlibcTradeSDK sharedInstance] setISVCode:@"your_isv_code"];
    
    // 设置全局配置，是否强制使用h5
    [[AlibcTradeSDK sharedInstance] setIsForceH5:NO];
}
    
    
- (void)configThirdPlatform:(NSDictionary *)launchOptions{
    [[ARAPIKey sharedInstance]setAPIKey:kKuDanKey];

    if (![[NSUserDefaults standardUserDefaults]objectForKey:kLOCALIZABLE]) {
        
        NSString *language = [self language];
        if ([language isEqualToString:@"en"]) {
            [TalkingData trackEvent:@"英文版"];
        }
        [[NSUserDefaults standardUserDefaults]setObject:language forKey:kLOCALIZABLE];
    }
    NSString *localizable = [[NSUserDefaults standardUserDefaults]objectForKey:kLOCALIZABLE];
    [TXSakuraManager registerLocalSakuraWithNames:@[@"Localizable_cn",@"Localizable_en"]];
    [TXSakuraManager shiftSakuraWithName:[localizable isEqualToString:@"en"]?@"Localizable_en":@"Localizable_cn" type:TXSakuraTypeMainBundle];
    return;
    [self UMConfig];
    [self JPushConfig:launchOptions];
    [self reachability];
    [self configTaobaoke];
    //    [MagicalRecord setupAutoMigratingCoreDataStack];
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData sessionStarted:TalkingDataKey withChannelId:@"ios"];
    BMKMapManager *bmkMgr = [[BMKMapManager alloc]init];
    [BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL];
    [bmkMgr start:BDMapKey generalDelegate:self];
    if ([Communtil app_firstlunching]) { //第一次开启
        [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:kUSERSETTING_SOUND];
    }
    [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:kAPPLICATION_FIRSTLAUNCHING];
}

- (NSString *)language{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return  ([preferredLang hasPrefix:@"en"])?@"en":@"cn";
}

- (void)onGetNetworkState:(int)iError{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
- (void)reachability{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 3.开始监控
    [mgr startMonitoring];
}

- (void)JPushConfig:(NSDictionary *)launchOptions{
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey
                          channel:@"App Store"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
}


- (void)UMConfig{
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMKey];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:wxKey appSecret:wxSecret redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:qqKey/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:sinaKey  appSecret:sinaSecret redirectURL:@"https://morview.com"];
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif

@end
