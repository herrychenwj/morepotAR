//
//  ThirdPlatformLoginView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ThirdPlatformLoginView.h"
#import "MuItemButton.h"
#import <UMSocialCore/UMSocialCore.h>

@interface ThirdPlatformLoginView ()
@property (nonatomic,strong)UIImageView *leftLine;
@property (nonatomic,strong)UIImageView *rightLine;

@end

@implementation ThirdPlatformLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _leftLine = ({
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            img.image = [UIImage imageNamed:@"other_login_left"];
            [self addSubview:img];
            img;
        });
        _rightLine = ({
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectZero];
            img.image = [UIImage imageNamed:@"other_login_right"];
            [self addSubview:img];
            img;
        });
        _titleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:14];
            lb.textColor = [UIColor whiteColor];
            lb.textAlignment = NSTextAlignmentCenter;
            [self addSubview:lb];
            lb;
        });
        _QQLoginBtn = ({
            MuItemButton *btn = [[MuItemButton alloc]initWithFrame:CGRectZero];
            btn.itemIcon.image = [UIImage imageNamed:@"login_qq"];
            btn.itemLB.sakura.text(@"QQ");
            btn.tag = UMSocialPlatformType_QQ;
            [self addSubview:btn];
            btn;
        });
        _WeChatBtn = ({
            MuItemButton *btn = [[MuItemButton alloc]initWithFrame:CGRectZero];
            btn.itemIcon.image = [UIImage imageNamed:@"login_weixin"];
            btn.itemLB.sakura.text(@"wei");
            btn.tag = UMSocialPlatformType_WechatSession;
            [self addSubview:btn];
            btn;
        });
        _SinaBtn = ({
            MuItemButton *btn = [[MuItemButton alloc]initWithFrame:CGRectZero];
            btn.itemIcon.image = [UIImage imageNamed:@"login_weib"];
            btn.itemLB.sakura.text(@"sina");
            btn.tag = UMSocialPlatformType_Sina;
            [self addSubview:btn];
            btn;
        });
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLB);
        make.right.equalTo(self.titleLB.mas_left).offset(-2);
        make.left.equalTo(self);
        make.height.equalTo(@2);
    }];
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.leftLine);
        make.right.equalTo(self);
        make.left.equalTo(self.titleLB.mas_right).offset(2);
    }];
    [self.WeChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(74);
        make.width.equalTo(@50);
        make.height.equalTo(@60);
        make.bottom.equalTo(self).offset(-30);
    }];
    [self.QQLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.width.height.bottom.equalTo(self.WeChatBtn);
    }];
    [self.SinaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.bottom.equalTo(self.WeChatBtn);
        make.right.equalTo(self).offset(-74);
    }];
    
    
}




@end
