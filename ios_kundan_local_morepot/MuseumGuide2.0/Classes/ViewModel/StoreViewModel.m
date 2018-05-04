//
//  StoreViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/11/8.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "StoreViewModel.h"
#import "ApiFactory+Tour.h"
#import "DiscoverModel.h"
#import "MuseumListModel.h"
#import "MuseumModel.h"
@interface StoreViewModel()
@property (nonatomic,strong,readwrite)RACCommand *loadGoodsCmd;
@property (nonatomic,strong,readwrite)RACCommand *museumListCmd;

@end
@implementation StoreViewModel

- (RACCommand *)museumListCmd{
    if (!_museumListCmd) {
        @weakify(self);
        _museumListCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[ApiFactory tour_taobaokemuseumlist]showErrorMsgTo:self.hudView] map:^id(id value) {
                NSArray *result = [MuseumModel mj_objectArrayWithKeyValuesArray:[value objectForKey:@"museums"]];
                return result;
            }];
        }];
    }
    return _museumListCmd;
}

- (RACCommand *)loadGoodsCmd{
    if (!_loadGoodsCmd) {
        _loadGoodsCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [[[ApiFactory tour_taobaoke:input]flattenMap:^RACStream *(id value) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    NSArray *res = [value objectForKey:@"res"];
                    NSArray *newsAry = [DiscoverModel mj_objectArrayWithKeyValuesArray:res];
                    [subscriber sendNext:newsAry];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }]showErrorMsgTo:self.hudView];
        }];
    }
    return _loadGoodsCmd;
}
@end
