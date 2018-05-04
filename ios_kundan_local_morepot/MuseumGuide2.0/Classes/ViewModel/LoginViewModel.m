//
//  LoginViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/9.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "LoginViewModel.h"
#import "Communtil.h"
#import "ApiFactory+Mine.h"
#import "NSErrorHelper.h"
#import "UserInfoModel.h"


@interface LoginViewModel()
@property (nonatomic,strong)RACSignal *phoneNumSignal;
@property (nonatomic,strong)RACSignal *codeSignal;
@property (nonatomic,strong)RACSignal *codeRunningSignal;
@property (nonatomic,strong)RACSignal *protocolSignal;
@property (nonatomic,strong)RACSignal *messageSignal;

@property (nonatomic,strong,readwrite)RACCommand *loginCmd;
@property (nonatomic,strong,readwrite)RACCommand *sendCmd;
@end

@implementation LoginViewModel

- (RACCommand *)loginCmd{
    if (!_loginCmd) {
        @weakify(self);
        _loginCmd = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[[ApiFactory mine_login:input]flattenMap:^RACStream *(id value) {
                if ([value objectForKey:@"token"]) { //登录成功
                    [[NSUserDefaults standardUserDefaults]setObject:[value objectForKey:@"token"] forKey:kACCESS_TOKEN];
                    return [[ApiFactory mine_getUserInfo]flattenMap:^RACStream *(id value) {
                        //清除本地收藏展品列表
                        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                            [CoreDataManager cleanCollectExhibit];
                            //格式化用户信息
                            [UserInfoModel shareInfo].avatarurl = [value objectForKey:@"avatarurl"]?:@"";
                            [UserInfoModel shareInfo].personaltitle = [value objectForKey:@"personaltitle"]?:@"";
                            [UserInfoModel shareInfo].sex = [value objectForKey:@"sex"]?:@"";
                            [UserInfoModel shareInfo].birth = [value objectForKey:@"birth"]?:@"";
                            [UserInfoModel shareInfo].phone = [value objectForKey:@"phone"]?:@"";
                            [UserInfoModel shareInfo].nickname = [value objectForKey:@"nickname"]?:@"";
                            [UserInfoModel shareInfo].token = [value objectForKey:@"token"]?:@"";
                            [subscriber sendNext:@YES];
                            [subscriber sendCompleted];
                            return nil;
                        }];
                    }];
                }else{
                    return [RACSignal error:[NSErrorHelper createErrorWithErrorInfo:[TXSakuraManager tx_stringWithPath:@"login_fail"]]];
                }
            }] autoHUD:self.hudView] showErrorMsgTo:self.hudView];
        }];
    }
    return _loginCmd;
}

- (RACCommand *)sendCmd{
    if (!_sendCmd) {
        @weakify(self);
        _sendCmd = [[RACCommand alloc]initWithEnabled:[self verificationPhoneNumber] signalBlock:^RACSignal *(id input) {
            if ([self vailationTime]) {
                NSTimeInterval now = [[NSDate new] timeIntervalSince1970];
                NSInteger intx = now;
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:intx] forKey:@"SENDMESSAGE"];
                @strongify(self);
                return [[ApiFactory mine_getAuthCode:self.phoneNumber?:@""]showErrorMsgTo:self.hudView];
            }else{
                return [[RACSignal error:[NSErrorHelper createErrorWithErrorInfo:@"请勿重复发送"]] showErrorMsgTo:self.hudView];
            }
        }];
    }
    return _sendCmd;
}



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

- (RACSignal *)protocolSignal{
    if (!_protocolSignal) {
        _protocolSignal = RACObserve(self, protocolEnable);
    }
    return _protocolSignal;
}

- (RACSignal *)messageSignal{
    if (!_messageSignal) {
        _messageSignal = RACObserve(self, message_id);
    }
    return _messageSignal;
}

//登录验证
- (RACSignal *)verificationLogin{
    return [RACSignal combineLatest:@[self.phoneNumSignal,self.codeSignal,self.protocolSignal,self.messageSignal] reduce:^id(NSString *phoneNumber,NSString *code,NSNumber *protocol,NSString *message_id){
        return @([Communtil isPureInt:phoneNumber] && (phoneNumber.length == 11) && (code.length > 0) && [Communtil isPureInt:code]&& ![protocol boolValue]&&message_id.length > 0);
    }];
}

//验证手机号
- (RACSignal *)verificationPhoneNumber{
    return [RACSignal combineLatest:@[self.phoneNumSignal,self.codeRunningSignal] reduce:^id(NSString *phoneNumber,NSNumber *codeRunning){
        return @([Communtil isPureInt:phoneNumber] && (phoneNumber.length == 11) && ![codeRunning boolValue]);
    }];
}

- (BOOL)vailationTime{
    NSNumber *a = [[NSUserDefaults standardUserDefaults] objectForKey:@"SENDMESSAGE"];
    if (a) {
        NSTimeInterval now = [[NSDate new]timeIntervalSince1970];
        NSInteger nowx = now;
        if ((nowx - [a integerValue])> 60) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}





@end
