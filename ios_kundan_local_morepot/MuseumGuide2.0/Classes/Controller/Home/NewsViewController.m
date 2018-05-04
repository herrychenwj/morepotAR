//
//  NewsViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "NewsViewController.h"
#import "NSNumber+Page.h"
#import "NewsDetailModel.h"
#import "NewsModel.h"
#import "NewsTableViewCell.h"
#import "NewsViewModel.h"
#import "WebViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "AdvertisementView.h"
#import "AdvertisingModel.h"
#import <AFNetworking/AFNetworking.h>
@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NewsViewModel *viewModel;
@property (nonatomic,strong)NSMutableArray *newsArray;
@property (nonatomic,strong)AdvertisementView *adView;
@property (nonatomic,strong)NSArray *advertisingAry;

@end
static NSString *const cellID = @"NewsTableViewCell";
@implementation NewsViewController


#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    NewsModel *news = [self.newsArray objectAtIndex:indexPath.row];
    cell.titleLB.attributedText = news.attrTitle;
    cell.timeLB.text = news.createdate;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:news.picture.cloudPath] placeholderImage:kPLACEHOLDERIMAGE];
    return cell;
}


#pragma mark BindViewModel

- (void)bindViewModel{
    self.viewModel = [[NewsViewModel alloc]initWithHUDShowView:self.view];
    @weakify(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self.viewModel.reloadNewsCmd refreshingAction:@selector(execute:)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self.viewModel.moreNewsCmd refreshingAction:@selector(execute:)];
    [self.viewModel.reloadNewsCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.newsArray removeAllObjects];
        [self.newsArray addObjectsFromArray:x];
        [self.tableView reloadData];
    }];
    
    [self.viewModel.moreNewsCmd.executionSignals.switchToLatest subscribeNext:^(NSArray *x) {
        @strongify(self);
        if (x.count > 0) {
            [self.newsArray addObjectsFromArray:x];
            [self.tableView reloadData];
        }
    }];
    
    [self.viewModel.detailCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        WebViewController *webVC = [WebViewController webControllerWithHtml:x];
        webVC.webView.backgroundColor = [UIColor blackColor];
        webVC.newsMode = YES;
        [webVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:webVC animated:YES];
    }];
    [self.viewModel.advertCmd.executionSignals.switchToLatest subscribeNext:^(NSArray *x) {
        @strongify(self);
        self.advertisingAry = x;
        self.adView.bannerView.imageURLStringsGroup = [self.advertisingAry.rac_sequence map:^id(AdvertisingModel *value) {
            return [value.pic cloudPath];
        }].array;
        self.adView.bannerView.titlesGroup =  [self.advertisingAry.rac_sequence map:^id(AdvertisingModel *value) {
            return value.title;
        }].array;
    }];
    
    [[[[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] autoPlaySound]reduceEach:^id(UITableView *tbView,NSIndexPath *indexPath){
        @strongify(self);
        return self.newsArray[indexPath.row];
    }]subscribeNext:^(NewsModel *x) {
        @strongify(self);
        if (x.url.length > 0) {
            WebViewController *vc = [WebViewController webControllerWithUrl:x.url];
            vc.hidesBottomBarWhenPushed = YES;
            vc.newsMode = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self.viewModel.detailCmd execute:x.museum_news_id?:@""];
        }
    }];
    
    [[self rac_signalForSelector:@selector(cycleScrollView:didSelectItemAtIndex:) fromProtocol:@protocol(SDCycleScrollViewDelegate)]subscribeNext:^(RACTuple *x) {
        @strongify(self);
        AdvertisingModel *advert = [self.advertisingAry objectAtIndex:[x[1] integerValue]];
        WebViewController *webVC = [WebViewController webControllerWithUrl:advert.url];
        webVC.newsMode = YES;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        @strongify(self);
        if (status != AFNetworkReachabilityStatusNotReachable) {
            [self.tableView.mj_header beginRefreshing];
            [self.viewModel.advertCmd execute:nil];
        }
    }];
    [self.viewModel.advertCmd execute:nil];
    [self.tableView.mj_header beginRefreshing];
#pragma mark SakuraKit重新撸数据
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:TXSakuraSkinChangeNotification object:nil]subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.advertCmd execute:nil];
        [self.viewModel.reloadNewsCmd execute:nil];
//        [self.tableView.mj_header beginRefreshing];
    }];
}

#pragma mark initUI
- (void)initUI{
    _adView = ({
        AdvertisementView *header = [[AdvertisementView alloc]initWithFrame:CGRectZero];
        header.titleLabel.sakura.text(@"news");
        header.bannerView.placeholderImage = kPLACEHOLDERIMAGE;
        header.bannerView.delegate = self;
        [self.view addSubview:header];
        header;
    });
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:cellID];
        tableView.rowHeight = 90.f;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
    
    if (IPHONE_DEVICE) {
        [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(14);
            make.height.equalTo(self.adView.mas_width).multipliedBy(213.0/361.0);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.adView.mas_bottom).offset(8);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-70);
        }];
    }else{
        [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(45);
            make.right.equalTo(self.view).offset(-80);
            make.left.equalTo(self.view).offset(kPADSETTING_LEFTMARGIN);
            make.height.equalTo(self.adView.mas_width).multipliedBy(213.0/361.0);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.self.adView.mas_bottom);
            make.left.equalTo(self.view).offset(kPADSETTING_LEFTMARGIN);
            make.right.equalTo(self.view).offset(-80);
            make.bottom.equalTo(self.view).offset(-52);
        }];
    }
}

#pragma mark lazy load
- (NSMutableArray *)newsArray{
    if (!_newsArray) {
        _newsArray = [NSMutableArray array];
    }
    return _newsArray;
}



@end
