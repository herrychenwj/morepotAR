//
//  ApiFactory+News.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/14.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ApiFactory.h"

@interface ApiFactory (News)
/**
 首页新闻列表
 */
+ (RACSignal *_Nullable)home_news:(NSInteger)pageIndex;


/**
 新闻详情
 */
+ (RACSignal *_Nullable)home_newsdetail:(NSString * __nonnull)museum_news_id;

/**
 首页广告
 */
+ (RACSignal *_Nullable)home_ads;
@end
