//
//  BaseViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewController.h"
#import "MuBackButton.h"
#import "MBProgressHUD+Add.h"


@interface BaseViewController ()


@end

@implementation BaseViewController

- (instancetype)initWithSkipType:(VCSkipType )skipType{
    if (self = [super init]) {
        self.skipType = skipType;
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self initUI];
    [self bindViewModel];
}


- (void)initUI{}

- (void)bindViewModel{};




- (void)setBackTitle:(NSString *)title{
    _backBtn = ({
           MuBackButton *btn = [[MuBackButton alloc]initWithFrame:CGRectZero];
           btn.titleLB.text  = title;
           btn.titleLB.font = [UIFont systemFontOfSize:IPHONE_DEVICE?20:22];
          [self.view addSubview:btn];
          btn;
    });
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(IPHONE_DEVICE?0:342);
        make.top.equalTo(self.view).offset(IPHONE_DEVICE?(IPHONEX_DEVICE?45:25):40);
        make.width.equalTo(IPHONE_DEVICE?@150:@180);
        make.height.equalTo(IPHONE_DEVICE?@30:@37.5);
    }];
    @weakify(self);
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.skipType == VCSkipTypePresent) {
            [self AnimationDismiss];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end



