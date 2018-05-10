//
//  NSString+URL.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/22.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "NSString+URL.h"
#import "LocalJsonManager.h"
@implementation NSString (URL)

- (NSString *)localPath{
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
