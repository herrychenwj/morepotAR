//
//  DiscussTableViewCell.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "DiscussTableViewCell.h"
#import "YYLabel.h"
#import "YYText.h"
#import "YYTextAttribute.h"
#import "YYTextContainerView.h"

@implementation DiscussTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.layer.cornerRadius = 8.f;
        self.layer.masksToBounds = YES;
        
        _nameLB = ({
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:14];
            lb.textColor = HexRGB(0xb3b3b3);
            [self.contentView addSubview:lb];
            lb;
        });
//        _supportBtn = ({
//            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
//            btn.backgroundColor = [UIColor clearColor];
//            [btn setImage:[UIImage imageNamed:@"comment_point_praise"] forState:UIControlStateNormal];
//            [btn setImage:[UIImage imageNamed:@"comment_point_praise"] forState:UIControlStateHighlighted];
//            [btn setImage:[UIImage imageNamed:@"comment_point_praise_ed"] forState:UIControlStateDisabled];
//            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
//            btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
//            btn.titleLabel.font = [UIFont systemFontOfSize:14];
//            [self.contentView addSubview:btn];
//            btn;
//        });
        _contentLB = ({
            YYLabel *lb = [[YYLabel alloc]initWithFrame:CGRectZero];
            lb.textVerticalAlignment =YYTextVerticalAlignmentTop;
            lb.userInteractionEnabled =YES;
            lb.numberOfLines = 0;
            lb.font = [UIFont systemFontOfSize:14];
            lb.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:lb];
            lb;
        });
        
        _closeBtn = ({
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
            btn.backgroundColor = [UIColor clearColor];
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
            lb.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
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
    return self;
    
}

- (void)closeAction:(id)sender{
    if (self.reload) {
        self.reload();
    }
}

- (void)addSeeMoreButton {
    __weak typeof(self) weakself =self;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[TXSakuraManager tx_stringWithPath:@"all"]];
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:[UIColor whiteColor]];
    hi.tapAction = ^(UIView *containerView,NSAttributedString *text,NSRange range, CGRect rect) {
        YYLabel *label = weakself.contentLB;
        [label sizeToFit];
        if (weakself.reload) {
            weakself.reload();
        }
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

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(4);
        make.left.equalTo(self.contentView).offset(12);
        make.height.equalTo(@20);
    }];
    [self.supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(self.nameLB);
        make.right.equalTo(self.contentView).offset(-8);
        make.width.equalTo(@60);
    }];
    [self.contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLB.mas_bottom).offset(4);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-8);
        make.bottom.equalTo(self.contentView).offset(-4);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-8);
        make.bottom.equalTo(self).offset(-8);
        make.height.equalTo(@20);
        make.width.equalTo(@80);
    }];
}

- (void)setComment:(ExhibitCommentModel *)cmt{
    NSString *s;
    if ([cmt.fake boolValue]) {
        s = @"精选评论";
    }else{
        NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
        [fmt setDateFormat:@"YYY-MM-dd HH:mm"];
        NSDate *time = [NSDate dateWithTimeIntervalSince1970:[cmt.adddate floatValue]];
        s = [fmt stringFromDate:time];
    }
    self.contentLB.attributedText = cmt.attributeContent;
    NSString *cmtstr = [NSString stringWithFormat:@"%@  %@",cmt.username,s];
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc]initWithString:cmtstr];
    NSRange range1 = [cmtstr rangeOfString:cmt.username options:NSCaseInsensitiveSearch];
    NSRange range2 = [cmtstr rangeOfString:s options:NSCaseInsensitiveSearch];
    [mstr yy_setFont:[UIFont systemFontOfSize:14] range:range1];
    [mstr yy_setFont:[UIFont systemFontOfSize:12] range:range2];
    mstr.yy_color = HexRGB(0xb3b3b3);
    self.nameLB.attributedText = [mstr copy];
    self.closeBtn.hidden = !cmt.isOpen;
    self.supportBtn.enabled = !cmt.isCmt;
    [self.supportBtn setTitle:cmt.like forState:UIControlStateNormal];
}

@end
