//
//  AppDelegate.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/24.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTarBarController.h"

#define kKuDanKey  @"vh49CYqFPneDV6GO1ZbCIIlSaMhb+VCj8xjWM3t2lrEmoHYtZpXLkO2fPuEZMqHovPvwz+cdUmMeshnaYZ7UTYduQ2WDlwUHyR8p0se/5katFnjbZKin84j2qZjmqU10DS1sXyQNvOTK/0yA1oM7+XDTJEQnGx2o6Y/g8Nxms+AfrRkXF38lhfkI2X+reBO66CXvkyLwSPUzc/lSviR7NOP1tz2RYF2lzXHm5vTqW0kw5gpuP4gYY2t/GoubU5CTr/thwYu6o6+q3oCx5Gkwmzm8+cV+41hwvkBVee5AAt7yB85UJSK1QarqGIK/ht7MdahRo13Jok3gqOmbKTwQMPT1qGlreMr/Vo0Cc+Am0gIOTjspkI+dI08RLuMIWvttELxwZT4JHEwzNLMpvFqW8OQevmiCxIvBxyVk5FqsHMQuDSKv01BaZwtl/QdyXh4DWv0bBDEidj0l9rzMdb9ARK0xy/jtaTGHt+l2B2GuAPMee1Fx7KBU/Mx46fPYspz80hjcnJIIm8Li98T9Glc1DN04/KupgIolPz+4227ooK9lqT9tF5acIFAsEKUrM3tg+uJ/m2jmlJkGmJKx/2zrOLf6u9WbhaDqUDeBnASSnckABcSMLshdV2ra//4YraA7WQRe/26Xk8oUzptMk3aZesipMLFFr21+l6yjFvZnWvI="

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[ARAPIKey sharedInstance]setAPIKey:kKuDanKey];
    [TXSakuraManager registerLocalSakuraWithNames:@[@"Localizable_en"]];
    [TXSakuraManager shiftSakuraWithName:@"Localizable_cn" type:TXSakuraTypeMainBundle];
    RootTarBarController *rootVC = [[RootTarBarController  alloc]init];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    return YES;
}






@end
