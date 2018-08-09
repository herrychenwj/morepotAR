
//  ARHomeViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/21.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ARHomeViewController.h"
#import "MuseumInfoViewController.h"
#import "ExhibitViewController.h"
#import "MapGuideViewController.h"
#import "MuseumGuideViewController.h"
#import "SearchViewController.h"
#import "WelcomeVideoViewController.h"
#import "KudanARViewController.h"
#import "RootTarBarController.h"
#import "UIImage+Developer.h"
#import "MuseumInfoModel.h"
#import "ARHomeViewModel.h"
#import "ExhibitInfoModel.h"

#import "AppDelegate.h"
#import "ARHomeView.h"
#import "LocalJsonManager.h"
#import "MBProgressHUD+Add.h"

@interface ARHomeViewController ()<KudanARDelegate>

@property (nonatomic,strong)MuseumModel *museum;

@property (nonatomic,strong)ARHomeView *mainView;

//显示多个文字标签使用
@property (nonatomic,strong)NSMutableArray *verExhibitBtns;
@property (nonatomic,strong)NSMutableArray *exhibitids;
//结束
@property (nonatomic,strong)ARHomeViewModel *viewModel;
@property (nonatomic,weak)KudanARViewController *arVC;
@property (nonatomic,strong)NSString *cur_exhibit_id;
@property (nonatomic,assign)BOOL hideWarning; //手动显示和隐藏警示标签
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,strong)UIImage *shareImg;

@end

static BOOL is_loading = NO;
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
    [self.mainView.logoBtn setImage:[UIImage imageNamed:@"gshz"] forState:UIControlStateNormal];
    [self.mainView.logoBtn setImage:[UIImage imageNamed:@"gshz"] forState:UIControlStateHighlighted];
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
    if (self.arVC.playVideo) {return;}
    [self.mainView tapAnmiationhide];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.cur_exhibit_id = nil;
    self.arVC.delegate = self;
}

