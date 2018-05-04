//
//  PayViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/8/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "PayViewController.h"
#import "PayMainView.h"
#import "YYText.h"
#import "PayViewModel.h"
#import "MBProgressHUD+Add.h"
#import <WXApi.h>
#import "MuseumModel.h"
#import "TalkingData.h"
#import "ApiFactory+Pay.h"

@interface PayViewController ()<IapDelegate>
@property (nonatomic,strong)PayMainView *payMainView;
@property (nonatomic,strong)UIControl *blankControl;
@property (nonatomic,strong)PayViewModel *payViewModel;

@end

@implementation PayViewController

- (instancetype)initWithMuseum:(MuseumModel *)museum{
    if (self = [super init]) {
        self.museum = museum;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"bg.jpg"].CGImage);
    
}

- (void)initUI{
    _blankControl = ({
        UIControl *control = [[UIControl alloc]initWithFrame:CGRectZero];
        [self.view addSubview:control];
        control;
    });
    _payMainView = ({
        PayMainView *mainView = [[PayMainView alloc]initWithFrame:CGRectZero reviewsMode:NO];
        mainView.backgroundColor = HexRGBAlpha(0xF5F5F5, 1);
        [self.view addSubview:mainView];
        mainView;
    });
    [self.blankControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (IPAD_DEVICE) {
        [self.payMainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(100);
            make.centerX.equalTo(self.view);
            make.width.equalTo(@300);
            make.height.equalTo(self.payMainView.mas_width).multipliedBy(331.0/317.0);
        }];
    }else{
        [self.payMainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(48);
            make.right.equalTo(self.view).offset(-48);
            make.top.equalTo(self.view).offset(78);
            make.height.equalTo(self.payMainView.mas_width).multipliedBy(331.0/317.0);
        }];
    }
    @weakify(self);
    [[self.blankControl rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)bindsViewModel{
    @weakify(self);
    self.payViewModel = [[PayViewModel alloc]initWithHUDShowView:self.view];
    self.payViewModel.delegate = self;
    [[RACObserve(self.payViewModel, showHUD) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        if ([x boolValue]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        }
    }];
    [[RACObserve(self.payViewModel, errorMsg) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD showError:x toView:self.view];
    }];
    
    NSArray *payments = [[self.museum.payment.rac_sequence filter:^BOOL(MuseumPayment *value) {
        return [value.payment isEqualToString:@"iap"];
    }] array];
    if (payments.count > 0) {
        MuseumPayment *payment = [payments firstObject];
        self.payViewModel.product_id = payment.pay_id;
    }else{
        [MBProgressHUD showError:@"购买异常" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
    [[self.payMainView.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
    [[self.payMainView.payView.appleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (![Communtil isLogin]) {
            [self dismissViewControllerAnimated:NO completion:^{
                if (self.loginBlock) {
                    self.loginBlock();
                }
            }];
        }else{
            [self.payViewModel.iapCmd execute:nil];
        }
    }];
    
    [self.payViewModel.tokenCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self dismissViewControllerAnimated:NO completion:self.completeBlock];
    }];
    [[[self rac_signalForSelector:@selector(completeTransaction:) fromProtocol:@protocol(IapDelegate)] merge:[self rac_signalForSelector:@selector(restoreTransaction:) fromProtocol:@protocol(IapDelegate)]]subscribeNext:^(id x) {
        @strongify(self);
        [self.payViewModel.tokenCmd execute:nil];
    }];
    
    [[self rac_signalForSelector:@selector(failedTransaction:) fromProtocol:@protocol(IapDelegate)]subscribeNext:^(id x) {
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD showSuccess:@"支付失败" toView:self.view];
        });
    }];
//    
//    [[self rac_signalForSelector:@selector(viewDidLoad)]subscribeNext:^(id x) {
//        @strongify(self);
//        [self autoPay];
//    }];
//    
    
    NSDictionary *params = [[NSUserDefaults standardUserDefaults]objectForKey:kIAPLOCALSTORE];
    if (params) {
        [[ApiFactory pay_verifyIap:params]subscribeNext:^(id x) {
            @strongify(self);
            if ([x[@"status"] isEqualToString:@"success"]) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:kIAPLOCALSTORE];
                [self.payViewModel.tokenCmd execute:nil];
            }
        } error:nil];
    }
    
}

- (void)dealloc{

}




@end
