//
//  ARHomeView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2018/5/10.
//  Copyright © 2018年 Heyunguanbo. All rights reserved.
//

#import "ARHomeView.h"
#import <SDWebImage/UIButton+WebCache.h>

@implementation ARHomeView

- (void)hideAllElement{
      self.closeVideoBtn.hidden =  self.exhibitBtn.hidden = self.enExhibitBtn.hidden = YES;
}

- (void)resetExhibitName{
    self.exhibitBtn.verticalTitle = self.enExhibitBtn.horizaontalTitle = @"";
}

- (void)showExhibitName:(NSString *)name en:(BOOL)is_en{
    if (!is_en) {
        self.exhibitBtn.hidden = NO;
        self.exhibitBtn.verticalTitle = name;
    }else{
        self.enExhibitBtn.hidden = NO;
        self.enExhibitBtn.horizaontalTitle = name;
    }
}

- (void)showLogoAndFoot{
    self.footerView.alpha  = self.logoBtn.alpha = 1;
}

- (void)hideLogoAndFoot{
    self.footerView.alpha  = self.logoBtn.alpha = 0;
}


- (void)tapAnmiationhide{
    self.footerView.alpha  = self.logoBtn.alpha = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.f animations:^{
            self.footerView.alpha  = self.logoBtn.alpha = 0;
        }];
    });
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.takePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(IPHONE_DEVICE?@70:@80);
        make.height.equalTo(IPHONE_DEVICE?@90:@100);
        if (IPHONE_DEVICE) {
            make.centerX.equalTo(self);
        }
        else{
            make.right.equalTo(self).offset(-150);
        }
        make.bottom.equalTo(self).offset(-25);
    }];
    
    [self.closeVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-180);
        make.left.equalTo(self).offset(30);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(IPHONE_DEVICE?(IPHONEX_DEVICE?@81:@49):@92);
    }];
    [self.warningLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.exhibitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(50);
        make.centerY.equalTo(self).offset(-60);
        make.width.equalTo(@40);
    }];
    [self.enExhibitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.centerY.equalTo(self).offset(-100);
        make.height.equalTo(@80);
    }];
    [self.logoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IPHONE_DEVICE) {
            make.top.equalTo(IPHONEX_DEVICE?@45:@25);
            make.left.equalTo(@25);
        }else{
            make.left.equalTo(self).offset(43);
            make.top.equalTo(self).offset(26);
        }
        make.width.equalTo(IPHONE_DEVICE?@140:@215);
        make.height.equalTo(self.logoBtn.mas_width).multipliedBy(11.0/46.0);
    }];
}


- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    _takePhotoBtn = ({
        UIButton *takePhotoBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"tabkephotopic"] forState:UIControlStateNormal];
        takePhotoBtn.hidden = YES;
        [self addSubview:takePhotoBtn];
        takePhotoBtn;
    });
    _exhibitBtn = ({
        VerticalButton *btn = [[VerticalButton alloc]initWithFrame:CGRectZero];
        btn.userInteractionEnabled = NO;
        [self addSubview:btn];
        btn;
    });
    _enExhibitBtn = ({
        HorizontalButton *btn = [[HorizontalButton alloc]initWithFrame:CGRectZero];
        btn.userInteractionEnabled = NO;
        [self addSubview:btn];
        btn;
    });
    
    _closeVideoBtn = ({
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"closevideo"] forState:UIControlStateNormal];
        closeBtn.hidden = YES;
        [self addSubview:closeBtn];
        closeBtn;
    });
    
    _footerView = ({
        HomeFooterView *footer = [[HomeFooterView alloc]initWithFrame:CGRectZero];
        footer.backgroundColor = HexRGBAlpha(0x000000, 0.7);
        [self addSubview:footer];
        footer;
    });
    _warningLB = ({
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
        lb.sakura.text(@"please_scan_on");
        BOOL en = [[[NSUserDefaults standardUserDefaults]objectForKey:kLOCALIZABLE] isEqualToString:@"en"];
        lb.font = [UIFont systemFontOfSize:IPHONE_DEVICE?(en?18:21):25];
        lb.textColor = [UIColor whiteColor];
        lb.hidden = YES;
        [self addSubview:lb];
        lb;
    });
    _logoBtn = ({
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        [self addSubview:btn];
        btn;
    });
    

}
@end
