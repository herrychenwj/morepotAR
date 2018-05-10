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

@implementation ApiFactory

@end


@implementation ApiFactory (Tour)


+ (RACSignal *_Nullable)tour_museuminfo:(NSString *__nonnull)museum_id{
    return [[LocalJsonManager rac_getlocalApi:@"museuminfo" folder:museumPath]checkData];
}


+ (RACSignal *)tour_mapinfo:(NSString * __nonnull)museum_id{
    return [[LocalJsonManager rac_getlocalApi:@"mapinfo" folder:museumPath]checkData];
}


+ (RACSignal *_Nullable)tour_exhibitInfo:(NSString *)exhibit_id{
        return [[LocalJsonManager rac_getExhibitionInfo:exhibit_id]checkData];
}

+ (RACSignal *_Nullable)tour_exhibitCmtlist:(NSString *)exhibit_id  pageIndex:(NSInteger)pageIndex{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@{@"comments":@[]}];
        [subscriber sendCompleted];
        return nil;
    }];
}

+ (RACSignal *)tour_topexhibition:(NSString * __nonnull)museum_id{
    return [[LocalJsonManager rac_getlocalApi:@"topExhibits" folder:museumPath]checkData];
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

+ (RACSignal *_Nullable)tour_allexhibitions:(NSString *__nonnull )museum_id{
    return [[LocalJsonManager rac_getlocalApi:@"museum" folder:museumPath]checkData];
}




@end
