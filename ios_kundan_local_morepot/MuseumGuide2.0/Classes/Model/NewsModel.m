//
//  NewsModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "NewsModel.h"
#import "YYText.h"

@implementation NewsModel


- (void)setTitle:(NSString *)title{
    _title = title;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:_title];
    attrStr.yy_lineSpacing = 8;
    attrStr.yy_font = [UIFont systemFontOfSize:16];
    _attrTitle = [attrStr copy];
}


- (void)setCreatedate:(NSString *)createdate{
    _createdate = createdate;
    NSDateFormatter *fm = [[NSDateFormatter alloc]init];
    fm.dateFormat = @"yyy-MM-dd HH:mm:ss";
    NSDate *date = [fm dateFromString:_createdate];
    NSDateFormatter *fm2 = [[NSDateFormatter alloc]init];
    fm2.dateFormat = @"yy-MM-dd";
    _createdate = [fm2 stringFromDate:date];
}


@end
