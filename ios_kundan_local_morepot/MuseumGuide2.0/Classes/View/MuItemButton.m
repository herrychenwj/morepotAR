//
//  MuItemButton.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/2.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MuItemButton.h"

@implementation MuItemButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _itemIcon = ({
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self addSubview:img];
            img;
        });
        _itemLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:12];
            lb.textColor = [UIColor whiteColor];
            lb.textAlignment = NSTextAlignmentCenter;
            [self addSubview:lb];
            lb;
        });
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.itemIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(11);
        make.width.equalTo(self.itemIcon.mas_height);
        make.right.equalTo(self).offset(-11);
    }];
    [self.itemLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(-12);
        make.right.equalTo(self).offset(12);
        make.height.equalTo(@20);
    }];
}


@end
