//
//  MuseumGuideViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MuseumGuideViewController.h"
#import "YYText.h"
#import "YYTextView.h"

@interface MuseumGuideViewController ()

@end

@implementation MuseumGuideViewController

- (void)initUI{
    [self setBackTitle:[TXSakuraManager tx_stringWithPath:@"back"]];
    YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectZero];
    textView.editable = NO;
    NSString *desc = [NSString stringWithFormat:@"苏州和云观博数字有限公司是全球首例全维度体验式智慧博物馆平台的开发者，公司依托强大的技术研发、深度资源整合以及开放创意平台，致力于创造全新的智慧博物馆生态圈。\n公司自主研发的“云观博智慧博物馆平台”，基于计算机机器视觉技术，结合云计算、物联网和大数据应用；突破了传统博物馆藏品展陈的时空限制，“让文物活起来”！通过多模态感知“大数据”，使受众与展品等元素之间的联系真正达到智慧化融合；建立更加全面、深入和泛在的互联互通，以“人为中心”的信息传递模式，将成为移动“互联网+”时代下，改变博物馆观览方式的革命性产品苏州和云观博数字有限公司是全移动“互联网+”时代下，改变博物馆观览方式的革命性产品。\n\n%@\n%@\n",@"联系我们：0512—62659817",@"电子邮件：heyunguanbo@morview.com"];
    NSMutableAttributedString *mStr = [NSMutableAttributedString new];
    [mStr appendAttributedString:[[NSAttributedString alloc] initWithString:desc]];
    mStr.yy_font = [UIFont systemFontOfSize:IPHONE_DEVICE?14:17];
    mStr.yy_lineSpacing = kYYLINE_SPACE;
    mStr.yy_color = [UIColor whiteColor];
    textView.attributedText = mStr;
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(IPHONE_DEVICE?kBACK_SPACE:kPADSETTING_LEFTMARGIN+kBACK_SPACE);
        make.right.bottom.equalTo(self.view).offset(-30);
        make.top.equalTo(self.view).offset(IPHONE_DEVICE?86:100);
    }];
}


@end
