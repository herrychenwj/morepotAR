//
//  MeseumTableViewCell.m
//  Museum
//
//  Created by MR.Huang on 2017/2/16.
//  Copyright © 2017年 94kz. All rights reserved.
//

#import "MeseumTableViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation MeseumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.cornerRadius = 8.f;
        self.backgroundColor = HexRGBAlpha(0x000000, 0.45);
        _logoImageView = ({
            UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectZero];
            logo.layer.borderColor = [UIColor whiteColor].CGColor;
            logo.layer.borderWidth = 1.5f;
            logo.layer.masksToBounds = YES;
            [self addSubview:logo];
            logo;
        });
        _nameLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            [self addSubview:lb];
            lb.font = [UIFont systemFontOfSize:18];
            lb.textColor = [UIColor whiteColor];
            lb;
        });
        _addressLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            [self addSubview:lb];
            lb.font = [UIFont systemFontOfSize:14];
            lb.textColor = [UIColor whiteColor];
            lb.textColor = HexRGB(0xCCCCCC);
            lb;
        });
        _disLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            [self addSubview:lb];
            lb.textAlignment = NSTextAlignmentRight;
            lb.font = [UIFont systemFontOfSize:14];
            lb.textColor = [UIColor whiteColor];
            lb.textColor = HexRGB(0xCCCCCC);
            lb;
        });
        _anmiationView = ({
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imgView.image = [UIImage imageNamed:@"dianji"];
            imgView.hidden = YES;
            [self addSubview:imgView];
            imgView;
        });
    }
    return self;
}



- (void)layoutSubviews{
    [super layoutSubviews];
    [self.logoImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.mas_equalTo(_logoImageView.mas_height).multipliedBy(1);
        make.left.equalTo(self).offset(8);
        make.top.equalTo(@8);
        make.bottom.equalTo(@-8);
    }];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_logoImageView.mas_right).offset(20);
        make.topMargin.equalTo(@10);
        make.rightMargin.equalTo(@-8);
    }];
    [self.addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLB);
        make.top.equalTo(self.nameLB.mas_bottom).offset(4);
    }];
    [self.disLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressLB);
        make.top.equalTo(self.addressLB.mas_bottom).offset(2);
    }];
    [self.anmiationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-8);
        make.centerY.equalTo(self).offset(10);
        make.width.height.equalTo(@30);
    }];

}


- (void)setFrame:(CGRect)frame{
    CGRect f = frame;
    CGRect newF = CGRectMake(f.origin.x+26, f.origin.y+4,f.size.width-2*26, f.size.height - 2*4);
    self.logoImageView.layer.cornerRadius = (frame.size.height - 2*8-2*4)/2;
    [super setFrame:newF];
    if (self.anmiation){
        [self startAnmiation];
    }
}
    
- (void)setAnmiation:(BOOL)anmiation{
    _anmiation = anmiation;
    if (!_anmiation){
        self.anmiationView.hidden = YES;
    }
}
    
- (void)startAnmiation{
    self.anmiationView.hidden = NO;
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation]; keyAnimaion.keyPath = @"position";
    //度数转弧度
    CGPoint enP = CGPointMake(self.anmiationView.center.x - 10,self.anmiationView.center.y - 10);
    CGPoint startP = CGPointMake(self.anmiationView.center.x - 10,self.anmiationView.center.y - 10);
    keyAnimaion.values = @[[NSValue valueWithCGPoint:enP],[NSValue valueWithCGPoint:self.anmiationView.center],[NSValue valueWithCGPoint:startP]];
    keyAnimaion.removedOnCompletion = NO;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.8;
    keyAnimaion.repeatCount = INTMAX_MAX;
    [self.anmiationView.layer addAnimation:keyAnimaion forKey:nil];
}
@end
