//
//  MuseumViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/14.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MuseumViewModel.h"
#import "DownloadFactory.h"

@interface MuseumViewModel ()
@property (nonatomic,strong,readwrite)RACCommand *audioReadyCmd;
@end

@implementation MuseumViewModel


- (RACCommand *)audioReadyCmd{
    if (!_audioReadyCmd) {
        @weakify(self);
        _audioReadyCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:self.detailInfo.audio.localPath];
                [subscriber sendCompleted];
                return nil;
            }];
//            return [[DownloadFactory cacheMP3WithUrl:self.detailInfo.audio.cloudPath museum_id:self.basicInfo.museum_id]showErrorMsgTo:self.hudView];
        }];
    }
    return _audioReadyCmd;
}






@end
