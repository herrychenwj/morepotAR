//
//  ARHomeViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/23.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ARHomeViewModel.h"
#import "iBeaconModel.h"
#import "MuseumInfoModel.h"
#import "ApiFactory+Tour.h"
#import "DiscoverModel.h"


@interface ARHomeViewModel ()
@property (nonatomic,strong,readwrite)RACCommand *loadInfoCmd;
@property (nonatomic,strong,readwrite)RACCommand *loadGoodsCmd;
@property (nonatomic,strong,readwrite)RACCommand *iBeaconCmd;

@end

@implementation ARHomeViewModel


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



- (RACCommand *)loadInfoCmd{
    if (!_loadInfoCmd) {
        @weakify(self);
        _loadInfoCmd =  [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[ApiFactory tour_museuminfo:self.basicInfo.museum_id?:@""]flattenMap:^RACStream *(id value) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    [subscriber sendNext:[MuseumInfoModel mj_objectWithKeyValues:value]];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }];
        }];
    }
    return _loadInfoCmd;
}

- (RACCommand *)iBeaconCmd{
    if (!_iBeaconCmd) {
        @weakify(self);
        _iBeaconCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[ApiFactory tour_ibeaconinfo:self.basicInfo.museum_id?:@""] checkData]flattenMap:^RACStream *(id value) {
                NSString *jsonPath = (NSString *)[value objectForKey:@"url"];
                return  !jsonPath?[RACSignal empty]:[[ApiFactory tour_ibeaconJson:[jsonPath
                         cloudPath]] map:^id(id value) {
                    return [iBeaconModel mj_objectArrayWithKeyValuesArray:[value objectForKey:@"ibeacons"]];
                }];
            }];
        }];
    }
    return _iBeaconCmd;
}





@end
