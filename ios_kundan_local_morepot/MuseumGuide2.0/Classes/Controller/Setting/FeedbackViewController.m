//
//  FeedbackViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/30.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackViewModel.h"
#import "MBProgressHUD+Add.h"
#import "YYText.h"
@interface FeedbackViewController ()
@property (nonatomic,strong)UITextField *contactFD;
@property (nonatomic,strong)YYTextView *contentText;
@property (nonatomic,strong)UIButton *submitBtn;
@property (nonatomic,strong)FeedbackViewModel *viewModel;
@end

@implementation FeedbackViewController

- (void)bindViewModel{
    self.viewModel = [[FeedbackViewModel alloc]initWithHUDShowView:self.view];
    RAC(self.viewModel,contact) = self.contactFD.rac_textSignal;
    RAC(self.viewModel,content) = RACObserve(self.contentText, text);
    self.submitBtn.rac_command = self.viewModel.submitCmd;
    @weakify(self);
    [[self.viewModel.submitCmd.executionSignals.switchToLatest autoPlaySound]subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD showMessag:[TXSakuraManager tx_stringWithPath:@"feedback_su"] toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];

}

- (void)initUI{
    [self setBackTitle:[TXSakuraManager tx_stringWithPath:@"feedback"]];
    self.view.backgroundColor = HexRGB(0x202126);
    _contactFD = ({
        UITextField *fd = [[UITextField alloc]initWithFrame:CGRectZero];
        NSMutableAttributedString *attrUser = [[NSMutableAttributedString alloc]initWithString:[TXSakuraManager tx_stringWithPath:@"pleasenumber"] attributes:@{NSForegroundColorAttributeName:HexRGB(0xb6b6b7)}];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 0)];
        fd.leftView = view;
        fd.leftViewMode = UITextFieldViewModeAlways;
        fd.attributedPlaceholder = [attrUser copy];
        fd.textColor = [UIColor whiteColor];
        fd.layer.borderColor = HexRGB(0x808080).CGColor;
        fd.layer.cornerRadius = IPHONE_DEVICE?4.f:8.f;
        fd.layer.masksToBounds = YES;
        fd.layer.borderWidth = 1.f;
        fd.backgroundColor = HexRGB(0x666666);
        [self.view addSubview:fd];
        fd;
    });
    _contentText = ({
        YYTextView *text = [[YYTextView alloc]initWithFrame:CGRectZero];
        text.contentInset = UIEdgeInsetsMake(0, 4, 0, 0);
        text.placeholderText = [TXSakuraManager tx_stringWithPath:@"tellus"];
        text.placeholderFont = [UIFont systemFontOfSize:17];
        text.font = [UIFont systemFontOfSize:17];
        text.placeholderTextColor = HexRGB(0xb6b6b7);
        text.textColor = [UIColor whiteColor];
        text.backgroundColor = HexRGB(0x666666);
        text.layer.borderColor = HexRGB(0x808080).CGColor;
        text.layer.cornerRadius = IPHONE_DEVICE?8.f:12.f;
        text.layer.masksToBounds = YES;
        text.layer.borderWidth = 1.f;
        [self.view addSubview:text];
        text;
    });
    _submitBtn = ({
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        [btn setTitle:[TXSakuraManager tx_stringWithPath:@"submit"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        btn.backgroundColor = HexRGB(0x666666);
        btn.layer.borderColor = HexRGB(0x808080).CGColor;
        btn.layer.cornerRadius = IPHONE_DEVICE?14.f:20.f;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1.f;
        [self.view addSubview:btn];
        btn;
    });
    [self.contactFD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(IPHONE_DEVICE?30:kPADSETTING_LEFTMARGIN+32);
        make.right.equalTo(self.view).offset(IPHONE_DEVICE?-30:-90);
        make.top.equalTo(self.backBtn.mas_bottom).offset(IPHONE_DEVICE?20:50);
        make.height.equalTo(IPHONE_DEVICE?@34:@44);
    }];
    [self.contentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contactFD);
        make.height.equalTo(@150);
        make.top.equalTo(self.contactFD.mas_bottom).offset(20);
    }];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IPHONE_DEVICE) {
            make.left.right.height.equalTo(self.contactFD);
        }else{
            make.width.equalTo(self.contactFD).multipliedBy(0.5);
            make.height.centerX.equalTo(self.contactFD);
        }
        make.top.equalTo(self.contentText.mas_bottom).offset(20);
    }];
    
}


@end
