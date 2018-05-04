//
//  RootViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "RootViewController.h"
#import "ARHomeViewController.h"
#import "MBProgressHUD+Add.h"
#import "MLNavigationController.h"
#import "Masonry.h"
#import "MeseumTableViewCell.h"
#import "MuseumModel.h"
#import "RootLoadingView.h"
#import "RootViewModel.h"
#import "Communtil.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <MJRefresh/MJRefresh.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import "RootSwitch.h"
#import "LQPopUpView.h"
#import "RootTarBarController.h"
#import "ARHomeViewController.h"
#import "MuseumListModel.h"
#import "FileUtil+Museum.h"
#import "DownloadFactory.h"

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate>
@property (nonatomic,strong)RootViewModel *viewModel;
@property (nonatomic,strong)RootSwitch  *topswitch;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)BMKLocationService *locationService;
@property (nonatomic,strong)NSDictionary *gpsInfo;
@property (nonatomic,assign)BOOL locationS;

@property (nonatomic,strong)RootLoadingView *loadingHud;
@property (nonatomic,strong)MuseumListModel *listModel;

@property (nonatomic,strong)BMKUserLocation *curLocation;
@end
static NSString *const cellID = @"MeseumTableViewCell";

@implementation RootViewController




- (void)bindViewModel{
    self.viewModel  = [[RootViewModel alloc]initWithHUDShowView:self.view];
    @weakify(self);
    __block BOOL firstload = YES;//第一次加载时 提示升级 以后都不提示
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self.viewModel.museumListCmd  refreshingAction:@selector(execute:)];
    //博物馆列表加载完成
    [self.viewModel.museumListCmd.executionSignals.switchToLatest subscribeNext:^(MuseumListModel *x) {
        @strongify(self);
        [self.locationService stopUserLocationService];
        self.gpsInfo = nil;
        for (MuseumModel *museum in x.museums) {
            [museum calculatethedistancebetween:self.curLocation];
        }
        x.museums = [x.museums sortedArrayUsingComparator:^NSComparisonResult(MuseumModel*  _Nonnull obj1, MuseumModel *  _Nonnull obj2) {
            if (obj1.distance == 0 && obj2>0) {
                return obj1.distance < obj2.distance;
            }else if(obj2.distance == 0 && obj1>0){
                return obj2.distance > obj1.distance;
            }else if(obj2.distance > 0 && obj1>0){
               return obj1.distance > obj2.distance;
            }else{
                return obj2.distance > obj1.distance;
            }
        }];
        
        self.listModel = x;
        
        [self.tableView reloadData];
        if ([Communtil needToUpdateCheck:x.lastestversion] && firstload) {
            [self showUpdateWindow:x.lastestversion updateflag:x.updateflag];
            firstload = NO;
            return;
        }
        firstload = NO;
    }];
    //AR资源下载完成（解压资源包 解压完成进入home页）
    [self.viewModel.loadARCmd.executionSignals.switchToLatest subscribeNext:^(MuseumModel *x) {
        @strongify(self);
        RootTarBarController *rootTab = (RootTarBarController *)self.tabBarController;
        [rootTab configKuDan: x];
    }];
    
    [[RACObserve(self.topswitch, selectedSegmentIndex) autoPlaySound] subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    RAC(self.viewModel,gpsInfo) = RACObserve(self, gpsInfo);
    RAC(self.loadingHud,percent) = RACObserve(self.viewModel, downloadProgress);
    RAC(self.loadingHud,hidden) = [RACObserve(self.viewModel, showProgress) map:^id(NSNumber *value) {
        return @(![value boolValue]);
    }];
    RAC(self.topswitch,hidden) =  RAC(self.tableView,hidden) = [RACObserve(self.viewModel, showProgress) map:^id(NSNumber *value) {
        return @([value boolValue]);
    }];
    
    RAC(self.view,backgroundColor) = [RACObserve(self.viewModel, showProgress) map:^id(NSNumber *value) {
        return [value boolValue]?[UIColor clearColor]:HexRGBAlpha(0x000000, 0.4);
    }];
    
    
    [[[[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] autoPlaySound]reduceEach:^(UITableView *tableView,NSIndexPath *indexPath){
        [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:kROOTSHOWANMIATION];
        MeseumTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.anmiation = NO;
        return [self.topswitch.selectedSegmentIndex == 1 ? self.listModel.culture:self.listModel.museums objectAtIndex:indexPath.row];
    }]subscribeNext:^(MuseumModel *x) {
        RootTarBarController *rootTab = (RootTarBarController *)self.tabBarController;
        if ([x isEqualToMuseum:rootTab.arVC.museum]) {
            ARHomeViewController *vc = [[ARHomeViewController alloc]initWithMuseumInfo:rootTab.arVC.museum];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:NO];
            return;
        }
        [self.loadingHud.loadingCircle.bgImgView sd_setImageWithURL:[NSURL URLWithString:x.home_logourl.cloudPath]];
        self.loadingHud.nameLB.text = x.museum_name;
        [self.viewModel.loadARCmd execute:x];
    }];
    
