//
//  UserSettingViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/5.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "UserSettingViewModel.h"
#import "FileUtil+Museum.h"
#import "ApiFactory+Mine.h"

@implementation UserSettingViewModel


- (RACCommand *)cleanCacheCmd{
    if (!_cleanCacheCmd) {
        _cleanCacheCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                SDImageCache *cache = [SDImageCache sharedImageCache];
                [cache clearDiskOnCompletion:nil];
                [FileUtil deleteFileAtPath:[FileUtil museumRootDir]];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _cleanCacheCmd;
}

- (RACCommand *)bindPhonenumCmd{
    if (!_bindPhonenumCmd) {
        @weakify(self);
        _bindPhonenumCmd =  [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[ApiFactory mine_bindPhone:input] showErrorMsgTo:self.hudView];
        }];
    }
    return _bindPhonenumCmd;
}

- (void)dealloc{
    
}

@end
