//
//  SystemGuideViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "SystemGuideViewController.h"
#import "Communtil.h"
#import "YYTextView.h"
#import "YYText.h"

@interface SystemGuideViewController ()

@end

@implementation SystemGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0x202126);
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectZero];
    logo.image = [UIImage imageNamed:@"system_about"];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:logo];
    YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectZero];
    textView.editable = NO;
    NSString *infoStr;
    switch (self.type) {
        case SystemGuideType: //
//            [self setBackTitle:NSLocalizedString(@"setting_instructions", nil)];
//            infoStr = [NSString stringWithFormat:@"  苏州和云观博数字科技有限公司（以下称“本公司”）制作本应用程序，旨在通过智慧移动终端向公众展示信息。使本应用程序及其内容即表示您同意遵守以下条款，本公司可能随时对以下条款作出变更：\n本应用程序为苏州和云观博数字科技有限公司所有本应用程序中的文字、图片、标记、图标及其他内容均为苏州和云观博数字科技有限公司所有。\n本公司授权您在下述条件下浏览、下载、打印该应用程序内容：\n1、除特殊规定外，您仅可将这些内容用作个人而非商业用途，或是由中华人民共和国版权法规定之合理用途；\n2、禁止出于商业目的下载本应用程序的内容；\n3、将下载和复制的本应用程序用于个人网站、应用程序和博客须首先经过本公司审查和许可，且您的站点、应用程序或博客不得做广告、不得使用商业赞助、不得收取服务费、不销售包括您个人作品在内的产品或服务，申请个人在线使用本应用程序内容请联系：\nheyunguanbo@morview.com\n4、请勿去除任何版权、商标或所有人通告类的内容，包括并不仅限于本公司置于本应用程序内容或其他相关的归属信息、材料来源注解、版权通告等；\n5、请勿对本应用程序内容进行更改；\n6、任何对本应用程序的展示或打印必须标明“©【插入展示或打印年份】苏州和云观博数字科技有限公司”。\n7、以任何方式下载、打印或使用本应用程序内容的所有人员或单位均需保证其使用遵守授权条款，且不侵害或违反任何他人或机构的权益、违反与其他个人或机构的合同或对其所负有的法律责任。使用图片或其他内容的授权申请除上面明确允许的范围外，在没有首先得到本公司书面授权的情况下，严格禁止复制或发布本应用程序内容或其任何一部分。"];
            break;
        case SystemAbout:
            [self setBackTitle:[TXSakuraManager tx_stringWithPath:@"about_us_button"]];
            infoStr = [TXSakuraManager tx_stringWithPath:@"about_us"];
            break;
        case SystemExemption:
//            [self setBackTitle:@"免责条款"];
//            infoStr = [NSString stringWithFormat:@"  苏州和云观博数字科技有限公司（以下称“本公司”）制作本应用程序，旨在通过智慧移动终端向公众展示信息。使本应用程序及其内容即表示您同意遵守以下条款，本公司可能随时对以下条款作出变更：\n本应用程序为苏州和云观博数字科技有限公司所有本应用程序中的文字、图片、标记、图标及其他内容均为苏州和云观博数字科技有限公司所有。本公司授权您在下述条件下浏览、下载、打印该应用程序内容：\n1、除特殊规定外，您仅可将这些内容用作个人而非商业用途，或是由中华人民共和国版权法规定之合理用途；\n2、禁止出于商业目的下载本应用程序的内容；\n3、将下载和复制的本应用程序用于个人网站、应用程序和博客须首先经过本公司审查和许可，且您的站点、应用程序或博客不得做广告、不得使用商业赞助、不得收取服务费、不销售包括您个人作品在内的产品或服务，申请个人在线使用本应用程序内容请联系：heyunguanbo@morview.com\n4、请勿去除任何版权、商标或所有人通告类的内容，包括并不仅限于本公司置于本应用程序内容或其他相关的归属信息、材料来源注解、版权通告等；\n5、请勿对本应用程序内容进行更改；\n6、任何对本应用程序的展示或打印必须标明“©️【插入展示或打印年份】苏州和云观博数字科技有限公司”。\n7、以任何方式下载、打印或使用本应用程序内容的所有人员或单位均需保证其使用遵守授权条款，且不侵害或违反任何他人或机构的权益、违反与其他个人或机构的合同或对其所负有的法律责任。使用图片或其他内容的授权申请除上面明确允许的范围外，在没有首先得到本公司书面授权的情况下，严格禁止复制或发布本应用程序内容或其任何一部分。"];
            break;
        default:
            break;
    }
    NSMutableAttributedString *mStr = [NSMutableAttributedString new];
    [mStr appendAttributedString:[[NSAttributedString alloc] initWithString:infoStr]];
    mStr.yy_font = [UIFont systemFontOfSize:15];
    mStr.yy_lineSpacing = kYYLINE_SPACE;
    mStr.yy_color = [UIColor whiteColor];
    
    textView.attributedText = mStr;
    [self.view addSubview:textView];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@120);
        make.top.equalTo(self.view).mas_offset(96);
        make.centerX.equalTo(self.view).offset(IPHONE_DEVICE?0:kPADSETTING_LEFTMARGIN/2);
        make.width.equalTo(logo.mas_height).multipliedBy(269.0/317.0);
    }];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        IPHONE_DEVICE?make.left.equalTo(self.view).offset(kBACK_SPACE):make.centerX.equalTo(logo);
        make.right.bottom.equalTo(self.view).offset(-50);
        make.top.equalTo(logo.mas_bottom).offset(20);
    }];
    if (self.type != SystemGuideType) return;
    UILabel *versionLB = [[UILabel alloc]initWithFrame:CGRectZero];
    versionLB.font = [UIFont systemFontOfSize:15];
    versionLB.textAlignment = NSTextAlignmentCenter;
    versionLB.textColor = [UIColor whiteColor];
    versionLB.text = [NSString stringWithFormat:@"V %@",[Communtil app_versionNumber]];
    [self.view addSubview:versionLB];
    [versionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(IPHONE_DEVICE?self.view:logo);
        make.bottom.equalTo(self.view).offset(-20);
    }];
}


@end
