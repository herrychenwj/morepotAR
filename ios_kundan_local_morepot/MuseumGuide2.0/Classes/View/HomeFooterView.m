//
//  HomeFooterView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/30.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "HomeFooterView.h"

@implementation HomeFooterView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _productBtn = ({
            MuItemButton *btn = [[MuItemButton alloc]initWithFrame:CGRectZero];
            btn.itemLB.font = [UIFont systemFontOfSize:IPHONE_DEVICE?11:13];
            btn.itemLB.sakura.text(@"pizza");
            btn.itemIcon.image = [UIImage imageNamed:@"Pierre"];
            [self addSubview:btn];
            btn;
        });
        _helpBtn = ({
            MuItemButton *btn = [[MuItemButton alloc]initWithFrame:CGRectZero];
            btn.itemLB.font = [UIFont systemFontOfSize:IPHONE_DEVICE?11:13];
            btn.itemLB.sakura.text(@"help");
            btn.itemIcon.image = [UIImage imageNamed:@"help"];
            [self addSubview:btn];
            btn;
        });
        _strategyBtn = ({
            MuItemButton *btn = [[MuItemButton alloc]initWithFrame:CGRectZero];
            btn.itemLB.font = [UIFont systemFontOfSize:IPHONE_DEVICE?11:13];
            btn.itemLB.sakura.text(@"strategy");
            btn.itemIcon.image = [UIImage imageNamed:@"raiders"];
            [self addSubview:btn];
            btn;
        });
//        _searchBtn = ({
//            MuItemButton *btn = [[MuItemButton alloc]initWithFrame:CGRectZero];
//            btn.itemLB.font = [UIFont systemFontOfSize:IPHONE_DEVICE?12:15];
//            btn.itemLB.sakura.text(@"search");
//            btn.itemIcon.image = [UIImage imageNamed:@"search"];
//            [self addSubview:btn];
//            btn;
//        });
        _rootBtn = ({
            MuItemButton *btn = [[MuItemButton alloc]initWithFrame:CGRectZero];
            btn.itemLB.font = [UIFont systemFontOfSize:IPHONE_DEVICE?11:13];
            btn.itemLB.sakura.text(@"select_museum");
            btn.itemIcon.image = [UIImage imageNamed:@"root"];
            [self addSubview:btn];
            btn;
        });
    }
    return self;
}


//- (void)setArCardStyle:(BOOL)arCardStyle{
//    if (_arCardStyle != arCardStyle) {
//        _arCardStyle = arCardStyle;
//        [self setNeedsLayout];
//        [self layoutIfNeeded];
//    }
//}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.rootBtn.hidden = YES;
//    self.helpBtn.hidden = YES;

    [self.strategyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(IPHONE_DEVICE?@58:@58);
        make.width.equalTo(IPHONE_DEVICE?@48:@50);
        make.bottom.equalTo(self).offset(IPHONEX_DEVICE?-31:0);
//        make.right.equalTo(self.mas_centerX).equalTo(@-14);
        make.centerX.equalTo(self);
    }];
    [self.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.strategyBtn);
        make.right.equalTo(self.strategyBtn.mas_left).offset(-70);
    }];
    [self.productBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.strategyBtn);
//        make.left.equalTo(self.mas_centerX).equalTo(@14);
        make.left.equalTo(self.strategyBtn.mas_right).offset(70);
    }];
}


//- (void)layoutSubviews{
//    [super layoutSubviews];
//    if (self.arCardStyle) {
//        self.productBtn.hidden = YES;
//        self.strategyBtn.hidden = YES;
//        [self.helpBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(IPHONE_DEVICE?@58:@78);
//            make.width.equalTo(IPHONE_DEVICE?@48:@50);
//            make.bottom.equalTo(self).offset(IPHONEX_DEVICE?-31:2);
//            make.right.equalTo(self.mas_centerX).equalTo(@-14);
//        }];
//        [self.rootBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.width.height.equalTo(self.helpBtn);
//            make.left.equalTo(self.mas_centerX).equalTo(@14);
//        }];
//    }else{
//        self.productBtn.hidden = NO;
//        self.strategyBtn.hidden = NO;
//        [self.productBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.centerY.width.height.equalTo(self.strategyBtn);
//            make.left.equalTo(self.mas_centerX).equalTo(@14);
//        }];
//        [self.helpBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.width.height.equalTo(self.strategyBtn);
//            make.right.equalTo(self.strategyBtn.mas_left).equalTo(@-28);
//        }];
//        [self.strategyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(IPHONE_DEVICE?@58:@78);
//            make.width.equalTo(IPHONE_DEVICE?@48:@50);
//            make.bottom.equalTo(self).offset(IPHONEX_DEVICE?-31:2);
//            make.right.equalTo(self.mas_centerX).equalTo(@-14);
//        }];
//        [self.rootBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.width.height.equalTo(self.strategyBtn);
//            make.left.equalTo(self.productBtn.mas_right).equalTo(@28);
//        }];
//    }
//}

@end


@implementation FooterItemButton:MuItemButton


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.itemIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(0);
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
