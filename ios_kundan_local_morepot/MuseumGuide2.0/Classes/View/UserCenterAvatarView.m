//
//  UserCenterAvatarView.m
//  PRO_TEST
//
//  Created by Mr.Huang on 2017/7/13.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import "UserCenterAvatarView.h"
#import <Masonry/Masonry.h>

@implementation UserCenterAvatarView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _avatarImgView = ({
            UIButton *imgView = [[UIButton alloc]initWithFrame:CGRectZero];
            imgView.layer.cornerRadius = 42;
            imgView.layer.masksToBounds = YES;
            [self addSubview:imgView];
            imgView;
        });
        _actionBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:btn];
            btn;
        });
        _blankControl = ({
            UIControl *blankControl = [[UIControl alloc]initWithFrame:CGRectZero];
            [self addSubview:blankControl];
            blankControl;
        });
    }
    return self;
}



- (void)layoutSubviews{
    [super layoutSubviews];
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@84);
    }];
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.avatarImgView.mas_bottom).offset(10);
        make.height.equalTo(@22);
        make.width.equalTo(self.mas_width).multipliedBy(0.5);
    }];
    [self.blankControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerX.equalTo(self);
        make.width.equalTo(self.blankControl.mas_height);
    }];
}



@end
