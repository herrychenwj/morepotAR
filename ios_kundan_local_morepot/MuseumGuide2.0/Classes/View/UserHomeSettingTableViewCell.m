//
//  UserInfoSettingTableViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "UserHomeSettingTableViewCell.h"

@interface UserHomeSettingTableViewCell ()
@property (nonatomic,strong)UIView *bottomLine;
@end
@implementation UserHomeSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:IPHONE_DEVICE?17:19];
            lb.textColor = [UIColor whiteColor];
            [self.contentView addSubview:lb];
            lb;
        });
        _tagBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            btn.userInteractionEnabled = NO;
            btn.hidden = YES;
            [self.contentView addSubview:btn];
            btn;
        });
        _bottomLine = ({
            UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
            line.backgroundColor = [UIColor lightGrayColor];
            [self.contentView addSubview:line];
            line;
        });
        _subLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:IPHONE_DEVICE?15:17];
            lb.textColor = [UIColor whiteColor];
            lb.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:lb];
            lb;
        });
    }
    return self;
}

- (void)setCellType:(UserInfoCellType)cellType{
    switch (cellType) {
        case UserInfoCellTypeArrow:{
            self.tagBtn.hidden = NO;
            [self.tagBtn setImage:[UIImage imageNamed:@"list_right"] forState:UIControlStateNormal];
        }
            break;
        case UserInfoCellTypePoint:{
            self.tagBtn.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(kBACK_SPACE);
    }];
    [self.tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@30);
        make.height.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-16);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLB);
        make.right.equalTo(self.tagBtn);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
    [self.subLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tagBtn.mas_left).offset(2);
        make.left.equalTo(self.titleLB.mas_right).offset(12);
        make.centerY.equalTo(self.contentView);
    }];
}




@end
