//
//  EnshrineViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/30.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "EnshrineViewModel.h"
#import "FavoriteModel.h"
#import "MyCommentModel.h"
#import "ApiFactory+Mine.h"

@interface EnshrineViewModel ()

@property (nonatomic,strong,readwrite)RACCommand *favCmd;

@property(nonatomic,strong,readwrite)RACCommand *footprintCmd;

@property (nonatomic,strong,readwrite)RACCommand *cmtlistCmd;


@end


@implementation EnshrineViewModel

- (RACCommand *)favCmd{
    if (!_favCmd) {
        @weakify(self);
        _favCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[ApiFactory mine_getFavortieExhibits]flattenMap:^id(id value) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    NSArray *res = [value objectForKey:@"res"];
                    NSArray *tmp = [FavoriteModel mj_objectArrayWithKeyValuesArray:res];
                    [subscriber sendNext:tmp];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }]showErrorMsgTo:self.hudView];
        }];
    }
    return _favCmd;
}


- (RACCommand *)footprintCmd{
    if (!_footprintCmd) {
        @weakify(self);
        _footprintCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[ApiFactory mine_getFootprintExhibits]flattenMap:^id(id value) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    NSArray *res = [value objectForKey:@"res"];
                    NSArray *tmp = [FavoriteModel mj_objectArrayWithKeyValuesArray:res];
                    [subscriber sendNext:tmp];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }]showErrorMsgTo:self.hudView];
        }];
    }
    return _footprintCmd;
}

- (RACCommand *)cmtlistCmd{
    if (!_cmtlistCmd) {
        @weakify(self);
        _cmtlistCmd =  [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[ApiFactory mine_getComments]flattenMap:^id(id value) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    NSArray *res = [value objectForKey:@"res"];
                    [subscriber sendNext:[MyCommentModel mj_objectArrayWithKeyValuesArray:res]];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }] showErrorMsgTo:self.hudView];
        }];
    }
    return _cmtlistCmd;
}



@end
