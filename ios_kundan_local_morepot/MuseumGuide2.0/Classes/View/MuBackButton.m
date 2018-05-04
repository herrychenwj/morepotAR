//
//  MuBackButton.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/2.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MuBackButton.h"

@implementation MuBackButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _titleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textColor = [UIColor whiteColor];
            lb.font = [UIFont systemFontOfSize:20];
            [self addSubview:lb];
            lb;
        });
        _backImg = ({
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            img.image = [UIImage imageNamed:@"menu_back"];
            [self addSubview:img];
            img;
        });
    }
    return self;
}





- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kBACK_SPACE);
        make.centerY.equalTo(self);
    }];
    [self.backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLB.mas_left).offset(-8);
        make.centerY.equalTo(self.titleLB);
        make.width.equalTo(@12);
        make.height.equalTo(self.backImg.mas_width).multipliedBy(29.0/15.0);
    }];
    
}

@end
