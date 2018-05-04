//
//  SettingItemTableViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "SettingItemTableViewCell.h"

@implementation SettingItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        _itemIcon = ({
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self addSubview:imgView];
            imgView;
        });
        _itemTitleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textColor = [UIColor whiteColor];
            lb.font = [UIFont systemFontOfSize:IPHONE_DEVICE?18:20];
            [self addSubview:lb];
            lb;
        });
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.itemIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kBACK_SPACE);
        make.width.height.equalTo(@27);
        make.centerY.equalTo(self);
    }];
    [self.itemTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.itemIcon);
        make.left.equalTo(self.itemIcon.mas_right).offset(28);
    }];
    
}



@end
