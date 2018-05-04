
//  ARHomeViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/21.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ARHomeViewController.h"
#import "ARHomeViewModel.h"
#import "ExhibitInfoModel.h"
#import "ExhibitViewController.h"
#import "HomeFooterView.h"
#import "MLNavigationController.h"
#import "MapGuideViewController.h"
#import "MuseumGuideViewController.h"
#import "MuseumInfoModel.h"
#import "MuseumInfoViewController.h"
#import "NewsViewController.h"
#import "SearchViewController.h"
#import "VerticalButton.h"
#import "iBeaconManager.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "MBProgressHUD+Add.h"
#import "RootViewController.h"
#import "AppDelegate.h"
#import "LaunchingView.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "WelcomeVideoViewController.h"
#import "KudanARViewController.h"
#import "iBeaconModel.h"
#import "RootTarBarController.h"
#import "VerticalButton.h"
#import "UIView+Animation.h"
#import "HorizontalButton.h"
#import "LocalJsonManager.h"


@interface ARHomeViewController ()<KudanARDelegate>

@property (nonatomic,strong)MuseumModel *museum;

@property (nonatomic,strong)UIButton *logoBtn;
@property (nonatomic,strong)UILabel *warningLB;
@property (nonatomic,strong)VerticalButton *exhibitBtn;
//显示多个文字标签使用
@property (nonatomic,strong)NSMutableArray *verExhibitBtns;
@property (nonatomic,strong)NSMutableArray *exhibitids;
//结束
@property (nonatomic,strong)HorizontalButton *enExhibitBtn;
@property (nonatomic,strong)ARHomeViewModel *viewModel;
@property (nonatomic,weak)KudanARViewController *arVC;
@property (nonatomic,strong)HomeFooterView *footerView;
@property (nonatomic,strong)NSString *cur_exhibit_id;
@property (nonatomic,assign)BOOL hideWarning; //手动显示和隐藏警示标签
@property (nonatomic,strong)UIButton *videoBtn;
@property (nonatomic,strong)UIControl *blankControl;
@property (nonatomic,strong)iBeaconManager *ibeaconManager;
@property (nonatomic,strong)UIImageView *enAnmiationView;
@property (nonatomic,strong)UIImageView *titleAnmiationView;
@property (nonatomic,strong)UIImageView *arAnmationView;

@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,strong)NSArray *goodsAry;
@end

@implementation ARHomeViewController

- (instancetype)initWithMuseumInfo:(MuseumModel *)museum{
    if (self = [super init]) {
        self.museum = museum;
    }
    return self;
}


- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    RootTarBarController *tabVC = (RootTarBarController *)self.tabBarController;
    self.arVC = tabVC.arVC;
    [super viewDidLoad];
    [self.logoBtn setImage:[UIImage imageNamed:@"logo_1498016467"] forState:UIControlStateNormal];
//    self.footerView.arCardStyle = self.museum.isCalure;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    [self tapAction:nil];
    self.verExhibitBtns = [[NSMutableArray alloc] init];
    self.exhibitids = [[NSMutableArray alloc] init];
}

- (MBProgressHUD *)hud{
    if (!_hud) {
        _hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.label.text = [TXSakuraManager tx_stringWithPath:@"xlistview_header_hint_loading"];
    }
    return _hud;
}

- (void)tapAction:(UIGestureRecognizer *)gesture{
    if (self.cur_exhibit_id) {
        if ([self.arVC isARVideoWithExhibitID:self.cur_exhibit_id]) {
            [self.arVC hiddenVideo];
        }
        if (![self.ibeaconManager.curBeaconModel.exhibit_id isEqualToString:self.cur_exhibit_id]) {
            self.cur_exhibit_id = nil;
            self.exhibitBtn.verticalTitle = @"";
            self.enExhibitBtn.horizaontalTitle = @"";
        }
    }
    self.footerView.alpha  = self.logoBtn.alpha = 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.f animations:^{
            self.footerView.alpha  = self.logoBtn.alpha = 0;
        }];
    });
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.cur_exhibit_id = nil;
    self.arVC.delegate = self;
}

- (void)setCur_exhibit_id:(NSString *)cur_exhibit_id{
        _cur_exhibit_id = cur_exhibit_id;
        if (!_cur_exhibit_id) {
            self.videoBtn.hidden = self.exhibitBtn.hidden = self.enExhibitBtn.hidden = self.enAnmiationView.hidden = self.arAnmationView.hidden = self.titleAnmiationView.hidden = YES;
        }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.arVC.delegate = nil;
}


