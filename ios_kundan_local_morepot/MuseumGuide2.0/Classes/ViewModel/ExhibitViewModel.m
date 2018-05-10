//
//  ExhibitViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ExhibitViewModel.h"
#import "FileUtil.h"
#import "ExhibitCommentModel.h"
#import "FileUtil+Museum.h"
#import "ExhibitInfoModel.h"
#import "ApiFactory+Tour.h"


@interface ExhibitViewModel ()
@property (nonatomic,strong)RACSignal *cmtSignal;
@property (nonatomic,assign)NSInteger cmtPageIndex;

@property (nonatomic,strong,readwrite)RACCommand *playCmd;
@property (nonatomic,strong,readwrite)RACCommand *reloadCmtCmd;
@property (nonatomic,strong,readwrite)RACCommand *moreCmtCmd;
@property (nonatomic,strong,readwrite)RACCommand *likeCmd;
@property (nonatomic,strong,readwrite)RACCommand *cmtCmd;
@property (nonatomic,strong,readwrite)RACCommand *likeCmtCmd;
@property (nonatomic,strong,readwrite)RACCommand *collectCmd;


@end

@implementation ExhibitViewModel

- (RACSignal *)cmtSignal{
    if (!_cmtSignal) {
        _cmtSignal = RACObserve(self, comment);
    }
    return _cmtSignal;
}

- (NSInteger)cmtPageIndex{
    if (!_cmtPageIndex) {
        _cmtPageIndex = 1;
    }
    return _cmtPageIndex;
}



- (RACCommand *)moreCmtCmd{
    if (!_moreCmtCmd) {
        @weakify(self);
        _moreCmtCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[[ApiFactory tour_exhibitCmtlist:self.exhibit_id?:@"" pageIndex:self.cmtPageIndex]flattenMap:^RACStream *(id value) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    NSArray *result = [ExhibitCommentModel mj_objectArrayWithKeyValuesArray:[value objectForKey:@"comments"]];
                    if (result&&result.count > 0) {
                        self.cmtPageIndex += 1;
                        [subscriber sendNext:result];
                        [subscriber sendCompleted];
                    }else{
                        [subscriber sendError:[NSErrorHelper createErrorWithErrorInfo:[TXSakuraManager tx_stringWithPath:@"no_more_commen"]]];
                    }
                    return nil;
                }];
            }] autoRefresh:input]showErrorMsgTo:self.hudView];
        }];
    }
    return _moreCmtCmd;
}

- (RACCommand *)playCmd{
    if (!_playCmd) {
//        @weakify(self);
        _playCmd =  [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSString *input) {
//            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:input];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _playCmd;
}


- (RACSignal *)cmtVerification{
    return [self.cmtSignal map:^id(NSString *value) {
        return @(![Communtil isBlankString:value]);
    }];
}

- (RACCommand *)reloadCmtCmd{
    if (!_reloadCmtCmd) {
        @weakify(self);
        _reloadCmtCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[[ApiFactory tour_exhibitCmtlist:self.exhibit_id pageIndex:0]flattenMap:^id(id value) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    NSArray *result = [ExhibitCommentModel mj_objectArrayWithKeyValuesArray:[value objectForKey:@"comments"]];
                    self.cmtPageIndex = 1;
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }]autoRefresh:input] showErrorMsgTo:self.hudView];
        }];
    }
    return _reloadCmtCmd;
}


- (RACSignal *)allowCollection{
    return RACObserve(self, canCollect);
}














@end
