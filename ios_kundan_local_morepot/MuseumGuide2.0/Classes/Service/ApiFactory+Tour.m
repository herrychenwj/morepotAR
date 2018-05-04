//
//  ApiFactory+Tour.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/14.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ApiFactory+Tour.h"
#import "NSString+URL.h"
#import "LocalJsonManager.h"

@implementation ApiFactory (Tour)

//+ (RACSignal *_Nullable)tour_museuminfo:(NSString *__nonnull)museum_id{
//    return [[self api_get:API_MUSEUMINFO.apiPath params:@{@"museum_id":museum_id?:@""}]checkData];
//}

+ (RACSignal *_Nullable)tour_museuminfo:(NSString *__nonnull)museum_id{
//    return [[self api_get:API_MUSEUMINFO.apiPath params:@{@"museum_id":museum_id?:@""}]checkData];
    return [[LocalJsonManager rac_getlocalApi:@"museuminfo" folder:museumPath]checkData];
}


+ (RACSignal *)tour_museumlist:(id)params{
    return [[self api_get:API_MUSEUMLIST.apiPath params:params] checkData];
}
+ (RACSignal *)tour_ibeaconinfo:(NSString *__nonnull)museum_id{
    return [self api_get:API_IBEACONINFO.apiPath params:@{@"museum_id":museum_id?:@""}];
}


//+ (RACSignal *)tour_mapinfo:(NSString * __nonnull)museum_id{
//    return [[self api_get:API_MAPINFO.apiPath params:@{@"museum_id":museum_id?:@""}]checkData];
//}
+ (RACSignal *)tour_mapinfo:(NSString * __nonnull)museum_id{
    return [[LocalJsonManager rac_getlocalApi:@"mapinfo" folder:museumPath]checkData];
}

//+ (RACSignal *_Nullable)tour_exhibitInfo:(NSString *)exhibit_id{
//    return [[self api_get:API_EXHIBITINFO.apiPath params:@{@"exhibit_id":exhibit_id?:@""}]checkData];
//}

+ (RACSignal *_Nullable)tour_exhibitInfo:(NSString *)exhibit_id{
        return [[LocalJsonManager rac_getExhibitionInfo:exhibit_id]checkData];
}

//+ (RACSignal *_Nullable)tour_exhibitCmtlist:(NSString *)exhibit_id  pageIndex:(NSInteger)pageIndex{
//    return [[self api_get:API_COMMENTS.apiPath params:@{@"exhibit_id":exhibit_id?:@"",@"page_index":[NSNumber numberWithInteger:pageIndex]}] checkData];
//}

+ (RACSignal *_Nullable)tour_exhibitCmtlist:(NSString *)exhibit_id  pageIndex:(NSInteger)pageIndex{
//    return [[LocalJsonManager rac_getlocalApi:exhibit_id folder:commentPath]checkData];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@{@"comments":@[]}];
        [subscriber sendCompleted];

        return nil;
    }];
}


//+ (RACSignal *)tour_topexhibition:(NSString * __nonnull)museum_id{
//    return [[self api_get:API_TOPEXHIBITIONS.apiPath params:@{@"museum_id":museum_id?:@""}]checkData];
//}

+ (RACSignal *)tour_topexhibition:(NSString * __nonnull)museum_id{
    return [[LocalJsonManager rac_getlocalApi:@"topExhibits" folder:museumPath]checkData];
}


+ (RACSignal *)tour_exhibitlike:(NSString *__nonnull)exhibit_id{
    return [[self api_post:API_EXHIBITLIKE.apiPath params:@{@"exhibit_id":exhibit_id?:@""}]checkData];
}

+ (RACSignal *)tour_exhibitcmtlike:(NSString *__nonnull)cmt_id{
    return [[self api_post:API_LIKECMT.apiPath params:@{@"member_comment_id":cmt_id?:@""}]checkData];
}

+ (RACSignal *)tour_exhibitCmt:(NSString *__nonnull)exhibit_id content:(NSString *__nonnull)content{
    return [[self api_post:API_EXHIBITCMT.apiPath params:@{@"exhibit_id":exhibit_id?:@"",@"content":content?:@""}]checkData];
}

+ (RACSignal *)tour_exhibitFavourite:(NSArray *__nonnull)exhibit_ids{
    return [[self api_post:API_EXHIBITFAVOURITE.apiPath params:@{@"exhibit_ids":exhibit_ids.mj_JSONString}]checkData];
}
+ (RACSignal *)tour_ibeaconJson:(NSString *)jsonUrl{
    return [self api_get:jsonUrl params:nil];
}

+ (RACSignal *_Nullable)tour_mapsearch:(NSString *__nonnull)mueum_id keywords:(NSString *__nonnull)keywords{
    return [[self api_get:API_MAPSEARCH.apiPath params:@{@"museum_id":mueum_id?:@"",@"keyword":keywords?:@""}]checkData];
}

+ (RACSignal *_Nullable)tour_homesearch:(NSString *__nonnull)mueum_id keywords:(NSString *__nonnull)keywords{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSMutableArray *res = [NSMutableArray array];
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"localApi" ofType:@"bundle"];
        NSString *expathPath = [NSString stringWithFormat:@"%@/%@/%@",bundlePath,museumPath,[NSString stringWithFormat:@"%@.json",@"museum"]];
        NSDictionary *responseObject = [Communtil readlocalJsonFile:expathPath];
        NSArray *data = responseObject[@"data"][@"res"];
        for (NSDictionary *dic in data) {
            for (NSDictionary *ex in dic[@"exhibits"]){
                if([ex[@"name"] containsString:keywords]){
                    [res addObject:ex];
                }
            }
        }
        [subscriber sendNext:res];
        [subscriber sendCompleted];
        return nil;
    }];
}

//+ (RACSignal *_Nullable)tour_homesearch:(NSString *__nonnull)mueum_id keywords:(NSString *__nonnull)keywords{
//
//    return [[self api_get:API_HOMESEACH.apiPath params:@{@"museum_id":mueum_id?:@"",@"keyword":keywords?:@""}]checkData];
//}

//+ (RACSignal *_Nullable)tour_allexhibitions:(NSString *__nonnull )museum_id{
//    return [[self api_get:API_ALLEXHIBITS.apiPath params:@{@"museum_id":museum_id?:@""}]checkData];
//}

+ (RACSignal *_Nullable)tour_allexhibitions:(NSString *__nonnull )museum_id{
    return [[LocalJsonManager rac_getlocalApi:@"museum" folder:museumPath]checkData];
}


+ (RACSignal *_Nullable)tour_taobaoke:(NSString *__nonnull)museum_id{
    return [[self api_get:TAOBAOKE_URL.apiPath params:@{@"museum_id":museum_id?:@""}]checkData];
}

+ (RACSignal *_Nullable)tour_taobaokemuseumlist{
    return [[self api_get:API_TAOBAOKE.apiPath params:nil]checkData];
}


@end