#pragma mark bindViewModel
- (void)bindViewModel{
    @weakify(self);
    self.viewModel = [[ARHomeViewModel alloc]initWithHUDShowView:self.view];
    RAC(self.viewModel,basicInfo) = RACObserve(self, museum);
    [self.viewModel.loadInfoCmd.executionSignals.switchToLatest subscribeNext:^(MuseumInfoModel *x) {
        @strongify(self);
         self.footerView.alpha  = self.logoBtn.alpha = 0;
        MuseumInfoViewController *vc = [[MuseumInfoViewController alloc]initWithBasicInfo:self.museum detailInfo:x];
        [[vc rac_signalForSelector:@selector(viewWillAppear:)]subscribeNext:^(id x) {
            @strongify(self);
            self.hideWarning = YES;
            }];
        [[vc rac_signalForSelector:@selector(viewWillDisappear:)]subscribeNext:^(id x) {
            @strongify(self);
            self.hideWarning = NO;
            self.footerView.alpha  = self.logoBtn.alpha = 1;
        }];
        [self presentTransparentAnimationController:vc];
    }];

    //展品信息加载完成后
    [[self.viewModel.exhibitInfoCmd.executionSignals switchToLatest]subscribeNext:^(ExhibitInfoModel *x) {
        @strongify(self);
        if(!x.exhibit_id){return;}
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:x.name,@"label",[Communtil getCurrentDate], @"datetime",nil];
        [FileUtil saveTalkingdata:@"AR.json" conent:[Communtil DataTOjsonString:dic]];
        
        
//        if ([Communtil app_welcome] && IPHONE_DEVICE){return;}
//        [TalkingData trackEvent:self.museum.museum_name?:@"云观博" label:@"扫描的展品" parameters:@{x.name?:@"":x.name?:@""}];
//        [TalkingData trackEvent:@"扫描的展品" label:self.museum.museum_name?:@"云观博" parameters:@{x.name?:@"":x.name?:@""}];
        ExhibitViewController *vc = [ExhibitViewController exhibitControllerWithInfo:x museumInfo:self.museum];
        vc.goodsAry = self.goodsAry;
        [self.navigationController pushViewController:vc animated:NO];
    }];

    //请正对展品是否隐藏
    [self.viewModel.iBeaconCmd.executionSignals.switchToLatest subscribeNext:^(NSArray<iBeaconModel *>* x) {
        @strongify(self);
        [self.ibeaconManager setBeaconModelsAry:x];
    }];
    
    [RACObserve(self.ibeaconManager, curBeaconModel) subscribeNext:^(iBeaconModel *x) {
        @strongify(self);
        if (!x) {
            self.cur_exhibit_id = self.exhibitBtn.verticalTitle = self.enExhibitBtn.horizaontalTitle = nil;
        }else{
            [Communtil playExhitbitSound];
            self.cur_exhibit_id = x.exhibit_id;
            self.exhibitBtn.verticalTitle= x.exhibit_name;
            self.exhibitBtn.hidden = NO;
        }
    }];
    
    [[RACSignal combineLatest:@[RACObserve(self.arVC, hiddenLB),RACObserve(self, cur_exhibit_id),RACObserve(self, hideWarning),RACObserve(self.arVC, playVideo)]]subscribeNext:^(id x) {
        NSNumber *hiddenAR = x[0];
        NSString *cur_id = x[1];
        NSNumber *hiddenW = x[2];
        NSNumber *playVideo = x[3];
        @strongify(self);
        self.warningLB.hidden = [hiddenAR boolValue] || [hiddenW boolValue] || cur_id.length > 0||[playVideo boolValue];
    }];
    
    self.logoBtn.rac_command = self.viewModel.loadInfoCmd;
    
    
    [[[[self.footerView.helpBtn rac_signalForControlEvents:UIControlEventTouchUpInside] autoPlaySound] talkingDataTracking:@"帮助" label:self.museum.museum_name params:nil]subscribeNext:^(id x) {
        @strongify(self);
        [TalkingData trackEvent:self.museum.museum_name label:@"帮助"];
        if (self.arVC.playVideo) {
            [self.arVC hiddenVideo];
        }
        WelcomeVideoViewController *vc = [[WelcomeVideoViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [[[[self.footerView.productBtn rac_signalForControlEvents:UIControlEventTouchUpInside] autoPlaySound] talkingDataTracking:@"搜索" label:self.museum.museum_name params:nil]subscribeNext:^(id x) {
        @strongify(self);
        if (self.arVC.playVideo) {
            [self.arVC hiddenVideo];
        }
        [TalkingData trackEvent:self.museum.museum_name label:@"搜索"];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.museum.museum_name,@"label",[Communtil getCurrentDate], @"datetime",nil];
        [FileUtil saveTalkingdata:@"搜索.json" conent:[Communtil DataTOjsonString:dic]];
        [Communtil playClickSound];
        SearchViewController *vc = [[SearchViewController alloc]initWithMuseumInfo:self.museum searchType:HomeSearch searchResult:nil];
//        vc.goodsAry = self.goodsAry;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [[self.footerView.strategyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.arVC.playVideo) {
            [self.arVC hiddenVideo];
        }
        [Communtil playClickSound];
        MapGuideViewController *vc = [[MapGuideViewController alloc]initWithMuseumInfo:self.museum];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [[[self.footerView.rootBtn rac_signalForControlEvents:UIControlEventTouchUpInside] autoPlaySound]subscribeNext:^(id x) {
         @strongify(self);
        if (self.arVC.playVideo) {
            [self.arVC hiddenVideo];
        }
        [self.ibeaconManager cleanLocation];
        self.hideWarning = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }];


    
    //识别到多个标签的时候
    [[self rac_signalForSelector:@selector(kudanOnTrack:Exhibition_names:hasARVideo:enTitle:) fromProtocol:@protocol(KudanARDelegate)]subscribeNext:^(RACTuple *x) {
        @strongify(self);
        
        NSArray *ids = x[1];
       
        
        if (!self.cur_exhibit_id || ![self.cur_exhibit_id isEqualToString:x[0]]) {
            [Communtil playExhitbitSound];
            self.cur_exhibit_id = x[0];
            self.videoBtn.hidden = ![x[2] boolValue];
            BOOL enTitle = [x[3] boolValue];
            if (!enTitle) {
//                self.exhibitBtn.hidden = NO;
//                self.exhibitBtn.verticalTitle = x[1];
                int i=0;
                for (NSDictionary *tempid in ids){
                    VerticalButton *temp1exhibitBtn = ({
                        VerticalButton *btn = [[VerticalButton alloc]initWithFrame:CGRectZero];
                        btn.verticalTitle = tempid[@"showname"];
                        [self.view addSubview:btn];
                        btn;
                    });
                    [temp1exhibitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        if (ids.count>4) {
                            make.centerX.equalTo(self.view).offset(-300+120*i);
                            make.centerY.equalTo(self.view).offset(-60);
                            make.width.equalTo(@40);
                        }
                        else if (ids.count == 2)
                        {
                            make.centerX.equalTo(self.view).offset(-150+400*i);
                            make.centerY.equalTo(self.view).offset(-60);
                            make.width.equalTo(@40);
                        }
                        else if(ids.count == 4)
                        {
                            make.centerX.equalTo(self.view).offset(-300+200*i);
                            make.centerY.equalTo(self.view).offset(-60);
                            make.width.equalTo(@40);
                        }
                        else{
                            make.centerX.equalTo(self.view).offset(-200+230*i);
                            make.centerY.equalTo(self.view).offset(-60);
                            make.width.equalTo(@40);
                        }
                    }];
                    [[temp1exhibitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                        @strongify(self);
                        if (tempid[@"id"]) {
                            [Communtil playClickSound];
                            NSLog(@"tempid %@",[tempid objectForKey:@"id"]);
                            [self.viewModel.exhibitInfoCmd execute:[tempid objectForKey:@"id"]?:@""];
                        }
                    }];
                    [self.verExhibitBtns addObject:temp1exhibitBtn];
                    [self.exhibitids addObject:tempid[@"id"]];
                    i++;
                }
                
                
            }else{
                self.enExhibitBtn.hidden = NO;
                self.enExhibitBtn.horizaontalTitle = x[1];
            }
            [self beginAnmiation];
//            if (self.cur_exhibit_id&&![x[2] boolValue]) {
//                [self.viewModel.exhibitInfoCmd execute:self.cur_exhibit_id?:@""];
//            }
        }
    }];
    
    
    
    
    [[self rac_signalForSelector:@selector(kudanOnTrack:Exhibition_name:hasARVideo:enTitle:) fromProtocol:@protocol(KudanARDelegate)]subscribeNext:^(RACTuple *x) {
        @strongify(self);
        if (!self.cur_exhibit_id || ![self.cur_exhibit_id isEqualToString:x[0]]) {
            [Communtil playExhitbitSound];
            self.cur_exhibit_id = x[0];
            self.videoBtn.hidden = ![x[2] boolValue];
            BOOL enTitle = [x[3] boolValue];
            if (!enTitle) {
                 self.exhibitBtn.hidden = NO;
                 self.exhibitBtn.verticalTitle = x[1];
                
            }else{
                self.enExhibitBtn.hidden = NO;
                self.enExhibitBtn.horizaontalTitle = x[1];
            }
             [self beginAnmiation];
            if (self.cur_exhibit_id&&![x[2] boolValue]) {
                [self.viewModel.exhibitInfoCmd execute:self.cur_exhibit_id?:@""];
            }
        }
    }];
    [[self rac_signalForSelector:@selector(kudanLostTrack) fromProtocol:@protocol(KudanARDelegate)]subscribeNext:^(id x) {
        @strongify(self);
        self.cur_exhibit_id = nil;
        self.exhibitBtn.verticalTitle = self.enExhibitBtn.horizaontalTitle = @"";
        self.enExhibitBtn.hidden = self.videoBtn.hidden = self.exhibitBtn.hidden = self.enAnmiationView.hidden =  self.titleAnmiationView.hidden = self.arAnmationView.hidden = YES;
        
        
        if (self.verExhibitBtns && self.verExhibitBtns.count>0) {
            for (VerticalButton *tempButton in self.verExhibitBtns) {
                tempButton.hidden = YES;
                tempButton.verticalTitle = @"";
                [tempButton removeFromSuperview];
            }
        }
        [self.verExhibitBtns removeAllObjects];
        [self.exhibitids removeAllObjects];
        
    }];
    [[self rac_signalForSelector:@selector(kudanFinishedVideo) fromProtocol:@protocol(KudanARDelegate)]subscribeNext:^(id x) {
        @strongify(self);
        self.videoBtn.hidden = NO;
        if (self.exhibitBtn.hidden) {
            self.exhibitBtn.hidden = NO;
        }
        if (self.enExhibitBtn.hidden) {
            self.enExhibitBtn.hidden = NO;
        }
        if (self.verExhibitBtns && self.verExhibitBtns.count>0) {
            for (VerticalButton *tempButton in _verExhibitBtns) {
                if (tempButton.hidden) {
                    tempButton.hidden = NO;
                }
            }
        }
    }];
    [[self.videoBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.cur_exhibit_id) {
            [self.arVC showARVideo:self.cur_exhibit_id];
            self.videoBtn.hidden = self.exhibitBtn.hidden = self.enExhibitBtn.hidden = self.enAnmiationView.hidden =self.arAnmationView.hidden = self.titleAnmiationView.hidden =  YES;
            if (self.verExhibitBtns && self.verExhibitBtns.count>0) {
                for (VerticalButton *tempButton in _verExhibitBtns) {
                    tempButton.hidden = YES;
                }
            }
        }
    }];
    
    [[self.exhibitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.cur_exhibit_id) {
            [Communtil playClickSound];
            [self.viewModel.exhibitInfoCmd execute:self.cur_exhibit_id?:@""];
        }
    }];
    [[self.enExhibitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.cur_exhibit_id) {
            [Communtil playClickSound];
            [self.viewModel.exhibitInfoCmd execute:self.cur_exhibit_id?:@""];
        }
    }];
