//
//  StoreTableViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/11/7.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "StoreTableViewCell.h"

@interface StoreTableViewCell ()
@property (nonatomic,strong)UIView *line;
@end

@implementation StoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLB = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
//            label.font  = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor whiteColor];
            label;
        });
//        _imgV = ({
//            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectZero];
//            imgV.image = [UIImage imageNamed:@"list_right"];
//            imgV;
//        });
        _line = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor lightGrayColor];
            view;
        });
        [self addSubview:_titleLB];
//        [self addSubview:_imgV];
        [self addSubview:_line];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.bottom.equalTo(self).offset(-10);
        make.right.equalTo(self).offset(-20);
        make.height.equalTo(@21);
    }];
//    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.height.equalTo(self.titleLB);
//        make.width.equalTo(self.imgV.mas_height).multipliedBy(0.5);
//        make.right.equalTo(self).offset(-12);
//    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.height.equalTo(@1);
        make.right.equalTo(self).offset(-12);
//        make.right.equalTo(self.imgV);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    self.titleLB.textColor = selected? HexRGB(0xEC6728):[UIColor whiteColor];
}


@end





