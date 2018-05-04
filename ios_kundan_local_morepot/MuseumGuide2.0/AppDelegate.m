//
//  AppDelegate.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/24.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import "AppDelegate+Conf.h"
#import <UMSocialCore/UMSocialManager.h>
#import "RootTarBarController.h"
#import "DownloadFactory.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "LocalARManager.h"
#import "LocalJsonManager.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.exShowCount = 0;
//    self.arCount = 0;
    [self configThirdPlatform:launchOptions];
    RootTarBarController *rootVC = [[RootTarBarController  alloc]init];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];

    return YES;
}


// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    // 如果百川处理过会返回YES
    
    if (![[AlibcTradeSDK sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]) {
        // 处理其他app跳转到自己的app
        if ([url.host isEqualToString:@"safepay"]) {
            //一般只需要调用这一个方法即可
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSString *result = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]];
                if ([result isEqualToString:@"9000"]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:kREWARDSUCCESS object:nil];
                }
            }];
        }
        if([[url absoluteString] rangeOfString:[NSString stringWithFormat:@"%@://pay",wxKey]].location == 0)
        return [WXApi handleOpenURL:url delegate:self];
        else
        return [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    return YES;

}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    __unused BOOL isHandledByALBBSDK=[[AlibcTradeSDK sharedInstance] application:app openURL:url options:options];//处理其他app跳转到自己的app，如果百川处理过会返回YES
    if ([url.host isEqualToString:@"safepay"]) {
        //一般只需要调用这一个方法即可
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSString *result = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]];
            if ([result isEqualToString:@"9000"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:kREWARDSUCCESS object:nil];
            }
        }];
    }
    if([[url absoluteString] rangeOfString:[NSString stringWithFormat:@"%@://pay",wxKey]].location == 0)
        return [WXApi handleOpenURL:url delegate:self];
    else
        return [[UMSocialManager defaultManager] handleOpenURL:url options:options];
}

-(void)onResp:(BaseResp *)resp{
    NSString *strTitle;
    if ([resp isKindOfClass:[PayResp class]]) {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:{
                [[NSNotificationCenter defaultCenter]postNotificationName:kREWARDSUCCESS object:nil];
            }
                break;
            default:
                break;
        }
    }
    
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
      [DownloadFactory suspendDownloadTask];
      [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [DownloadFactory  resumeDownloadTask];
    //暂停播放声音
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"MuseumGuide2_0"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
