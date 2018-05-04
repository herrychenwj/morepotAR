//
//  SearchHeaderCollectionReusableView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/6/5.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "SearchHeaderCollectionReusableView.h"

@implementation SearchHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _titleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textColor = [UIColor whiteColor];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.font = [UIFont systemFontOfSize:20];
            [self addSubview:lb];
            lb;
        });
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


@end
