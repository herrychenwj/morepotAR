//
//  VerticalButton.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/17.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "VerticalButton.h"
#import "YYText.h"

@interface VerticalButton ()

@property (nonatomic,strong)UILabel *titleLB;

@end

@implementation VerticalButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _titleLB = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLB.numberOfLines = 0;
        _titleLB.textAlignment  = NSTextAlignmentCenter;
        [self addSubview:_titleLB];
    }
    return self;
}


- (void)setVerticalTitle:(NSString *)verticalTitle{
    if (_verticalTitle != verticalTitle && verticalTitle != nil && ![verticalTitle isKindOfClass:[NSNull class]]&&verticalTitle.length > 0) {
        _verticalTitle = verticalTitle;
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
        textAttachment.image = [UIImage imageNamed:@"text_labels_in_brackets_top"];
        NSAttributedString *strTop = [NSAttributedString attributedStringWithAttachment:textAttachment];
        NSTextAttachment *textAttachment2 = [[NSTextAttachment alloc]init];
        textAttachment2.image = [UIImage imageNamed:@"text_labels_in_brackets_bottom"];
        NSAttributedString *strBottom = [NSAttributedString attributedStringWithAttachment:textAttachment2];
        NSMutableAttributedString *result = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"<%@>",_verticalTitle]];
        [result replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:strTop];
        [result replaceCharactersInRange:NSMakeRange(_verticalTitle.length+2 -1, 1) withAttributedString:strBottom];
        result.yy_verticalGlyphForm = YES;
        result.yy_lineSpacing = 2;
        result.yy_font = [UIFont systemFontOfSize:21];
        result.yy_color = [UIColor whiteColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLB.attributedText = [result copy];
        [self layoutIfNeeded];
    }
}

- (void)layoutIfNeeded{
    [super layoutIfNeeded];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((self.verticalTitle.length+2) * 35));
    }];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(([UIScreen mainScreen].bounds.size.width <= 375)?0:12);
        make.right.equalTo(self).offset(([UIScreen mainScreen].bounds.size.width <= 375)?0:-12);
        make.top.bottom.equalTo(self);
    }];
}





@end
