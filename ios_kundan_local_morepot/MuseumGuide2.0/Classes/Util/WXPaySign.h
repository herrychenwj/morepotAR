//
//  WXPaySign.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface WXPaySign : NSObject

+ (NSString *)signStrWith:(NSString *)appid mch_id:(NSString*)mch_id device_info:(NSString *)device_info body:(NSString *)body  nonce_str:(NSString *)nonce_str;
+ (NSString *)deviceIPAdress;
+(NSString *)MD5ForUpper32Bate:(NSString *)str;

@end