//    [self.viewModel.loadGoodsCmd.executionSignals.switchToLatest subscribeNext:^(NSArray *x) {
//        @strongify(self);
//        self.goodsAry = x;
//    }];
//    [self.viewModel.loadGoodsCmd execute:self.museum.museum_id];
//    [self.viewModel.iBeaconCmd execute:nil];
}




#pragma mark initUI
- (void)initUI{
    _exhibitBtn = ({
        VerticalButton *btn = [[VerticalButton alloc]initWithFrame:CGRectZero];
        [self.view addSubview:btn];
        btn;
    });
    _enExhibitBtn = ({
        HorizontalButton *btn = [[HorizontalButton alloc]initWithFrame:CGRectZero];
        [self.view addSubview:btn];
        btn;
    });
    
    _enAnmiationView = ({
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = [UIImage imageNamed:@"dianji"];
        imgView.hidden = YES;
        [self.view addSubview:imgView];
        imgView;
    });
    
    _titleAnmiationView = ({
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = [UIImage imageNamed:@"dianji"];
        imgView.hidden = YES;
        [self.view addSubview:imgView];
        imgView;
    });
    
    _arAnmationView = ({
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imgView.image = [UIImage imageNamed:@"dianji"];
        imgView.hidden = YES;
        [self.view addSubview:imgView];
        imgView;
    });
    _videoBtn = ({
        UIButton *videoBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [videoBtn setBackgroundImage:[UIImage imageNamed:@"i"] forState:UIControlStateNormal];
        videoBtn.hidden = YES;
        [self.view addSubview:videoBtn];
        videoBtn;
    });
    
    _footerView = ({
        HomeFooterView *footer = [[HomeFooterView alloc]initWithFrame:CGRectZero];
        footer.backgroundColor = HexRGBAlpha(0x000000, 0.7);
        [self.view addSubview:footer];
        footer;
    });
    _warningLB = ({
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectZero];
        lb.sakura.text(@"please_scan_on");
        BOOL en = [[[NSUserDefaults standardUserDefaults]objectForKey:kLOCALIZABLE] isEqualToString:@"en"];
        lb.font = [UIFont systemFontOfSize:IPHONE_DEVICE?(en?18:21):25];
        lb.textColor = [UIColor whiteColor];
        lb.hidden = YES;
        [self.view addSubview:lb];
        lb;
    });
    _logoBtn = ({
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.view addSubview:btn];
        btn;
    });
    [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(IPHONE_DEVICE?@40:@60);
        make.centerY.equalTo(self.view);
        make.right.equalTo(self.view).offset(-60);
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(IPHONE_DEVICE?(IPHONEX_DEVICE?@81:@49):@55);
    }];
    [self.warningLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [self.exhibitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(50);
        make.centerY.equalTo(self.view).offset(-60);
        make.width.equalTo(@40);
    }];
    [self.enAnmiationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.enExhibitBtn.mas_bottom);
        make.centerX.equalTo(self.enExhibitBtn).offset(-12);
        make.width.height.equalTo(@30);
    }];
    [self.titleAnmiationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.exhibitBtn.mas_right).offset(12);
        make.centerY.equalTo(self.exhibitBtn);
        make.width.height.equalTo(@30);
    }];
    [self.arAnmationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoBtn.mas_right).offset(16);
        make.top.equalTo(self.videoBtn.mas_bottom).offset(4);
        make.width.height.equalTo(@30);
    }];
    
    [self.enExhibitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-100);
        make.height.equalTo(@80);
    }];
    [self.logoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IPHONE_DEVICE) {
            make.top.equalTo(IPHONEX_DEVICE?@45:@25);
            make.left.equalTo(@25);
        }else{
            make.left.equalTo(self.view).offset(43);
            make.top.equalTo(self.view).offset(26);
        }
        make.width.equalTo(IPHONE_DEVICE?@140:@215);
        make.height.equalTo(self.logoBtn.mas_width).multipliedBy(11.0/46.0);
    }];
}

