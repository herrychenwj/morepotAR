//
//  BindPhoneViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/6.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BindPhoneViewModel.h"
#import "ApiFactory+Mine.h"

@interface BindPhoneViewModel ()
@property (nonatomic,strong)RACSignal *phoneNumSignal;
@property (nonatomic,strong)RACSignal *codeRunningSignal;
@property (nonatomic,strong)RACSignal *codeSignal;
@property (nonatomic,strong,readwrite)RACCommand *sendCmd;
@property (nonatomic,strong,readwrite)RACCommand *bindPhoneCmd;

@end

@implementation BindPhoneViewModel

- (RACSignal *)phoneNumSignal{
    if (!_phoneNumSignal) {
        _phoneNumSignal = RACObserve(self, phoneNumber);
    }
    return _phoneNumSignal;
}

- (RACSignal *)codeSignal{
    if (!_codeSignal) {
        _codeSignal = RACObserve(self, authCode);
    }
    return _codeSignal;
}

- (RACSignal *)codeRunningSignal{
    if (!_codeRunningSignal) {
        _codeRunningSignal = RACObserve(self, codeRunning);
    }
    return _codeRunningSignal;
}

- (RACCommand *)sendCmd{
    if (!_sendCmd) {
        @weakify(self);
        _sendCmd = [[RACCommand alloc]initWithEnabled:[self verificationPhoneNumber] signalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[ApiFactory mine_getAuthCode:self.phoneNumber?:@""] showErrorMsgTo:self.hudView];
        }];
    }
    return _sendCmd;
}


- (RACCommand *)bindPhoneCmd{
    if (!_bindPhoneCmd) {
        @weakify(self);
        _bindPhoneCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[RACSignal combineLatest:@[RACObserve(self, message_id),RACObserve(self, authCode)] reduce:^id(NSString *msg_id,NSString *authCode){return @(msg_id.length>0&&authCode.length>0);}]flattenMap:^RACStream *(NSNumber *value) {
                @strongify(self);
                return [value boolValue] ? [[[ApiFactory mine_bindPhone:@{@"phonenum":self.phoneNumber?:@"",@"messageid":self.message_id?:@"",@"dynamiccode":self.authCode?:@"",@"type":self.type}] showErrorMsgTo:self.hudView]map:^id(id value) {
                    return [self.type boolValue]?self.phoneNumber:@"";
                }]:[[RACSignal error:[NSErrorHelper createErrorWithErrorInfo:[TXSakuraManager tx_stringWithPath:@"pleasephone"]]] showErrorMsgTo:self.hudView];
            }];
        }];
    }
    return _bindPhoneCmd;
}

//验证手机号
- (RACSignal *)verificationPhoneNumber{
    return [RACSignal combineLatest:@[self.phoneNumSignal,self.codeRunningSignal] reduce:^id(NSString *phoneNumber,NSNumber *codeRunning){
        return @([Communtil isPureInt:phoneNumber] && (phoneNumber.length == 11) && ![codeRunning boolValue]);
    }];
}


@end
