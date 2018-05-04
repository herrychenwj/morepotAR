//
//  NSString+URL.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/22.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "NSString+URL.h"
#import "ApiFactory.h"
#import "LocalJsonManager.h"
@implementation NSString (URL)

- (NSString *)localPath{
//    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *expathPath = [NSString stringWithFormat:@"%@/%@/",[array firstObject],resourcePath];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"localApi" ofType:@"bundle"];
    NSString *expathPath = [NSString stringWithFormat:@"%@/%@",bundlePath,resourcePath];
    return [NSString stringWithFormat:@"%@/%@",expathPath,self];
}

- (NSString *)cloudPath{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"localApi" ofType:@"bundle"];
    NSString *expathPath = [NSString stringWithFormat:@"%@/%@",bundlePath,resourcePath];
    return [NSString stringWithFormat:@"%@/%@",expathPath,self];
}

- (NSString *)highPicturePath{
    NSMutableString *mStr = [NSMutableString stringWithString:self];
    return [[mStr stringByReplacingOccurrencesOfString:@"_s" withString:@""] copy];
}




- (NSString *)apiPath{
    return [NSString stringWithFormat:@"%@%@",BASE_API_URL,self];
}

- (NSString *)paymentPath{
    return [NSString stringWithFormat:@"%@%@",PAYMENT_URL,self];
}

//- (NSString *)cloudPath{
//    return [NSString stringWithFormat:@"%@%@",BASE_WEBURL,self];
//}
//
//- (NSString *)highPicturePath{
//    NSMutableString *mStr = [NSMutableString stringWithString:self];
//    return [[mStr stringByReplacingOccurrencesOfString:@"_s" withString:@""] copy];
//
//}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding)));
}




@end