- (void)kudanConfigStart{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud showAnimated:YES];
    });
}

- (void)kudanConfigEnd{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud hideAnimated:YES];
        self.view.backgroundColor = [UIColor clearColor];
        self.hud = nil;
//        self.warningLB.text = @"加载完毕";
    });
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return IPHONE_DEVICE? UIInterfaceOrientationMaskPortrait:UIInterfaceOrientationMaskLandscapeRight;
}


//- (iBeaconManager *)ibeaconManager{
//    if (!_ibeaconManager) {
//        _ibeaconManager = [[iBeaconManager alloc]init];
//    }
//    return _ibeaconManager;
//}


- (void)beginAnmiation{ //创建动画
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kSHOWANMIATION]) {
        return;
    }

    
    if (self.exhibitBtn.hidden == NO&&self.cur_exhibit_id && (self.videoBtn.hidden == NO)) {
        self.titleAnmiationView.hidden = NO;
        [self shakeAnmiation:self.titleAnmiationView];
    }else if (self.enExhibitBtn.hidden == NO&&self.cur_exhibit_id && (self.videoBtn.hidden == NO)){
        self.enAnmiationView.hidden = NO;
        [self shakeAnmiation:self.enAnmiationView];
    }else{
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.titleAnmiationView.hidden = YES;
        self.enAnmiationView.hidden = YES;
        if (self.cur_exhibit_id && (self.videoBtn.hidden == NO)) {
            self.arAnmationView.hidden = NO;
            [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:kSHOWANMIATION];
            [self shakeAnmiation:self.arAnmationView];
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.arAnmationView.hidden = YES;
    });

}

- (void)shakeAnmiation:(UIView *)view{
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation]; keyAnimaion.keyPath = @"position";
    //度数转弧度
    CGPoint enP = CGPointMake(view.center.x - 10,view.center.y - 10);
    CGPoint startP = CGPointMake(view.center.x - 10,view.center.y - 10);
    keyAnimaion.values = @[[NSValue valueWithCGPoint:enP],[NSValue valueWithCGPoint:view.center],[NSValue valueWithCGPoint:startP]];
    keyAnimaion.removedOnCompletion = YES;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.8;
    keyAnimaion.repeatCount = 3;
    [view.layer addAnimation:keyAnimaion forKey:nil];
}





@end
