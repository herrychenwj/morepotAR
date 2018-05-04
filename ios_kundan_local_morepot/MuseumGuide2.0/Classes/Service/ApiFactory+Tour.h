//
//  ApiFactory+Tour.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/14.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ApiFactory.h"

@interface ApiFactory (Tour)
/**
 加载博物馆列表
 */
+ (RACSignal *_Nullable)tour_museumlist:(id _Nullable )params;

/**
 加载ibeacon信息
 */
+ (RACSignal *_Nullable)tour_ibeaconinfo:(NSString *__nonnull)museum_id;

/**
 获取博物馆信息
 */
+ (RACSignal *_Nullable)tour_museuminfo:(NSString *__nonnull)museum_id;



/**
 加载展品信息
 */
+ (RACSignal *_Nullable)tour_exhibitInfo:(NSString *__nonnull)exhibit_id;


/**
 展品评论列表
 */
+ (RACSignal *_Nullable)tour_exhibitCmtlist:(NSString * __nonnull)exhibit_id  pageIndex:(NSInteger)pageIndex;

/**
 展品点赞
 */
+ (RACSignal *_Nullable)tour_exhibitlike:(NSString *__nonnull)exhibit_id;



+ (RACSignal *_Nullable)tour_exhibitCmt:(NSString *__nonnull)exhibit_id content:(NSString *__nonnull)content;



/**
 展品评论点赞
 
 @param cmt_id 评论ID
 @return <#return value description#>
 */
+ (RACSignal *_Nullable)tour_exhibitcmtlike:(NSString *__nonnull)cmt_id;


/**
 博物馆地图信息加载
 
 @param museum_id 博物馆ID
 @return <#return value description#>
 */
+ (RACSignal *_Nullable)tour_mapinfo:(NSString * __nonnull)museum_id;


/**
 头部展品加载
 
 @param museum_id 博物馆ID
 */
+ (RACSignal *_Nullable)tour_topexhibition:(NSString * __nonnull)museum_id;


/**
 地图搜索
 
 @param mueum_id 博物馆ID
 @param keywords 搜索关键字
 @return 搜索结果
 */
+ (RACSignal *_Nullable)tour_mapsearch:(NSString *__nonnull)mueum_id keywords:(NSString *__nonnull)keywords;

/**
 首页搜索
 
 @param mueum_id 博物馆ID
 @param keywords 搜索关键字
 @return 搜索结果
 */
+ (RACSignal *_Nullable)tour_homesearch:(NSString *__nonnull)mueum_id keywords:(NSString *__nonnull)keywords;


/**
 所有展品
 
 @param museum_id 博物馆ID
 */
+ (RACSignal *_Nullable)tour_allexhibitions:(NSString *__nonnull )museum_id;


/**
 展品收藏
 
 @param exhibit_ids 数组字符串
 @return <#return value description#>
 */
+ (RACSignal *_Nullable)tour_exhibitFavourite:(NSArray *__nonnull)exhibit_ids;
+ (RACSignal *_Nullable)tour_ibeaconJson:(NSString *__nonnull)jsonUrl;

/**
 博物馆淘宝客API

 @param museum_id  博物馆ID
 @return
 */
+ (RACSignal *_Nullable)tour_taobaoke:(NSString *__nonnull)museum_id;


+ (RACSignal *_Nullable)tour_taobaokemuseumlist;



@end
