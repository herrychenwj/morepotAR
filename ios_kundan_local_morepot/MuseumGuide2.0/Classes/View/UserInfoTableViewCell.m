//
//  UserInfoTableViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@interface UserInfoTableViewCell ()
@property (nonatomic,strong)UIImageView *arrow;
@property (nonatomic,strong)UIView *bottomLine;

@end

@implementation UserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        _titleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:IPHONE_DEVICE?17:19];
            lb.textColor = [UIColor whiteColor];
            [self.contentView addSubview:lb];
            lb;
        });
        _textLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:IPHONE_DEVICE?17:19];
            lb.textColor = [UIColor whiteColor];
            [self.contentView addSubview:lb];
            lb;
        });
        _avatarImg = ({
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectZero];
            imgV.hidden = YES;
            [self.contentView addSubview:imgV];
            imgV;
        });
        _arrow = ({
            UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectZero];
            arrow.image = [UIImage imageNamed:@"list_right"];
            [self.contentView addSubview:arrow];
            arrow;
        });
        _bottomLine = ({
            UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
            line.backgroundColor = [UIColor lightGrayColor];
            [self.contentView addSubview:line];
            line;
        });
    }
    return self;
}

- (void)setCellType:(UserInfoCellType)cellType{
    self.avatarImg.hidden = !(cellType == UserInfoCellTypeImage);
    self.textLB.hidden = !(cellType == UserInfoCellTypeText);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kBACK_SPACE);
    }];
    
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@12);
        make.height.equalTo(self.arrow.mas_width).multipliedBy(48.0/25.0);
        make.right.equalTo(self.contentView).offset(-30);
    }];
    [self.avatarImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrow.mas_left).offset(-8);
        make.centerY.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(8);
        make.bottom.equalTo(self.contentView).offset(-8);
        make.width.equalTo(self.avatarImg.mas_height);
    }];
    [self.textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrow.mas_left).offset(-8);
        make.centerY.equalTo(self.contentView);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB);
        make.right.equalTo(self.contentView).offset(-16);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}


@end
