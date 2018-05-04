//
//  WXPaySign.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "WXPaySign.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <CommonCrypto/CommonCrypto.h>

@implementation WXPaySign
+ (NSString *)signStrWith:(NSString *)appid mch_id:(NSString*)mch_id device_info:(NSString *)device_info body:(NSString *)body  nonce_str:(NSString *)nonce_str{
    NSString *singA =[NSString stringWithFormat:@"appid=%@&body=%@&device_info=%@&mch_id=%@&nonce_str=%@",appid,mch_id,device_info,body,nonce_str];
    NSString *strTmp = [NSString stringWithFormat:@"%@&key=%@",singA,@"heyunguanboshuzikejiyouxiangongs"];
    return [self MD5ForUpper32Bate:strTmp];
}

#pragma mark - 32位 大写
+(NSString *)MD5ForUpper32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

+ (NSString *)deviceIPAdress {
    //获取不到ip的时候就用这个
    NSString *address = @"192.168.0.100";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in  *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    
    NSLog(@"%@", address);
    
    return address;
}

@end
