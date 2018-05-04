//
//  ProgressBar.m
//  PresentStyle
//
//  Created by Mr.Huang on 2017/3/22.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//


#import "ProgressBar.h"
#import <Masonry/Masonry.h>


@interface ProgressBar ()
@property (nonatomic,strong)UIProgressView *progressView;
@property (nonatomic,strong)TagView *tagView;

@end

static BOOL isAnmination = NO;
@implementation ProgressBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.progressView = ({
            UIProgressView *progress = [[UIProgressView alloc]initWithFrame:CGRectZero];
            progress.trackTintColor = [UIColor lightGrayColor];
            progress.progressTintColor = [UIColor whiteColor];
            [self addSubview:progress];
            progress;
        });
        self.tagView = ({
            TagView *tagView = [[TagView alloc]initWithFrame:CGRectZero];
            [self addSubview:tagView];
            tagView;
        });
        [self.progressView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.equalTo(self).offset(40);
            make.right.equalTo(self).offset(-40);
            make.height.equalTo(@3);
        }];
        [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.progressView.mas_left);
            make.bottom.equalTo(self.progressView.mas_top);
            make.height.equalTo(@40);
            make.width.equalTo(@50);
        }];
    }
    return self;
}


- (void)setCurrentValue:(float)currentValue{
    _currentValue = currentValue;
    [self.progressView setProgress:_currentValue animated:YES];
    self.tagView.titleLB.text = [NSString stringWithFormat:@"%.2f%%",_currentValue*100];
    CGFloat curX = ([UIScreen mainScreen].bounds.size.width - 80)*_currentValue;
    [UIView animateWithDuration:0.1 animations:^{
        [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.progressView.mas_left).offset(curX);
        }];
    }];
    if (!isAnmination && _currentValue < 1.f) { //如果不在动画中
        [self.tagView.layer addAnimation:[self shakeAnimation] forKey:nil];
        isAnmination = YES;
    }else if (isAnmination && _currentValue >= 1.f){
        isAnmination = NO;
        [self.tagView.layer removeAllAnimations];
        //执行翻转动画
        [self rotationAnimation];
        self.tagView.titleLB.text = @"完成";
    }
    [self.tagView layoutIfNeeded];

}


-(void)rotationAnimation{
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.tagView cache:NO];
    [UIView commitAnimations];
}



- (CABasicAnimation *)shakeAnimation {
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:+0.3];
    shake.toValue = [NSNumber numberWithFloat:-0.3];
    shake.duration = 0.4;
    shake.autoreverses = YES; //是否重复
    shake.repeatCount  = MAXFLOAT;
    return shake;
 
}




@end

@implementation TagView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imgView = ({
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
            imgView.image = [UIImage imageNamed:@"speech-bubble-center"];
            imgView.tag = 100;
            [self addSubview:imgView];
            imgView;
        });
        _titleLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.textColor = [UIColor whiteColor];
            lb.font = [UIFont systemFontOfSize:14];
            lb.tag = 101;
            lb.textAlignment = NSTextAlignmentCenter;
            [self addSubview:lb];
            lb;
        });
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self).offset(-20);
    }];
}



@end
