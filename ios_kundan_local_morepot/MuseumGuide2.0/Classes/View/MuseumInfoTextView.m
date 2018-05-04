//
//  MuseumInfoTextView.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MuseumInfoTextView.h"
#import "YYLabel.h"
#import "YYText.h"
#import "YYTextAttribute.h"
#import "YYTextContainerView.h"

@interface MuseumInfoTextView ()
@property (nonatomic,strong)YYLabel *contentLB;
@end

@implementation MuseumInfoTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.layer.cornerRadius = 8.f;
        _contentLB = ({
            YYLabel *lb = [[YYLabel alloc]initWithFrame:CGRectZero];
            lb.textVerticalAlignment =YYTextVerticalAlignmentTop;
            lb.userInteractionEnabled =YES;
            lb.numberOfLines = 0;
            lb.backgroundColor = [UIColor clearColor];
            [self addSubview:lb];
            lb;
        });

//        [self addSeeMoreButton];
    }
    return self;
}
- (void)addSeeMoreButton {
    __weak typeof(self) weakself =self;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...全文"];
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:[UIColor whiteColor]];
    hi.tapAction = ^(UIView *containerView,NSAttributedString *text,NSRange range, CGRect rect) {
        YYLabel *label = weakself.contentLB;
        [label sizeToFit];
        [self layoutSubviews];
        if (self.relayout) {
            self.relayout();
        }
    };
    text.yy_color = [UIColor whiteColor];
    text.yy_font = [UIFont systemFontOfSize:15];
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:@"...全文"]];
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentCenter];
    self.contentLB.truncationToken = truncationToken;
}

- (void)setContentText:(NSString *)string{
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font = [UIFont systemFontOfSize:15];
    //添加文本
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:nil]];
    text.yy_font = font ;
    text.yy_color = [UIColor whiteColor];
    text.yy_lineSpacing = kYYLINE_SPACE;
    self.contentLB.attributedText = text;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.topMargin.equalTo(@12);
        make.right.equalTo(self).offset(-10);
        make.bottomMargin.equalTo(@-12);
    }];
}


@end
