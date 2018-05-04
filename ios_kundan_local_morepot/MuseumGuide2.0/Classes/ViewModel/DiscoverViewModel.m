//
//  DiscoverViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/10/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "DiscoverViewModel.h"
#import "ApiFactory+Tour.h"
#import "DiscoverModel.h"

@implementation DiscoverViewModel

- (instancetype)init{
    if (self = [super init]) {
        self.loadInfoCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
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
    return self;
}

@end
