//
//  MuseumInfoTextTableViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MuseumInfoTextTableViewCell.h"

#import "YYText.h"
#import "YYTextAttribute.h"
#import "YYTextContainerView.h"

#define kMaxCellHeight  125.f
@interface MuseumInfoTextTableViewCell ()

@end
@implementation MuseumInfoTextTableViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier hasMore:(BOOL)hasMore{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (hasMore) {
            [self initData];
        }
        else{
            [self initDataWithoutMore];
        }
    }
    return self;
}


- (void)initDataWithoutMore{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.layer.cornerRadius = 8.f;
    self.layer.masksToBounds = YES;
    _contentLB = ({
        YYLabel *lb = [[YYLabel alloc]initWithFrame:CGRectZero];
        lb.textVerticalAlignment =YYTextVerticalAlignmentTop;
        lb.userInteractionEnabled =YES;
        lb.numberOfLines = 0;
        lb.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lb];
        lb;
    });
}


- (void)initData{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.layer.cornerRadius = 8.f;
    self.layer.masksToBounds = YES;
    _contentLB = ({
        YYLabel *lb = [[YYLabel alloc]initWithFrame:CGRectZero];
        lb.textVerticalAlignment =YYTextVerticalAlignmentTop;
        lb.userInteractionEnabled =YES;
        lb.numberOfLines = 0;
        lb.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lb];
        lb;
    });
    _closeBtn = ({
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        btn.backgroundColor = [UIColor clearColor];
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
        lb.font = [UIFont systemFontOfSize:14];
        lb.textAlignment = NSTextAlignmentRight;
        lb.text = [TXSakuraManager tx_stringWithPath:@"close"];
        lb.textColor = [UIColor whiteColor];
        [btn addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(btn).insets(UIEdgeInsetsZero);
        }];
        btn.hidden = YES;
        [btn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        btn;
    });
    [self addSeeMoreButton];
}



- (void)addSeeMoreButton {
    __weak typeof(self) weakself =self;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[TXSakuraManager tx_stringWithPath:@"all"]];
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:[UIColor whiteColor]];
    hi.tapAction = ^(UIView *containerView,NSAttributedString *text,NSRange range, CGRect rect) {
        if (weakself.reload) {
            weakself.reload();
        }
        YYLabel *label = weakself.contentLB;
        [label sizeToFit];
    };
    text.yy_color = [UIColor whiteColor];
    text.yy_font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:[TXSakuraManager tx_stringWithPath:@"all"]]];
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.yy_font alignment:YYTextVerticalAlignmentCenter];
    self.contentLB.truncationToken = truncationToken;
}


- (void)closeAction:(id)sender{
    if (self.reload) {
        self.reload();
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(18);
        make.right.equalTo(self.contentView).offset(-8);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self).offset(-8);
        make.height.equalTo(@20);
        make.width.equalTo(@80);
    }];
}



@end