#pragma mark BMK
    [[self rac_signalForSelector:@selector(didUpdateBMKUserLocation:) fromProtocol:@protocol(BMKLocationServiceDelegate)]subscribeNext:^(RACTuple *x) {
        @strongify(self);
        BMKUserLocation *userLocation = x[0];
        self.curLocation = userLocation;
        self.gpsInfo = [@{@"gps":[NSString stringWithFormat:@"%f,%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude]} mutableCopy];
        if (!self.locationS) {
            self.locationS = YES;
            [self.tableView.mj_header beginRefreshing];
        }
    }];
    
    [[self rac_signalForSelector:@selector(didFailToLocateUserWithError:) fromProtocol:@protocol(BMKLocationServiceDelegate)]subscribeNext:^(id x) {
         @strongify(self);
        [self.tableView.mj_header beginRefreshing];
    }];
    
    [[self rac_signalForSelector:@selector(viewWillAppear:)]subscribeNext:^(id x) {
        @strongify(self);
        self.gpsInfo = nil;
        self.locationService.delegate = self;
    }];
    
    [[self rac_signalForSelector:@selector(viewWillDisappear:)]subscribeNext:^(id x) {
        @strongify(self);
        self.locationService.delegate = nil;
        [self.locationService stopUserLocationService];
    }];

    [[self.loadingHud.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [DownloadFactory  suspendDownloadTask];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[TXSakuraManager tx_stringWithPath:@"confirm_cancel_download"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:[TXSakuraManager tx_stringWithPath:@"commit"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [DownloadFactory cancelDownloadTask];
            self.gpsInfo = nil;
            [self.tableView.mj_header beginRefreshing];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[TXSakuraManager tx_stringWithPath:@"cancle"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [DownloadFactory resumeDownloadTask];
        }];
        [alertVC addAction:doneAction];
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        if (status != AFNetworkReachabilityStatusNotReachable) {
            [self.tableView.mj_header beginRefreshing];
        }
    }];
    [self.locationService startUserLocationService];
    
    RootTarBarController *rootTab = (RootTarBarController *)self.tabBarController;
    rootTab.arVC.configSuccess = ^(MuseumModel *museum){
        ARHomeViewController *vc = [[ARHomeViewController alloc]initWithMuseumInfo:museum];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:NO];
    };
#pragma mark SakuraKit重新刷新界面
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:TXSakuraSkinChangeNotification object:nil]subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.museumListCmd execute:nil];
//        [self.tableView.mj_header beginRefreshing];
    }];
    
    
}


- (void)showUpdateWindow:(NSString *)version updateflag:(NSNumber *)updateflag{
    NSString *warningStr = [NSString stringWithFormat:@"增加了新功能\n提高了版本稳定性%@",[updateflag boolValue]?@"\n(请务必下载此版本，否则将无法使用)":@""];
    LQPopUpView *popUpView = [[LQPopUpView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本 V%@",version] message:warningStr];
    [popUpView addBtnWithTitle:@"立即更新" type:LQPopUpBtnStyleDefault handler:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/%E4%BA%91%E8%A7%82%E5%8D%9A/id1231337446?l=zh&ls=1&mt=8"]];
    }];
    if (![updateflag boolValue]) {
        [popUpView addBtnWithTitle:@"跳过" type:LQPopUpBtnStyleDefault handler:^{
        }];
    }
    [popUpView showInView:self.view preferredStyle:LQPopUpViewStyleAlert];
}


#pragma mark tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.topswitch.selectedSegmentIndex == 1 ? self.listModel.culture.count:self.listModel.museums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeseumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    MuseumModel *museum = [self.topswitch.selectedSegmentIndex == 1 ? self.listModel.culture:self.listModel.museums objectAtIndex:indexPath.row];
    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:museum.home_logourl.cloudPath] placeholderImage:kPLACEHOLDERIMAGE];
    cell.nameLB.text = museum.museum_name;
    cell.addressLB.text = museum.address;
    cell.disLB.text = [NSString stringWithFormat:@"%.2fkm",museum.distance];
    cell.disLB.hidden = !(museum.distance > 0);
    cell.anmiation = (self.topswitch.selectedSegmentIndex == 0 && self.listModel.museums.count == 1&& ![[NSUserDefaults standardUserDefaults]objectForKey:kROOTSHOWANMIATION]);
    return cell;
}


#pragma mark InitUI
- (void)initUI{
    _locationService = ({
        BMKLocationService  *locationService = [[BMKLocationService alloc]init];
        [locationService setDesiredAccuracy:kCLLocationAccuracyBest];//设置定位精度
        locationService;
    });
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 90;
        tableView.backgroundColor = [UIColor clearColor];
        [tableView registerClass:[MeseumTableViewCell class] forCellReuseIdentifier:cellID];
        [self.view addSubview:tableView];
        tableView;
    });
    _loadingHud = ({
        RootLoadingView *hud = [[RootLoadingView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:hud];
        hud;
    });
    _topswitch = ({
        RootSwitch *seg = [[RootSwitch alloc]init];
        [seg selectAtIndex:0];
        seg.titleLB.sakura.text(@"start_language");
        seg.subLB.sakura.text(@"home_select_tip_refresh");
        [self.view addSubview:seg];
        seg;
    });
    IPHONE_DEVICE?[self layoutiPhone]:[self layoutPad];
}

- (void)layoutiPhone{
    [self.topswitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(IPHONEX_DEVICE?39:19);
        make.height.equalTo(@50);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topswitch.mas_bottom).offset(8);
        make.bottom.equalTo(self.view).offset(IPHONEX_DEVICE?-88:-55);
    }];
    [self.loadingHud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(60);
        make.right.equalTo(self.view).offset(-60);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.7);
    }];
}

- (void)layoutPad{
    [self.topswitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-90+26);
        make.top.equalTo(self.view.mas_top).offset(63);
        make.height.equalTo(@60);
        make.width.equalTo(self.tableView);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-72);
        make.right.equalTo(self.view).offset(-90+26);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.58);
        make.top.equalTo(self.topswitch.mas_bottom).offset(16);
    }];
    [self.loadingHud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.height.width.equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
}



@end
