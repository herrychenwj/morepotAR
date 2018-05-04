//
//  ApiFactory+News.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/14.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ApiFactory+News.h"

@implementation ApiFactory (News)
+ (RACSignal *_Nullable)home_newsdetail:(NSString * __nonnull)museum_news_id{
    return [[self api_get:API_NEWSDETAIL.apiPath params:@{@"museum_news_id":museum_news_id?:@""}] checkData];
}

+ (RACSignal *_Nullable)home_news:(NSInteger)pageIndex{
    return [[self api_get:API_NEWSLIST.apiPath params:@{@"page_index":[NSNumber numberWithInteger:pageIndex]}] checkData];
}
    + (RACSignal *_Nullable)home_ads{
    return [[self api_get:API_ADVERTISING.apiPath params:nil] checkData];
}
@end
