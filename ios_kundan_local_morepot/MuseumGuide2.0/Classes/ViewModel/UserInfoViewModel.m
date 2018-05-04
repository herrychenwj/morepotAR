//
//  UserInfoViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "UserInfoViewModel.h"
#import "UserInfoModel.h"
#import "ApiFactory+Mine.h"

@interface UserInfoViewModel ()

@property (nonatomic,strong,readwrite)RACCommand *modifAvatarCmd;
@property (nonatomic,strong,readwrite)RACCommand *modifNameCmd;
@property (nonatomic,strong,readwrite)RACCommand *modifSignatureCmd;
@property (nonatomic,strong,readwrite)RACCommand *modifBirthCmd;
@property (nonatomic,strong,readwrite)RACCommand *modifGenderCmd;

@end

@implementation UserInfoViewModel

- (RACCommand *)modifGenderCmd{
    if (!_modifGenderCmd) {
        @weakify(self);
        _modifGenderCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[ApiFactory mine_editGender:input]map:^id(id value) {
                return input;
            }]showErrorMsgTo:self.hudView];
        }];
    }
    return _modifGenderCmd;
}

- (RACCommand *)modifSignatureCmd{
    if (!_modifSignatureCmd) {
        @weakify(self);
        _modifSignatureCmd = [[RACCommand alloc]initWithEnabled:[RACObserve(self, signature) map:^id(NSString *value) {
            return @(value.length > 0);
        }] signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[ApiFactory  mine_editSignature:self.signature] flattenMap:^RACStream *(id value) {
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                    @strongify(self);
                    [subscriber sendNext:self.signature];
                    [subscriber sendCompleted];
                    return nil;
                }];
            }] showErrorMsgTo:self.hudView];
        }];
    }
    return _modifSignatureCmd;
}

- (RACCommand *)modifAvatarCmd{
    if (!_modifAvatarCmd) {
        @weakify(self);
        _modifAvatarCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSData *input) {
            @strongify(self);
            return [[ApiFactory mine_editAvatar:input]showErrorMsgTo:self.hudView];
        }];
    }
    return _modifAvatarCmd;
}

- (RACCommand *)modifNameCmd{
    if (!_modifNameCmd) {
        @weakify(self);
        _modifNameCmd = [[RACCommand alloc]initWithEnabled:[RACObserve(self, nickName) map:^id(NSString *value) {
            return @(value.length > 0);
        }] signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[ApiFactory mine_editNickName:self.nickName?:@""] map:^id(id value) {
                @strongify(self);
                return self.nickName;
            }]showErrorMsgTo:self.hudView];
        }];
    }
    return  _modifNameCmd;
}

- (RACCommand *)modifBirthCmd{
    if (!_modifBirthCmd) {
        @weakify(self);
        _modifBirthCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber *input) {
            @strongify(self);
            return [[[ApiFactory mine_editBirthday:input]map:^id(id value) {
                NSDateFormatter *fm = [[NSDateFormatter alloc]init];
                [fm setDateFormat:@"YYY-MM-dd"];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[input doubleValue]];
                return [fm stringFromDate:date];
            }]showErrorMsgTo:self.hudView];
        }];
    }
    return _modifBirthCmd;
}






@end
