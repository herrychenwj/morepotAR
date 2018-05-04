//
//  LoginProtocolView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/11.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "LoginProtocolView.h"
#import "YYText.h"

@implementation LoginProtocolView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _chcekBox = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [btn setImage:[UIImage imageNamed:@"checkin"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"checkout"] forState:UIControlStateSelected];
            [self addSubview:btn];
            btn;
        });
        _titleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
//            lb.sakura.text(@"accept_descripe");
            NSString *accept = [TXSakuraManager tx_stringWithPath:@"accept_descripe"];
            NSString *descripe = [TXSakuraManager tx_stringWithPath:@"descripe"];
            NSString *txt = [NSString stringWithFormat:@"%@  %@",accept,descripe];
            lb.numberOfLines = 2;
//            lb.font = [UIFont systemFontOfSize:12];
//            lb.textColor = [UIColor whiteColor];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:txt];
            attr.yy_font = [UIFont systemFontOfSize:12];
            attr.yy_color = [UIColor whiteColor];
            attr.yy_underlineColor = [UIColor whiteColor];
            NSRange range = [txt rangeOfString:descripe];
            [attr yy_setUnderlineStyle:NSUnderlineStyleSingle range:range];
            lb.attributedText = attr;
            [self addSubview:lb];
            lb;
        });
        _protocolBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            [self addSubview:btn];
            btn;
        });
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.chcekBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.with.equalTo(@20);
        make.left.centerY.equalTo(self);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chcekBox.mas_right).offset(2);
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self);
    }];
    [self.protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.titleLB);
    }];
}


@end
