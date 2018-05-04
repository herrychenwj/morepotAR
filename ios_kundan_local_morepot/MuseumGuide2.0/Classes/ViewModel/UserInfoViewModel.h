//
//  UserInfoViewModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "BaseViewModel.h"

@interface UserInfoViewModel : BaseViewModel


/**
 修改头像 (input传 NSData)
 */
@property (nonatomic,strong,readonly)RACCommand *modifAvatarCmd;

/**
 修改昵称
 */
@property (nonatomic,strong,readonly)RACCommand *modifNameCmd;

/**
 修改个性签名
 */
@property (nonatomic,strong,readonly)RACCommand *modifSignatureCmd;

/**
 修改生日
 */
@property (nonatomic,strong,readonly)RACCommand *modifBirthCmd;
/**
 修改性别
 */
@property (nonatomic,strong,readonly)RACCommand *modifGenderCmd;



@property (nonatomic,strong)NSString *nickName;


@property (nonatomic,strong)NSString *signature;

@end
