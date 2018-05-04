//
//  UserInfoModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAVARAR_KEY  @"avatarurl"
#define kNICKNAME_KEY  @"nickname"
#define kPERSONALTITLE_KEY  @"personaltitle"
#define kSEX_KEY  @"sex"
#define kBIRTH_KEY  @"birth"
#define kPHONE_KEY  @"phone"

@interface UserInfoModel : NSObject

+ (UserInfoModel *)shareInfo;

+ (void)cleanInfo;

@property (nonatomic,copy)NSString *avatarurl;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString *personaltitle;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *birth;
@property (nonatomic,copy)NSString *phone;

@property (nonatomic,copy)NSString *token;

/**
 手机绑定状态（0为绑定 1为解绑）如果 Phone为空需要绑定 不为空时解绑
 */
@property (nonatomic,strong)NSNumber *bindType;


@end
