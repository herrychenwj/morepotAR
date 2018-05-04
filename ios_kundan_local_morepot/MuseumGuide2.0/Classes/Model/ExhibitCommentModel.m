
//
//  ExhibitCommentModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ExhibitCommentModel.h"
#import "Communtil.h"
#import "YYText.h"
@implementation ExhibitCommentModel

- (void)setContent:(NSString *)content{
    _content = content;
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:_content attributes:nil]];
    text.yy_font = [UIFont systemFontOfSize:14] ;
    text.yy_color = [UIColor whiteColor];
    text.yy_lineSpacing = kYYLINE_SPACE;
    self.attributeContent = [text copy];
    NSMutableAttributedString *text2 = [NSMutableAttributedString new];
    [text2 appendAttributedString:[[NSAttributedString alloc] initWithString:[Communtil cleanString:_content] attributes:nil]];
    text2.yy_font = [UIFont systemFontOfSize:14];
    text2.yy_lineSpacing = kYYLINE_SPACE;
    self.cleanContent = [text2 copy];
}

- (CGFloat)cellHeight{
    CGFloat maxWidth = IPHONE_DEVICE?(kSCREEN_WIDTH - kINFOCONTROLLERLEFT_MARGIN - kINFOCONTROLLERRIGHT_MARGIN):kSCREEN_WIDTH*0.33-20;
//    NSString *content = [self.content stringByReplacingOccurrencesOfString:@" " withString:@"，"];
//    NSMutableAttributedString *text = [NSMutableAttributedString new];
//    UIFont *font = [UIFont systemFontOfSize:14];
//    //添加文本
//    [text appendAttributedString:[[NSAttributedString alloc] initWithString:content attributes:nil]];
//    text.yy_font = font ;
//    text.yy_color = [UIColor whiteColor];
//    text.yy_lineSpacing = kYYLINE_SPACE;
    CGFloat contentH = [Communtil yy_cellHeight:self.cleanContent openSwitch:self.isOpen maxWidth:maxWidth maxCellHeight:50];
    return self.isOpen ? contentH + 40+20:contentH + 42;
}


- (void)setLike:(NSString *)like{
    NSInteger likes = [like integerValue];
    if (likes == 0) {
        _like = @"";
    }else if (likes > 0 && likes < 1000){
        _like = like;
    }else if (likes >= 1000 && likes < 10000){
        _like = [NSString stringWithFormat:@"%.1fK+",likes/1000.f];
    }else{
        _like = [NSString stringWithFormat:@"%.2fW+",likes/10000.f];
    }
}


@end
