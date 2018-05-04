//
//  HomeAdsViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/19.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "HomeAdsViewController.h"

@interface HomeAdsViewController ()
@property (nonatomic,strong)UIImageView *adsImgView;
@property (nonatomic,strong)UIButton *closeBtn;


@property (nonatomic,copy)NSString *adsImgURL;
@end

@implementation HomeAdsViewController


- (instancetype)initWithAdsImgUrl:(NSString *)adsimgUrl{
    if (self = [super init]) {
        self.adsImgURL = adsimgUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.adsImgView sd_setImageWithURL:[NSURL URLWithString:self.adsImgURL]];
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]init];
    [tapG.rac_gestureSignal subscribeNext:^(id x) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.adsURL]];
    }];
    [self.view addGestureRecognizer:tapG];
    @weakify(self);
    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:NO];
    }];
}


- (void)initUI{
    _adsImgView = ({
        UIImageView *imgView =[[UIImageView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:imgView];
        imgView;
    });
    
    _closeBtn = ({
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        [btn setTitle:@"close" forState:UIControlStateNormal];
        [self.view addSubview:btn];
        btn;
    });
    
    [self.adsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.view).offset(20);
        make.width.height.equalTo(@44);
    }];
    
    
    
}

@end
