//
//  BindPhoneViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/6.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewModel.h"

@interface BindPhoneViewModel : BaseViewModel


/**
 发送验证码
 */
@property (nonatomic,strong,readonly)RACCommand *sendCmd;

/**
 绑定操作
 */
@property (nonatomic,strong,readonly)RACCommand *bindPhoneCmd;

/**
 验证手机号 (需要在验证码没有发送时才发送YES)
 
 @return 验证手机号
 */
- (RACSignal *)verificationPhoneNumber;
/**
 验证码是否在倒计时中
 */
@property (nonatomic,assign)BOOL codeRunning;


/**
 手机号
 */
@property (nonatomic,strong)NSString *phoneNumber;


/**
 messageID
 */
@property (nonatomic,strong)NSString *message_id;

/**
 验证码
 */
@property (nonatomic,strong)NSString *authCode;


/**
 1为绑定0为解绑
 */
@property (nonatomic,strong)NSNumber *type;



@end
