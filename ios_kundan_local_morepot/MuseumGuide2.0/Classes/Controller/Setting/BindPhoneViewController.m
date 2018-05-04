//
//  BindPhoneViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/6.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "BindPhoneManView.h"
#import "BindPhoneViewModel.h"
#import "MBProgressHUD+Add.h"

@interface BindPhoneViewController ()
@property (nonatomic,strong)BindPhoneManView *mainView;
@property (nonatomic,strong)NSString *msgtitle;
@property (nonatomic,strong)NSString *msg_id;
@property (nonatomic,strong)NSNumber *type;
//手机号验证成功后执行
@property (nonatomic,copy)void(^nextBlock)(NSString *);
@property (nonatomic,strong)BindPhoneViewModel *viewModel;
@end

@implementation BindPhoneViewController

+ (BindPhoneViewController *)VerificationNextAction:(void(^)(NSString *))nextBlock type:(NSNumber *)type{
    BindPhoneViewController *vc = [[BindPhoneViewController alloc]init];
    vc.nextBlock = nextBlock;
    vc.type = type;
    vc.msgtitle = [TXSakuraManager tx_stringWithPath:[type boolValue]?@"rebindmobile":@"bindmobile"];
    return vc;
}

- (void)bindViewModel{
    BindPhoneViewModel *viewModel = [[BindPhoneViewModel alloc]initWithHUDShowView:self.view];
    RAC(viewModel,type) = RACObserve(self, type);
    @weakify(self);
    self.mainView.sendBtn.rac_command = viewModel.sendCmd;
    RAC(viewModel,phoneNumber) = self.mainView.phoneFD.rac_textSignal;
    RAC(viewModel,authCode) = self.mainView.codeFD.rac_textSignal;
    RAC(viewModel,message_id) = RACObserve(self, msg_id);
    RAC(self.mainView.sendBtn,isRunning) = RACObserve(viewModel, codeRunning);
    self.mainView.doneBtn.rac_command = viewModel.bindPhoneCmd;
    //验证码发送成功
    [[viewModel.sendCmd.executionSignals switchToLatest]subscribeNext:^(NSString *x) {
        @strongify(self);
        [self.mainView.sendBtn startUpTimer];
        self.msg_id = x;
    }];
    [viewModel.bindPhoneCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        if (self.nextBlock) {
            self.nextBlock(x);
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [[self.mainView.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    self.viewModel = viewModel;
}

- (void)initUI{
    _mainView = ({
        BindPhoneManView *view = [[BindPhoneManView alloc]init];
        [self.view addSubview:view];
        view;
    });
    self.mainView.titleLB.text = self.msgtitle;
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(IPHONE_DEVICE?@190:@200);
        if (IPHONE_DEVICE) {
            make.left.equalTo(self.view).offset(50);
            make.right.equalTo(self.view).offset(-50);
        }else{
            make.width.equalTo(@300);
            make.centerX.equalTo(self.view);
        }
        make.centerY.equalTo(self.view);
    }];
}






@end
