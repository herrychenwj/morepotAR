//
//  MyCommentViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MyCommentViewController.h"
#import "MyCommentHeaderView.h"
#import "YYTextView.h"
#import "YYText.h"
#import "ExhibitViewController.h"
#import "EnshrineViewModel.h"

@interface MyCommentViewController ()
@property (nonatomic,strong)MyCommentModel *cmtModel;
@end

@implementation MyCommentViewController
+ (MyCommentViewController *)controllerWithComment:(MyCommentModel *)cmt{
    MyCommentViewController *vc = [[MyCommentViewController alloc]init];
    vc.cmtModel = cmt;
    return vc;
}



#pragma mark initUI
- (void)initUI{
    [self setBackTitle:[TXSakuraManager tx_stringWithPath:@"mycomment"]];
    self.view.backgroundColor = HexRGB(0x202126);
    MyCommentHeaderView *exhibitV = [[MyCommentHeaderView alloc]initWithFrame:CGRectZero];
    YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectZero];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    [self.view addSubview:textView];
    [self.view addSubview:exhibitV];
    [exhibitV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(IPHONE_DEVICE?30:kPADSETTING_LEFTMARGIN+30);
        make.right.equalTo(self.view).offset(IPHONE_DEVICE?-30:-90);
        make.top.equalTo(self.view).offset(76);
        make.height.equalTo(@96);
    }];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(IPHONE_DEVICE?27:kPADSETTING_LEFTMARGIN+27);
        make.right.equalTo(self.view).offset(IPHONE_DEVICE?-25:-85);
        make.top.equalTo(exhibitV.mas_bottom).offset(4);
        make.bottom.equalTo(self.view).offset(-30);
    }];
    RAC(exhibitV.exhibitNameLB,text) = RACObserve(self.cmtModel, exhibitname);
    RAC(exhibitV.timeLB,text) = RACObserve(self.cmtModel,created_at);
    RAC(textView,attributedText) = [RACObserve(self.cmtModel, content) map:^id(NSString *value) {
        NSMutableAttributedString *mStr = [NSMutableAttributedString new];
        [mStr appendAttributedString:[[NSAttributedString alloc] initWithString:value]];
        mStr.yy_lineSpacing = kYYLINE_SPACE;
        mStr.yy_color = [UIColor whiteColor];
        mStr.yy_font = [UIFont systemFontOfSize:14];
        return [mStr copy];
    }];
    [RACObserve(self.cmtModel, imageurl) subscribeNext:^(NSString *x) {
        [exhibitV.exhibitImg sd_setImageWithURL:[NSURL URLWithString:x.cloudPath] placeholderImage:kPLACEHOLDERIMAGE];
    }];
    EnshrineViewModel *viewModel = [[EnshrineViewModel alloc]init];
    @weakify(self);
    [[[exhibitV rac_signalForControlEvents:UIControlEventTouchUpInside] autoPlaySound]subscribeNext:^(id x) {
        @strongify(self);
        [viewModel.exhibitInfoCmd execute:self.cmtModel.exhibit_id?:@""];
    }];
    [[viewModel.exhibitInfoCmd.executionSignals.switchToLatest autoPlaySound]subscribeNext:^(ExhibitInfoModel *x) {
        @strongify(self);
        x.ispaid = YES;
        ExhibitViewController *vc = [ExhibitViewController exhibitControllerWithInfo:x];
        vc.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"search_back"].CGImage);
        [self.navigationController pushViewController:vc animated:YES];
    }];
}


@end
