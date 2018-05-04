//
//  StoreNavBar.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/11/7.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "StoreNavBar.h"
#import "UIImage+Developer.h"

@implementation StoreNavBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _selectBtn = ({
            StoreButton *btn = [[StoreButton alloc]initWithFrame:CGRectZero];
            btn.titleLB.text = @"选择旗舰店";
            btn;
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
            fd;
        });
        [self addSubview:_selectBtn];
        [self addSubview:_searchFD];
    }
    return self;
}



- (void)layoutSubviews{
    [super layoutSubviews];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(IPHONE_DEVICE?@((kSCREEN_WIDTH - 5)/2 - 44):@((kSCREEN_WIDTH - kPADSETTING_LEFTMARGIN)/2-44));
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
    }];
    [self.searchFD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self.selectBtn.mas_right).offset(0);
        make.right.equalTo(self).offset(-20);
    }];
}




@end

@implementation StoreButton:UIButton
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imgV = ({
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imgView.image = [UIImage imageNamed:@"down_arrow"];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView;
        });
        _titleLB = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
//            label.textAlignment = ;
//            label.font = [UIFont systemFontOfSize:17];
            label.textColor = [UIColor blackColor];
            label;
        });
        [self addSubview:_imgV];
        [self addSubview:_titleLB];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self.imgV.mas_left).offset(-2);
    }];
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
        if (IPHONE_DEVICE) {
            make.width.equalTo(self.imgV.mas_height).multipliedBy(133.0/72);
        }else{
            make.width.equalTo(self.imgV.mas_height).multipliedBy(1);
        }
    }];
}


- (void)setSelect:(BOOL)select{
    if (_select != select) {
        _select = select;
    }
}

@end
