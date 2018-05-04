//
//  LoginViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/9.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

@interface LoginViewModel : BaseViewModel


/**
 登录
 */
@property (nonatomic,strong,readonly)RACCommand *loginCmd;
/**
 发送验证码
 */
@property (nonatomic,strong,readonly)RACCommand *sendCmd;


/**
 用户协议是否许可
 */
@property (nonatomic,assign)BOOL protocolEnable;

/**
 手机号
 */
@property (nonatomic,strong)NSString *phoneNumber;


/**
 短信ID
 */
@property (nonatomic,strong)NSString *message_id;

/**
 验证码
 */
@property (nonatomic,strong)NSString *authCode;
/**
 登录验证  验证手机号和验证码

 @return 登录验证
 */
- (RACSignal *)verificationLogin;
/**
 验证手机号 (需要在验证码没有发送时才发送YES)

 @return 验证手机号
 */
- (RACSignal *)verificationPhoneNumber;
/**
 验证码是否在倒计时中
 */
@property (nonatomic,assign)BOOL codeRunning;

@end
