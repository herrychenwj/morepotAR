//
//  MyCommentModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/5.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MyCommentModel.h"
#import "NSDate+MJ.h"

@implementation MyCommentModel



- (NSString *)created_at{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YYY-MM-dd HH:mm:ss";
    NSDate *createdDate = [fmt dateFromString:_datatime];
    if (createdDate.isToday) {
        if (createdDate.deltaWithNow.hour >= 1) {
            return [NSString stringWithFormat:@"%ld小时前", (long)createdDate.deltaWithNow.hour];
        } else if (createdDate.deltaWithNow.minute >= 1) {
            return [NSString stringWithFormat:@"%ld分钟前", (long)createdDate.deltaWithNow.minute];
        } else {
            return @"刚刚";
        }
    } else if (createdDate.isYesterday) {
        fmt.dateFormat = @"昨天 HH:mm";
        return [fmt stringFromDate:createdDate];
    } else if (createdDate.isThisYear) {
        fmt.dateFormat = @"MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    } else {
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    }
}

@end
