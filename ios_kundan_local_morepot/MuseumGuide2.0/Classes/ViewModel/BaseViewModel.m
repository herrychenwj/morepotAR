//
//  BaseViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewModel.h"
#import "ExhibitInfoModel.h"
#import "UserInfoModel.h"
#import "ApiFactory.h"
#import "ApiFactory+Tour.h"
#import "ApiFactory+News.h"
#import "ApiFactory+Mine.h"

@interface BaseViewModel ()
@property (nonatomic,strong,readwrite)RACCommand *exhibitInfoCmd;
@property (nonatomic,strong,readwrite)RACCommand *userInfoCmd;
@property (nonatomic,strong,readwrite)RACCommand *reloadCmtCmd;

@end

@implementation BaseViewModel

- (instancetype)initWithHUDShowView:(UIView *)view{
    if (self = [self init]) {
        self.hudView = view;
    }
    return self;
}


#pragma mark lazy load
- (RACCommand *)exhibitInfoCmd{
    if (!_exhibitInfoCmd) {
        @weakify(self);
        _exhibitInfoCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[RACSignal combineLatest:@[[ApiFactory tour_exhibitInfo:input?:@""],[ApiFactory tour_exhibitCmtlist:input?:@"" pageIndex:0]] reduce:^(NSDictionary *exhibit,NSDictionary *cmtData){
                NSMutableDictionary *dic = [exhibit mutableCopy];
                if (cmtData && [cmtData objectForKey:@"comments"]) {
                    dic[@"comments"] = [cmtData objectForKey:@"comments"];
                }
                return [ExhibitInfoModel mj_objectWithKeyValues:[dic copy]];
            }]showErrorMsgTo:self.hudView];
        }];
    }
    return _exhibitInfoCmd;
}





- (RACCommand *)userInfoCmd{
    if (!_userInfoCmd) {
        @weakify(self);
        _userInfoCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[ApiFactory mine_getUserInfo]flattenMap:^RACStream *(id x) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    [UserInfoModel shareInfo].avatarurl = [x objectForKey:@"avatarurl"]?:@"";
                    [UserInfoModel shareInfo].personaltitle = [x objectForKey:@"personaltitle"]?:@"";
                    [UserInfoModel shareInfo].sex = [x objectForKey:@"sex"]?:@"";
                    [UserInfoModel shareInfo].birth = [x objectForKey:@"birth"]?:@"";
                    [UserInfoModel shareInfo].phone = [x objectForKey:@"phone"]?:@"";
                    [UserInfoModel shareInfo].nickname = [x objectForKey:@"nickname"]?:@"";
                    [UserInfoModel shareInfo].token = [x objectForKey:@"token"]?:@"";
                    [subscriber sendNext:[UserInfoModel shareInfo].token];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }] showErrorMsgTo:self.hudView];
    }];
    }
    return _userInfoCmd;
}





@end
