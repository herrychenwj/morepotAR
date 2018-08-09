//
//  AppDelegate.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/24.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTarBarController.h"

#define kKuDanKey  @"omSoSSdfD8JukniEKWtKw7jxSJpnEzi8RhQKwmVPNIFeH7C1gBP63L4iai9sqPOJZg0QtfTmjvRMFSQf4U0GfDbYoeY/63YKBHxh+gCD+XPqEslB6g3LliPBn9j7S3KbYdNlCo1VTRo0930LroB38qZnhxnGR8AyMTYQ423E3hzeCJH0UBJsTKqWnYAq8fYjYlXaDFQ4Kj9jWvYXXB3ipR8HpG4gikr6WAfU9hOZPlzvgTXLfM/J15WDPkl6yvCv4V32tRe0nFoQAqP/reAXfWAaTwIef4R2p+15ygGSrHFzOyaIT4+r2jUOLComxyxdB0TJs0rmaM5/eDHP6+QYbSL/NXET6xIesVfsTpqhzpdVGs2jzXle/PEbgy+ixIN6T0O28Nt/1QM4UT9cp1EUxx7srPIYbMW/4u2IoDDap3Bv5Buyw2JGKRxA0plfLKybSoKknuqrWTdmM4jga3TZFU+uqJEOmu/zX3LTk2f9E3+f1JSbqizxoRr31u4BwNgIZrhE8pL3iu7qfPO1azEas36FamSwlqmjQOQZQEYRB0g07tXOqa/BdbqUFcVEoIO55Su+WSqDmig1z+CP+sMdENP6xaTwJbc+9KOLTRnH/VNvWTn4dkLZK1Q5vt0mgASR1DTG6UMo5RVLhRZV7TzQK5WNGauHkxO0tfjADUJ+xL8="

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
