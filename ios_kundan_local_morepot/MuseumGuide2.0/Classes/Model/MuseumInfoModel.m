//
//  MuseumInfoModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MuseumInfoModel.h"
#import "Communtil.h"
#import "YYText.h"


@implementation MuseumInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"mdescription":@"description"};
}


- (void)setMdescription:(NSString *)mdescription{
    _mdescription = mdescription;
    _mdescription = [_mdescription stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font = [UIFont systemFontOfSize:13];
    //添加文本
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:_mdescription attributes:nil]];
    text.yy_font = font ;
    text.yy_color = [UIColor whiteColor];
    text.yy_lineSpacing = kYYLINE_SPACE;
    self.attributeDesc = [text copy];
}

- (NSAttributedString *)attributeAddress{
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font = [UIFont systemFontOfSize:13];
    //添加文本
    NSString *textS = [NSString stringWithFormat:@"%@%@\n%@%@\n%@%@\n%@%@\n%@%@\n%@%@",[TXSakuraManager tx_stringWithPath:@"opentime"],self.opentime,[TXSakuraManager tx_stringWithPath:@"bookingline"],self.appointtel,[TXSakuraManager tx_stringWithPath:@"connect"],self.complaintel,[TXSakuraManager tx_stringWithPath:@"address"],self.address,[TXSakuraManager tx_stringWithPath:@"homepage"],self.homepage,[TXSakuraManager tx_stringWithPath:@"traffic"],self.traffic];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:textS attributes:nil]];
    text.yy_font = font ;
    text.yy_color = [UIColor whiteColor];
    text.yy_lineSpacing = kYYLINE_SPACE;
    return [text copy];
}



- (CGFloat)descRowHeight{
    CGFloat maxWidth = IPHONE_DEVICE? (kSCREEN_WIDTH - 64 - 28):(kSCREEN_WIDTH*0.42-28-20);
    return [Communtil yy_cellHeight:self.attributeDesc openSwitch:self.isOpen maxWidth:maxWidth maxCellHeight:125]+(self.isOpen?20:0)+(IPHONE_DEVICE?30:35);
}

- (CGFloat)addressRowHeight{
    CGFloat maxWidth = IPHONE_DEVICE? (kSCREEN_WIDTH - 64 - 28):(kSCREEN_WIDTH*0.42-28-20);
    return [Communtil yy_cellHeight:self.attributeAddress openSwitch:YES maxWidth:maxWidth maxCellHeight:1000000]+(IPHONE_DEVICE?26:30);
}


@end
