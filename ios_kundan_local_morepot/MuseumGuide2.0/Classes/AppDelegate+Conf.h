//
//  AppDelegate+Configure.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/7.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "AppDelegate.h"
#import <UMSocialCore/UMSocialManager.h>
#import "TalkingData.h"
#import "AFNetworkReachabilityManager.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

static NSString *TalkingDataKey = @"5BA32CEC9B474050BC5295461894DDC7";
static NSString *JPushKey = @"60d3445b6c7f7e156a1dd241";
static NSString *JPushMaster = @"7b4a62c1024814822d12aff3";
static NSString *UMKey = @"57e4dfbde0f55ac3440043d0";
static NSString *BDMapKey = @"cwF6kGEk5Ew4wnoTNRXMdduLVe7Uifu8";
static NSString *wxKey = @"wx29a44cc4440d0f75";
static NSString *wxMch_id = @"1476037102";
static NSString *wxApi_key = @"heyunguanboshuzikejiyouxiangongs";
static NSString *wxSecret = @"7d92c1bc41acfdd7b42565467d8c15d4";
static NSString *qqKey = @"1105466312";
static NSString *sinaKey = @"351040176";
static NSString *sinaSecret = @"a6c917f8286aa3ed6a10c73597c71d8d";
static NSString *alipay_id = @"2017060207407914";


static BOOL isProduction = YES;
@interface AppDelegate (Conf)<JPUSHRegisterDelegate,BMKGeneralDelegate>

- (void)configThirdPlatform:(NSDictionary *)launchOptions;

@end
