//
//  LoginField.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "LoginField.h"


@interface LoginField ()
@property (nonatomic,strong)UIView *bottomLine;

@end
@implementation LoginField

- (instancetype)initWithFrame:(CGRect)frame FieldType:(FieldType)type{
    if (self = [super initWithFrame:frame]) {
        _fdType = type;
        _textFD = ({
            UITextField *fd = [[UITextField alloc]initWithFrame:CGRectZero];
            fd.textColor = [UIColor whiteColor];
            fd.font = [UIFont systemFontOfSize:IPHONE_DEVICE?14:16];
            fd.keyboardType = UIKeyboardTypeNumberPad;
            [self addSubview:fd];
            fd;
        });
        _bottomLine = ({
            UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
            line.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:line];
            line;
        });
        if ( _fdType == FieldTypeUserName) {
            _codeBtn = ({
                AuthCodeButtom *btn = [[AuthCodeButtom alloc]initWithFrame:CGRectZero];
                [btn setTitle:[TXSakuraManager tx_stringWithPath:@"send_identifyin_code"] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setTitleColor:HexRGB(0x969696) forState:UIControlStateDisabled];
                btn.titleLabel.font = [UIFont systemFontOfSize:IPHONE_DEVICE?14:16];
                [self addSubview:btn];
                btn;
            });
        }
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textFD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(( _fdType == FieldTypeUserName)?self.codeBtn.mas_left:self);
        make.centerY.equalTo(self);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.centerY.equalTo(self);
        make.width.equalTo(IPHONE_DEVICE?@80:@100);
    }];
    
}


@end
