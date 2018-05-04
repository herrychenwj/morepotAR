//
//  DiscoverNavBar.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/10/11.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "DiscoverNavBar.h"
#import "MuBackButton.h"
#import "UIImage+Developer.h"

@interface DiscoverNavBar ()
@property (nonatomic,strong)UIView *contentView;
@end

@implementation DiscoverNavBar
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _contentView = ({
            UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor clearColor];
            [self addSubview:view];
            view;
        });
        _searchFD = ({
            UITextField *fd = [[UITextField alloc]initWithFrame:CGRectZero];
            fd.backgroundColor = HexRGB(0xD9D9D9);
            fd.clearButtonMode = UITextFieldViewModeWhileEditing;
            fd.font = [UIFont systemFontOfSize:15];
            fd.textColor= [UIColor whiteColor];
            fd.layer.cornerRadius = 2.f;
            fd.layer.masksToBounds = YES;
            NSMutableAttributedString *attrSearch = [[NSMutableAttributedString alloc]initWithString:@"请输入产品关键词" attributes:@{NSForegroundColorAttributeName:HexRGB(0x787A78)}];
            fd.attributedPlaceholder = [attrSearch copy];
//            fd.placeholder = @"请输入产品关键词";
            fd.leftViewMode = UITextFieldViewModeAlways;
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(8, 6, 24, 15)];
            img.contentMode = UIViewContentModeScaleAspectFit;
            img.image = [[UIImage imageNamed:@"find"] imageWithColor:HexRGB(0x787A78)];
            fd.leftView = img;
            fd.returnKeyType = UIReturnKeySearch;
            [self.contentView addSubview:fd];
            fd;
        });

        
        _backImgV = ({
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            img.image = [[UIImage imageNamed:@"menu_back"] imageWithColor:HexRGB(0x202126)];
            [self.contentView addSubview:img];
            img;
        });
        _titleLabel = ({
            UILabel *btn = [[UILabel alloc]initWithFrame:CGRectZero];
            btn.font = [UIFont systemFontOfSize:IPHONE_DEVICE?17:20];
            btn.textColor = HexRGB(0x202126);
            [self.contentView addSubview:btn];
            btn;
        });
        _backControl = [[UIButton alloc]initWithFrame:CGRectZero];
        [self addSubview:_backControl];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
//        make.top.equalTo(self).offset(20);
    }];
    [self.backImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(4);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@12);
        make.height.equalTo(self.backImgV.mas_width).multipliedBy(29.0/15.0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backImgV.mas_right).offset(4);
        make.centerY.equalTo(self.contentView);
//        make.width.equalTo(IPHONE_DEVICE?@80:@100);
        make.height.equalTo(IPHONE_DEVICE?@30:@37.5);
    }];
    [self.searchFD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(8);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentView);
    }];
    [self.backControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backImgV);
        make.width.equalTo(@120);
        make.height.equalTo(@44);
        make.centerY.equalTo(self);
//        make.top.bottom.equalTo(self.contentView);
    }];
}






@end
