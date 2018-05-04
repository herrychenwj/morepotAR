//
//  NSNumber+Page.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "NSNumber+Page.h"

@implementation NSNumber (Page)
- (NSNumber *)nextPage{
    return [NSNumber numberWithInteger:[self integerValue]+1];
}
@end
