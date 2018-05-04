//
//  LoginViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "LoginViewController.h"
#import "MuItemButton.h"
#import "LoginField.h"
#import "ThirdPlatformLoginView.h"
#import <UMSocialCore/UMSocialManager.h>
#import <UMSocialCore/UMSocialResponse.h>
#import "LoginViewModel.h"
#import "LoginProtocolView.h"
#import "SystemGuideViewController.h"
#import "UserInfoModel.h"
#import "WebViewController.h"
#import "UIImage+Developer.h"
#import "MBProgressHUD+Add.h"
#import <WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface LoginViewController ()
@property (nonatomic,strong)LoginField *userNameFD;
@property (nonatomic,strong)LoginField *codeFD;
@property (nonatomic,strong)LoginProtocolView *protocolView;
@property (nonatomic,strong)UIButton *loginBtn;
@property (nonatomic,strong)ThirdPlatformLoginView *loginView;
@property (nonatomic,strong)LoginViewModel *viewModel;
@property (nonatomic,strong)NSString *messageID;
@property (nonatomic,copy)void(^loginSuccess)();
@end

@implementation LoginViewController

+ (LoginViewController *)loginControllerWithLoginSuccess:(void(^)())loginSuccess{
    LoginViewController *vc = [[LoginViewController alloc]init];
    vc.loginSuccess = loginSuccess;
    return vc;
}


