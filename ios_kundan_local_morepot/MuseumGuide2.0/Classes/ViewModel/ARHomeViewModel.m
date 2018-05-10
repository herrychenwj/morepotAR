//
//  ARHomeViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/23.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ARHomeViewModel.h"
#import "ApiFactory+Tour.h"
#import "MuseumInfoModel.h"

@interface ARHomeViewModel ()
@property (nonatomic,strong,readwrite)RACCommand *loadInfoCmd;
@end

@implementation ARHomeViewModel



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






@end
