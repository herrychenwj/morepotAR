//
//  ApiFactory.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/14.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Communtil.h"
#import "MBProgressHUD+Add.h"
#import "NSErrorHelper.h"
#import "TalkingData.h"
#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>


static NSString *const BASE_API_URL = @"https://api.morview.com/v2.1/";
static NSString *const BASE_WEBURL = @"https://museum.morview.com/";
static NSString *const PAYMENT_URL = @"https://payment.morview.com/";

#pragma mark JSMS
static NSString *const JSMS_URL = @"https://api.sms.jpush.cn/v1/codes";
static NSString *const TAOBAOKE_URL = @"taobaoke";
#pragma mark PAYMENT
//static NSString *const PAYMENT_ALI = @"payment/alipay/purchase";
//static NSString *const PAYMENT_WX = @"payment/wechatpay/purchase";
//static NSString *const PATMENT_CONF = @"admin/base/iapConfig";
static NSString *const PAYMENT_IAP = @"payment/iap/purchase";
static NSString *const PAYMENT_NOTIFY = @"payment/iap/notify";
static NSString *const API_REFRESHTOKEN = @"refreshtoken";

#pragma mark NEWS
static NSString *const API_ADVERTISING = @"ads";
static NSString *const API_NEWSLIST = @"newsList";
static NSString *const API_NEWSDETAIL = @"newsDetail";

#pragma mark TOUR
static NSString *const API_MUSEUMLIST = @"museumListByGPS";
static NSString *const API_IBEACONINFO = @"museumiBeaconInfo";
static NSString *const API_ARRESOURCE = @"museumARResource";
static NSString *const API_MAPINFO = @"museumMapInfo";
static NSString *const API_MUSEUMINFO = @"museumInfo";
static NSString *const API_MAPSEARCH = @"mapSearch";
static NSString *const API_HOMESEACH = @"searchInfo";
static NSString *const API_TOPEXHIBITIONS = @"topExhibits";
static NSString *const API_ALLEXHIBITS = @"exhibits";
static NSString *const API_EXHIBITINFO = @"exhibitInfo";
static NSString *const API_COMMENTS = @"exhibitComments";
static NSString *const API_EXHIBITCMT = @"commentExhibit";
static NSString *const API_EXHIBITLIKE = @"likeExhibit";
//收藏展品
static NSString *const API_EXHIBITFAVOURITE = @"favoriteExhibit";
//收藏展品列表
static NSString *const API_EXHIBITFAV = @"favoriteExhibits";
static NSString *const API_EXHIBITFOOT = @"footprints";
#pragma  mark SETTING
static NSString *const API_FEEDBACK = @"systemFeedback";
static NSString *const API_LOGIN  = @"login";
static NSString *const API_MYCMTS = @"myComments";
static NSString *const API_USERCENTER = @"userCenter";
static NSString *const API_EDITAVATAR = @"editAvatar";
static NSString *const API_EDITNICKNAME = @"editNickname";
static NSString *const API_EDITGENDER = @"editSex";
static NSString *const API_EDITSIGNAL = @"editSignal";
static NSString *const API_EDITBIRTH = @"editBirth";
static NSString *const API_BINDPHONE = @"bindPhonenum";
static NSString *const API_LIKECMT = @"likeComment";
static NSString *const API_TAOBAOKE = @"museumListBytaobaoke";
@interface ApiFactory : NSObject

+ (RACSignal *)api_get:(NSString *)url params:(id)params;
+ (RACSignal *)api_post:(NSString *)url params:(id)params;
+ (RACSignal *)api_put:(NSString *)url params:(id)params;
+ (RACSignal *)api_uploadImage:(NSData *)imgData url:(NSString *)url;

@end



@interface AFHTTPSessionManager(Api)


- (void)defaultConf;

- (void)autoConf;

@end
