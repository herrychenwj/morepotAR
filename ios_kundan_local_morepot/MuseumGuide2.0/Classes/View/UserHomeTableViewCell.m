//
//  UserInfoTableViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "UserHomeTableViewCell.h"

@implementation UserHomeTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        _avatarImg = ({
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self addSubview:imgV];
            imgV;
        });
        _nameLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:IPHONE_DEVICE?15:17];
            lb.textColor = [UIColor whiteColor];
            [self addSubview:lb];
            lb;
        });
        _stateLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:IPHONE_DEVICE?15:17];
            lb.textColor = [UIColor whiteColor];
            [self addSubview:lb];
            lb;
        });
        _arrowImg = ({
            UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectZero];
            arrow.image = [UIImage imageNamed:@"list_right"];
            [self addSubview:arrow];
            arrow;
        });
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.avatarImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.equalTo(self.avatarImg.mas_height);
        make.left.equalTo(self).offset(kBACK_SPACE);
    }];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImg.mas_right).offset(16);
        make.bottom.equalTo(self.mas_centerY).offset(-4);
    }];
    [self.stateLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLB);
        make.top.equalTo(self.mas_centerY).offset(4);
    }];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.equalTo(@12);
        make.height.equalTo(self.arrowImg.mas_width).multipliedBy(48.0/25.0);
        make.right.equalTo(self).offset(-30);
    }];
}



@end
