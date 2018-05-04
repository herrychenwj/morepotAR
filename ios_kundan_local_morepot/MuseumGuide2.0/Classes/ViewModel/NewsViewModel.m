//
//  NewsViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "NewsViewModel.h"
#import "Communtil.h"
#import "NewsModel.h"
#import "AdvertisingModel.h"
#import "NewsDetailModel.h"
#import "ApiFactory+News.h"


@interface NewsViewModel ()

@property (nonatomic,assign,readwrite)NSInteger pageIndex;
@property (nonatomic,strong,readwrite)RACCommand *reloadNewsCmd;
@property (nonatomic,strong,readwrite)RACCommand *moreNewsCmd;
@property (nonatomic,strong,readwrite)RACCommand *advertCmd;


@end

@implementation NewsViewModel


- (NSInteger)pageIndex{
    if (!_pageIndex) {
        _pageIndex = 0;
    }
    return _pageIndex;
}

- (RACCommand *)reloadNewsCmd{
    if (!_reloadNewsCmd) {
        @weakify(self);
        _reloadNewsCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            self.pageIndex = 0;
            return [self newsSignal:input];
        }];
    }
    return _reloadNewsCmd;
}

- (RACCommand *)moreNewsCmd{
    if (!_moreNewsCmd) {
        @weakify(self);
        _moreNewsCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self newsSignal:input];
        }];
    }
    return _moreNewsCmd;
}

- (RACCommand *)detailCmd{
    if (!_detailCmd) {
        _detailCmd =  [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [[ApiFactory home_newsdetail:input]flattenMap:^RACStream *(id value) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    NewsDetailModel *detail = [NewsDetailModel mj_objectWithKeyValues:value];
                    [subscriber sendNext:detail.content];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }];
        }];
    }
    return _detailCmd;
}

- (RACCommand *)advertCmd{
    if (!_advertCmd) {
        _advertCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [[ApiFactory home_ads]flattenMap:^RACStream *(id value) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    NSArray *res = value[@"res"];
                    NSArray *adsAry = [AdvertisingModel mj_objectArrayWithKeyValuesArray:res];
                    [subscriber sendNext:adsAry];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }];
        }];
    }
    return _advertCmd;
}


- (RACSignal *)newsSignal:(MJRefreshComponent *)refresh{
    @weakify(self);
    return [[[[ApiFactory home_news:self.pageIndex] autoRefresh:refresh]flattenMap:^RACStream *(id value) {
        @strongify(self);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            NSArray *res = [value objectForKey:@"res"];
            NSArray *newsAry = [NewsModel mj_objectArrayWithKeyValuesArray:res];
            self.pageIndex += 1;
            [subscriber sendNext:newsAry];
            [subscriber sendCompleted];
            return nil;
        }];
    }]showErrorMsgTo:self.hudView];
}
- (void)dealloc{
    
}



@end
