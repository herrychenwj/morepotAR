//
//  UserInfoModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "UserInfoModel.h"
#import "Communtil.h"

@implementation UserInfoModel


+ (UserInfoModel *)shareInfo{
    static UserInfoModel *userInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[UserInfoModel alloc]init];
    });
    return userInfo;
}


- (instancetype)init{
    if (self = [super init]) {
        if ([Communtil isLogin]) { //如果已经登录 直接从本地读取
            self.avatarurl = [[NSUserDefaults standardUserDefaults]objectForKey:kAVARAR_KEY];
            self.sex = [[NSUserDefaults standardUserDefaults]objectForKey:kSEX_KEY];
            self.birth = [[NSUserDefaults standardUserDefaults]objectForKey:kBIRTH_KEY];
            self.phone = [[NSUserDefaults standardUserDefaults]objectForKey:kPHONE_KEY];
            self.nickname = [[NSUserDefaults standardUserDefaults]objectForKey:kNICKNAME_KEY];
            self.personaltitle = [[NSUserDefaults standardUserDefaults]objectForKey:kPERSONALTITLE_KEY];
        }
    }
    return self;
}

- (void)setAvatarurl:(NSString *)avatarurl{
    _avatarurl = avatarurl;
    [[NSUserDefaults standardUserDefaults]setObject:_avatarurl?:@"" forKey:kAVARAR_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setSex:(NSString *)sex{
    _sex = sex;
    [[NSUserDefaults standardUserDefaults]setObject:_sex?:@"" forKey:kSEX_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setBirth:(NSString *)birth{
    _birth = birth;
    [[NSUserDefaults standardUserDefaults]setObject:_birth?:@"" forKey:kBIRTH_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setPhone:(NSString *)phone{
    _phone = phone;
    [[NSUserDefaults standardUserDefaults]setObject:_phone?:@"" forKey:kPHONE_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setNickname:(NSString *)nickname{
    _nickname = nickname;
    [[NSUserDefaults standardUserDefaults]setObject:_nickname?:@"" forKey:kNICKNAME_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setPersonaltitle:(NSString *)personaltitle{
    _personaltitle = personaltitle;
    if (!_personaltitle || _personaltitle.length == 0) {
        _personaltitle = @"留下点什么吧!";
    }
    [[NSUserDefaults standardUserDefaults]setObject:_personaltitle?:@"" forKey:kPERSONALTITLE_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (NSNumber *)bindType{
    return @(!(self.phone == nil || self.phone.length == 0));
}

+ (void)cleanInfo{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kPERSONALTITLE_KEY];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kNICKNAME_KEY];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kPHONE_KEY];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kSEX_KEY];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kBIRTH_KEY];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kAVARAR_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}



@end
