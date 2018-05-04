//
//  ApiFactory+Mine.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/15.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ApiFactory.h"

@interface ApiFactory (Mine)
/**
 获取用户信息
 */
+ (RACSignal *)mine_getUserInfo;

/**
 登录操作
 */
+ (RACSignal *)mine_login:(id)params;
/**
 同步本地收藏展品
 */
+ (RACSignal *)mine_syncFavorite:(id)params;


+ (RACSignal *)mine_getAuthCode:(NSString *)phoneNum;

+ (RACSignal *)mine_feedback:(id)params;


/**
 修改性别
 
 @param gender 性别字符串 男或女
 */
+ (RACSignal *)mine_editGender:(NSString *)gender;

+ (RACSignal *)mine_editSignature:(NSString *)content;


+ (RACSignal *)mine_editNickName:(NSString *)nickName;

+ (RACSignal *)mine_editBirthday:(NSNumber *)birthDaty;


+ (RACSignal *)mine_editAvatar:(NSData *)imgData;


+ (RACSignal *)mine_bindPhone:(id)params;



+ (RACSignal *)mine_getFavortieExhibits;
+ (RACSignal *)mine_getFootprintExhibits;
+ (RACSignal *)mine_getComments;

@end
