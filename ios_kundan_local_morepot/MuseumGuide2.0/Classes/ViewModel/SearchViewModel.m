//
//  SearchViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "SearchViewModel.h"
#import "MapSearchModel.h"
#import "SearchAllModel.h"
#import "ApiFactory+Tour.h"

@interface SearchViewModel ()
@property (nonatomic,strong,readwrite)RACCommand *mapSeachCmd;
@property (nonatomic,strong,readwrite)RACCommand *homeSeachCmd;

@property (nonatomic,strong,readwrite)RACCommand *exhibitCmd;
@property (nonatomic,strong,readwrite)RACCommand *allExhibitCmd;

@property (nonatomic,strong)RACSignal *keyWordSignal;
@end

@implementation SearchViewModel

- (RACSignal *)keyWordSignal{
    if (!_keyWordSignal) {
        _keyWordSignal = RACObserve(self, keyword);
    }
    return _keyWordSignal;
}

- (RACCommand *)mapSeachCmd{
    if (!_mapSeachCmd) {
        @weakify(self);
        _mapSeachCmd =  [[RACCommand alloc]initWithEnabled:[self keyWordVerification] signalBlock:^RACSignal *(id input) {
            @strongify(self);
            [TalkingData trackEvent:self.basicInfo.museum_name label:@"搜索事件" parameters:@{self.keyword?:@"":self.keyword?:@""}];
            return [[[[ApiFactory tour_mapsearch:self.basicInfo.museum_id?:@""keywords:self.keyword?:@""] flattenMap:^RACStream *(id value) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    NSArray *res = [MapSearchModel mj_objectArrayWithKeyValuesArray:[value objectForKey:@"res"]];
                    if (res.count > 0) {
                        [subscriber sendNext:res];
                        [subscriber sendCompleted];
                    }else{
                        [subscriber sendError:[NSErrorHelper createErrorWithErrorInfo:[TXSakuraManager tx_stringWithPath:@"toast"]]];
                    }
                    return nil;
                }];
            }]talkingDataTracking:@"搜索事件" label:self.basicInfo.museum_name params:@{self.keyword?:@"":self.keyword?:@""}]showErrorMsgTo:self.hudView];
        }];
    }
    return _mapSeachCmd;
}

- (RACCommand *)homeSeachCmd{
    if (!_homeSeachCmd) {
        @weakify(self);
        _homeSeachCmd = [[RACCommand alloc]initWithEnabled:[self keyWordVerification] signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[[ApiFactory tour_homesearch:self.basicInfo.museum_id?:@""keywords:self.keyword?:@""] flattenMap:^RACStream *(id value) {
                [TalkingData trackEvent:self.basicInfo.museum_name label:@"搜索事件" parameters:@{self.keyword?:@"":self.keyword?:@""}];
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    NSArray *res = [MapSearchModel mj_objectArrayWithKeyValuesArray:value];
                    if (res.count > 0) {
                        [subscriber sendNext:res];
                        [subscriber sendCompleted];
                    }else{
                        [subscriber sendError:[NSErrorHelper createErrorWithErrorInfo:[TXSakuraManager tx_stringWithPath:@"toast"]]];
                    }
                    return nil;
                }];
            }]talkingDataTracking:@"搜索事件" label:self.basicInfo.museum_name params:@{self.keyword?:@"":self.keyword?:@""}]showErrorMsgTo:self.hudView];
        }];
    }
    return _homeSeachCmd;
}


- (RACCommand *)allExhibitCmd{
    if (!_allExhibitCmd) {
        @weakify(self);
        _allExhibitCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[ApiFactory tour_allexhibitions:self.basicInfo.museum_id?:@""]showErrorMsgTo:self.hudView] map:^id(id value) {
                return [SearchAllModel mj_objectArrayWithKeyValuesArray:[value objectForKey:@"res"]];
            }];
        }];
    }
    return _allExhibitCmd;
}

- (RACSignal *)keyWordVerification{
    return [self.keyWordSignal map:^id(NSString *value) {
        return @(![Communtil isBlankString:value] && value.length > 0);
    }];
}

- (void)dealloc{
    
}







@end