- (void)setCur_exhibit_id:(NSString *)cur_exhibit_id{
        _cur_exhibit_id = cur_exhibit_id;
        if (!_cur_exhibit_id) {
            [self.mainView hideAllElement];
            if (self.verExhibitBtns && self.verExhibitBtns.count>0) {
                [self.verExhibitBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    VerticalButton *tempButton = self.verExhibitBtns[idx];
                    tempButton.hidden = YES;
                    tempButton.verticalTitle = @"";
                    [tempButton removeFromSuperview];
                    tempButton = nil;
                }];
            }
            [self.verExhibitBtns removeAllObjects];
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
    [RACObserve(self.arVC, takePhoto) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if ([x boolValue]) {
            self.mainView.takePhotoBtn.hidden = NO;
            [self.mainView hideLogoAndFoot];
        }else{
            self.mainView.takePhotoBtn.hidden = YES;
        }
    }];
    [self.viewModel.loadInfoCmd.executionSignals.switchToLatest subscribeNext:^(MuseumInfoModel *x) {
        @strongify(self);
        MuseumInfoViewController *vc = [[MuseumInfoViewController alloc]initWithBasicInfo:self.museum detailInfo:x];
        [[vc rac_signalForSelector:@selector(viewWillAppear:)]subscribeNext:^(id x) {
            @strongify(self);
            self.hideWarning = YES;
            }];
        [[vc rac_signalForSelector:@selector(viewWillDisappear:)]subscribeNext:^(id x) {
            @strongify(self);
            self.hideWarning = NO;
            [self.mainView showLogoAndFoot];
        }];
        [self presentTransparentAnimationController:vc];
    }];

    //展品信息加载完成后
    [[self.viewModel.exhibitInfoCmd.executionSignals switchToLatest]subscribeNext:^(ExhibitInfoModel *x) {
        @strongify(self);
        if(!x.exhibit_id){return;}
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:x.name,@"label",[Communtil getCurrentDate], @"datetime",nil];
        [FileUtil saveTalkingdata:@"AR.json" conent:[Communtil DataTOjsonString:dic]];
        ExhibitViewController *vc = [ExhibitViewController exhibitControllerWithInfo:x museumInfo:self.museum];
        [self.navigationController pushViewController:vc animated:NO];
    }];


    
    [[RACSignal combineLatest:@[RACObserve(self.arVC, hiddenLB),RACObserve(self, cur_exhibit_id),RACObserve(self, hideWarning),RACObserve(self.arVC, playVideo)]]subscribeNext:^(id x) {
        NSNumber *hiddenAR = x[0];
        NSString *cur_id = x[1];
        NSNumber *hiddenW = x[2];
        NSNumber *playVideo = x[3];
        @strongify(self);
        self.mainView.warningLB.hidden = [hiddenAR boolValue] || [hiddenW boolValue] || cur_id.length > 0||[playVideo boolValue];
    }];
    
    self.mainView.logoBtn.rac_command = self.viewModel.loadInfoCmd;
    
    
    [[[self.mainView.footerView.helpBtn rac_signalForControlEvents:UIControlEventTouchUpInside] autoPlaySound] subscribeNext:^(id x) {
        @strongify(self);
        if (self.arVC.playVideo) {
            [self.arVC hiddenVideo];
        }
        WelcomeVideoViewController *vc = [[WelcomeVideoViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [[[self.mainView.footerView.productBtn rac_signalForControlEvents:UIControlEventTouchUpInside] autoPlaySound]  subscribeNext:^(id x) {
        @strongify(self);
        if (self.arVC.playVideo) {
            [self.arVC hiddenVideo];
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.museum.museum_name,@"label",[Communtil getCurrentDate], @"datetime",nil];
        [FileUtil saveTalkingdata:@"搜索.json" conent:[Communtil DataTOjsonString:dic]];
        [Communtil playClickSound];
        SearchViewController *vc = [[SearchViewController alloc]initWithMuseumInfo:self.museum searchType:HomeSearch searchResult:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [[self.mainView.footerView.strategyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.arVC.playVideo) {
            [self.arVC hiddenVideo];
        }
        [Communtil playClickSound];
        MapGuideViewController *vc = [[MapGuideViewController alloc]initWithMuseumInfo:self.museum];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [[[self.mainView.footerView.rootBtn rac_signalForControlEvents:UIControlEventTouchUpInside] autoPlaySound]subscribeNext:^(id x) {
         @strongify(self);
        if (self.arVC.playVideo) {
            [self.arVC hiddenVideo];
        }
        self.hideWarning = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //识别到多个标签的时候
    [[self rac_signalForSelector:@selector(kudanOnTrack:Exhibition_names:hasARVideo:enTitle:) fromProtocol:@protocol(KudanARDelegate)]subscribeNext:^(RACTuple *x) {
        @strongify(self);
        NSArray *ids = x[1];
        if (is_loading) {return;}
        is_loading = YES;
        if (!self.cur_exhibit_id) {
            [Communtil playExhitbitSound];
            self.cur_exhibit_id = x[0];
            BOOL enTitle = [x[3] boolValue];
            [self.mainView showExhibitName:x[1] en:enTitle];
            int i=0;
            for (NSDictionary *tempid in ids){
                VerticalButton *temp1exhibitBtn = ({
                    VerticalButton *btn = [[VerticalButton alloc]initWithFrame:CGRectZero];
                    btn.verticalTitle = tempid[@"showname"];
                    [self.mainView addSubview:btn];
                    btn;
                });
                [temp1exhibitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (ids.count>4) {
                        make.centerX.equalTo(self.mainView).offset(-300+120*i);
                        make.centerY.equalTo(self.mainView).offset(-60);
                        make.width.equalTo(@40);
                    }
                    else if (ids.count == 2)
                    {
                        make.centerX.equalTo(self.mainView).offset(-150+400*i);
                        make.centerY.equalTo(self.mainView).offset(-60);
                        make.width.equalTo(@40);
                    }
                    else if(ids.count == 4)
                    {
                        make.centerX.equalTo(self.mainView).offset(-300+200*i);
                        make.centerY.equalTo(self.mainView).offset(-60);
                        make.width.equalTo(@40);
                    }
                    else{
                        make.centerX.equalTo(self.mainView).offset(-200+230*i);
                        make.centerY.equalTo(self.mainView).offset(-60);
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
        }
        is_loading = NO;
    }];
    
    
    [[self rac_signalForSelector:@selector(kudanOnTrack:Exhibition_name:hasARVideo:enTitle:) fromProtocol:@protocol(KudanARDelegate)]subscribeNext:^(RACTuple *x) {
        @strongify(self);
        if (is_loading) {return;}
        is_loading = YES;
        if (!self.cur_exhibit_id) {
            [Communtil playExhitbitSound];
            self.cur_exhibit_id = x[0];
            BOOL hasVideo = [x[2] boolValue];
            BOOL enTitle = [x[3] boolValue];
            [self.mainView showExhibitName:x[1] en:enTitle];
            NSString *copyID = self.cur_exhibit_id;
            if (self.cur_exhibit_id&&hasVideo) { //播放AR视频
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.mainView hideAllElement];
                    [self.arVC showARVideo:copyID];
                    if (self.arVC.playVideo) {
                        self.mainView.closeVideoBtn.hidden = NO;
                    }
                });
            }else if(self.cur_exhibit_id&&!hasVideo){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.viewModel.exhibitInfoCmd execute:copyID?:@""];
                });
            }
        }
        is_loading = NO;
    }];
    [[self.mainView.closeVideoBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.cur_exhibit_id) {
            if ([self.arVC isARVideoWithExhibitID:self.cur_exhibit_id]) {
                [self.viewModel.exhibitInfoCmd execute:self.cur_exhibit_id?:@""];
                [self.arVC hiddenVideo];
            }
        }
    }];
    
    [[self.mainView.takePhotoBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        self.shareImg = nil;
        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_sync(globalQueue, ^{
            UIImage *img = [self.arVC.cameraView screenshot];
            self.shareImg = [img addMsakImage:[UIImage imageNamed:@"sharelogo.png"]];
                UIImageWriteToSavedPhotosAlbum(_shareImg, self, nil, NULL);
            [MBProgressHUD showMessag:@"拍摄成功，已存到相册" toView:self.view];
        });
    }];
    [[self rac_signalForSelector:@selector(kudanLostTrack) fromProtocol:@protocol(KudanARDelegate)]subscribeNext:^(id x) {
        @strongify(self);
        self.cur_exhibit_id = nil;
        [self.mainView resetExhibitName];
        [self.mainView hideAllElement];
        if (self.verExhibitBtns && self.verExhibitBtns.count>0) {
            [self.verExhibitBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                VerticalButton *tempButton = self.verExhibitBtns[idx];
                tempButton.hidden = YES;
                tempButton.verticalTitle = @"";
                [tempButton removeFromSuperview];
                tempButton = nil;
            }];
        }
        [self.verExhibitBtns removeAllObjects];
        [self.exhibitids removeAllObjects];
        
    }];
    [[self rac_signalForSelector:@selector(kudanFinishVideo:) fromProtocol:@protocol(KudanARDelegate)]subscribeNext:^(id x) {
        @strongify(self);
        NSString *cur_id = x[0];
        [self.mainView resetExhibitName];
        [self.mainView hideAllElement];
        [self.viewModel.exhibitInfoCmd execute:cur_id];
    }];
}



#pragma mark initUI
- (void)initUI{
    self.view.backgroundColor = [UIColor clearColor];
    _mainView = ({
        ARHomeView *view = [[ARHomeView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:view];
        view;
    });
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.mainView addGestureRecognizer:tap];
    [self tapAction:nil];
    if ([self.museum.museum_id isEqualToString:@"42"]) {
        SearchViewController *vc = [[SearchViewController alloc]initWithMuseumInfo:self.museum searchType:HomeSearch searchResult:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
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


- (NSMutableArray *)verExhibitBtns{
    if (!_verExhibitBtns){
        _verExhibitBtns = [[NSMutableArray alloc] init];
    }
    return _verExhibitBtns;
}

- (NSMutableArray *)exhibitids{
    if (!_exhibitids) {
        _exhibitids = [[NSMutableArray alloc] init];
    }
    return _exhibitids;
}


@end