- (void)bindViewModel{
    if (![WXApi isWXAppInstalled]) {
        self.loginView.WeChatBtn.hidden = YES;
    }
    if (![TencentOAuth iphoneQQInstalled]) {
        self.loginView.QQLoginBtn.hidden = YES;
    }
    @weakify(self);
    LoginViewModel *viewModel = [[LoginViewModel alloc]initWithHUDShowView:self.view];
    self.userNameFD.codeBtn.rac_command = viewModel.sendCmd;
    RAC(viewModel,phoneNumber) = self.userNameFD.textFD.rac_textSignal;
    RAC(viewModel,authCode) = self.codeFD.textFD.rac_textSignal;
    RAC(viewModel,message_id) = RACObserve(self, messageID);
    RAC(self.userNameFD.codeBtn,isRunning) = RACObserve(viewModel, codeRunning);
    RAC(self.loginBtn,enabled) = viewModel.verificationLogin;
    RAC(viewModel,protocolEnable) = RACObserve(self.protocolView.chcekBox, selected);
    [viewModel.verificationLogin subscribeNext:^(NSNumber *x) {
        @strongify(self);
        self.loginBtn.layer.borderColor = [x boolValue]?[UIColor whiteColor].CGColor:HexRGB(0x999999).CGColor;
    }];
    [[viewModel.loginCmd.executionSignals switchToLatest]subscribeNext:^(id x) {
        //登录成功
        @strongify(self);
        if (self.loginSuccess) {
            self.loginSuccess();
        }
        [MBProgressHUD showMessag:[TXSakuraManager tx_stringWithPath:@"login_su"] toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:NO];
        });
    }];
    //验证码发送成功
    [[viewModel.sendCmd.executionSignals switchToLatest]subscribeNext:^(NSString *x) {
         @strongify(self);
         [self.userNameFD.codeBtn startUpTimer];
         self.messageID= x;
    }];
    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] talkingDataTracking:@"手机号登录" label:self.museum.museum_name params:nil] subscribeNext:^(id x) {
        @strongify(self);
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[Communtil getCurrentDate], @"datetime",nil];
        [FileUtil saveTalkingdata:@"手机号登录.json" conent:[Communtil DataTOjsonString:dic]];
        
        [viewModel.loginCmd execute:@{@"type":@"phone",@"loginid":self.userNameFD.textFD.text?:@"",@"dynamiccode":self.codeFD.textFD.text?:@"",@"messageid":self.messageID?:@""}];
    }];
    self.viewModel = viewModel;
    
    [[RACSignal merge:@[[self.loginView.QQLoginBtn rac_signalForControlEvents:UIControlEventTouchUpInside],[self.loginView.WeChatBtn rac_signalForControlEvents:UIControlEventTouchUpInside],[self.loginView.SinaBtn rac_signalForControlEvents:UIControlEventTouchUpInside]]]subscribeNext:^(UIButton *x) {
        @strongify(self);
        [TalkingData trackEvent:self.museum.museum_name?:@"云观博" label:[self platformTypeCNString:x.tag]];
        [TalkingData trackEvent:[self platformTypeCNString:x.tag] label:self.museum.museum_name?:@"云观博"];
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:x.tag currentViewController:self completion:^(id result, NSError *error) {
            @strongify(self);
            UMSocialUserInfoResponse *resp = result;
            // 第三方登录数据(为空表示平台未提供)
            if (resp.openid || resp.accessToken) {
                NSDictionary *param = @{@"type":[self platformTypeString:x.tag],@"loginid":[NSString stringWithFormat:@"%@,%@",(x.tag == UMSocialPlatformType_Sina )?resp.uid:resp.openid,resp.accessToken],@"messageid":@"",@"dynamiccode":@""};
                [self.viewModel.loginCmd execute:param];
            }
        }];
    }];
    
    [[self.protocolView.chcekBox rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
        x.selected = !x.selected;
    }];
    //跳转到协议界面
    [[self.protocolView.protocolBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        WebViewController *vc = [WebViewController webControllerWithUrl:@"https://museum.morview.com/content/server/info.html"];
        vc.backBtn.backImg.image = [[UIImage imageNamed:@"menu_back"] imageWithColor:[UIColor blackColor]];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}




- (NSString *)platformTypeCNString:(UMSocialPlatformType)platformType{
    NSString *type;
    switch (platformType) {
        case UMSocialPlatformType_QQ:
            type = @"QQ登录";
            break;
        case UMSocialPlatformType_WechatSession:
            type = @"微信登录";
            break;
        case UMSocialPlatformType_Sina:
            type = @"新浪登录";
            break;
        default:
            break;
    }
    return type;
}


- (NSString *)platformTypeString:(UMSocialPlatformType)platformType{
    NSString *type;
    switch (platformType) {
        case UMSocialPlatformType_QQ:
            type = @"qq";
            break;
        case UMSocialPlatformType_WechatSession:
            type = @"wx";
            break;
        case UMSocialPlatformType_Sina:
            type = @"weibo";
            break;
        default:
            break;
    }
    return type;
}

- (void)initUI{
    self.view.backgroundColor = HexRGB(0x202126);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [self.view addGestureRecognizer:tap];
    @weakify(self);
    [[tap rac_gestureSignal]subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
    [self setBackTitle:[TXSakuraManager tx_stringWithPath:@"fastlogin"]];
    _loginBtn = ({
        UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateFocused];
        [loginBtn setTitleColor:HexRGB(0x999999) forState:UIControlStateDisabled];
        loginBtn.layer.borderColor = HexRGB(0x999999).CGColor;
        loginBtn.layer.borderWidth = 1.f;
        loginBtn.layer.cornerRadius = IPHONE_DEVICE?12.f:24.f;
        loginBtn.layer.masksToBounds = YES;
        loginBtn.layer.borderWidth = 1.;
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:IPHONE_DEVICE?17:20];
        [loginBtn setTitle:[TXSakuraManager tx_stringWithPath:@"login"] forState:UIControlStateNormal];
        [self.view addSubview:loginBtn];
        loginBtn;
    });
    
    _userNameFD = ({
        LoginField *userNameFD = [[LoginField alloc]initWithFrame:CGRectZero FieldType:FieldTypeUserName];
        NSMutableAttributedString *attrUser = [[NSMutableAttributedString alloc]initWithString:[TXSakuraManager tx_stringWithPath:@"phonewrite"] attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        userNameFD.textFD.attributedPlaceholder = attrUser;
        [self.view addSubview:userNameFD];
        userNameFD;
    });
    _codeFD = ({
        LoginField *codeFD = [[LoginField alloc]initWithFrame:CGRectZero FieldType:FieldTypeCode];
        NSMutableAttributedString *attrCode = [[NSMutableAttributedString alloc]initWithString:[TXSakuraManager tx_stringWithPath:@"pleasecode"] attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        codeFD.textFD.attributedPlaceholder = attrCode;
        [self.view addSubview:codeFD];
        codeFD;
    });
    _loginView = ({
        ThirdPlatformLoginView *thirdLoginView = [[ThirdPlatformLoginView alloc]initWithFrame:CGRectZero];
        thirdLoginView.titleLB.sakura.text(@"other_login");
        [self.view addSubview:thirdLoginView];
        thirdLoginView;
    });
    _protocolView = ({
        LoginProtocolView *protocol = [[LoginProtocolView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:protocol];
        protocol;
    });
    IPHONE_DEVICE?[self layoutiPhone]:[self layoutPad];
}

- (void)layoutiPhone{
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_centerY).offset(-60);
        make.left.equalTo(self.view).offset(60);
        make.right.equalTo(self.view).offset(-60);
        make.height.equalTo(@40);
    }];
    [self.codeFD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.loginBtn);
        make.bottom.equalTo(self.loginBtn.mas_top).offset(-40);
        make.height.equalTo(@30);
    }];
    [self.userNameFD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.codeFD);
        make.bottom.equalTo(self.codeFD.mas_top).offset(-16);
    }];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_centerY).offset(30);
        make.height.equalTo(@110);
    }];
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@220);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(20);
        make.height.equalTo(@20);
    }];
}

- (void)layoutPad{
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(42);
        make.top.equalTo(self.view).offset(40);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).multipliedBy(378.0/1024.0);
        make.height.equalTo(self.loginBtn.mas_width).multipliedBy(61.0/378.0);
    }];
    [self.codeFD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loginBtn.mas_top).offset(-60);
        make.height.equalTo(@45);
        make.width.equalTo(self.view).multipliedBy(504.0/1025.0);
        make.centerX.equalTo(self.view);
    }];
    [self.userNameFD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.codeFD);
        make.bottom.equalTo(self.codeFD.mas_top).offset(-20);
    }];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.height.equalTo(@130);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).multipliedBy(520.0/1024.0);
    }];
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@220);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(20);
        make.height.equalTo(@20);
    }];
}




@end
