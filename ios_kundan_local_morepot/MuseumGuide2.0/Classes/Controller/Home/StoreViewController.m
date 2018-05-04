//
//  StoreViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/11/7.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "StoreViewController.h"
#import "DiscoverViewModel.h"
#import "DiscoverItemCell.h"
#import "StoreTableViewCell.h"
#import "DiscoverModel.h"
#import "StoreNavBar.h"
#import "StoreViewModel.h"
#import "MBProgressHUD+Add.h"
#import "MuseumModel.h"
#import "YYText.h"
#import <AlibcTradeBiz/AlibcTradeBiz.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>

@interface StoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIControl *tableControl;
@property (nonatomic,strong)StoreNavBar *navBar;
@property (nonatomic,strong)StoreViewModel *viewModel;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong)NSMutableArray *museumAry;
@property (nonatomic,strong)NSMutableArray *all_data;
@end
static NSString *const cellID = @"DiscoverItemCell";
static NSString *const tbCellID = @"StoreTableViewCell";

static NSIndexPath *selIndex;
@implementation StoreViewController



- (void)bindViewModel{
    _viewModel = [[StoreViewModel alloc]initWithHUDShowView:self.view];
    @weakify(self);
    [self.viewModel.museumListCmd.executionSignals.switchToLatest subscribeNext:^(NSArray *x) {
        if (x.count > 0) {
            [self.museumAry addObjectsFromArray:x];
            [self.tableView reloadData];
            if(self.museumAry.count > 0){
                NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
                [self.tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionTop];
                [self tableView:self.tableView didSelectRowAtIndexPath:index];
            }
        }
    }];
    [self.viewModel.loadGoodsCmd.executionSignals.switchToLatest subscribeNext:^(NSArray *x) {
        @strongify(self);
        [self.dataAry removeAllObjects];
        [self.dataAry addObjectsFromArray:x];
        [self.all_data removeAllObjects];
        [self.all_data addObjectsFromArray:x];
        [self.collectionView reloadData];
    }];
    [[self.navBar.selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(StoreButton *x) {
        @strongify(self);
        self.tableControl.hidden =  !self.tableControl.hidden;
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    [[self rac_signalForSelector:@selector(scrollViewDidEndDragging:willDecelerate:) fromProtocol:@protocol(UIScrollViewDelegate)]subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];

    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        NSString *key = self.navBar.searchFD.text;
        if (key.length == 0) {return;}
        MuseumModel *mu = [self.museumAry objectAtIndex:selIndex.row-1];
        [TalkingData trackEvent:@"文创搜索" label:mu.museum_name parameters:@{key:key}];
        [TalkingData trackEvent:mu.museum_name label:@"文创搜索" parameters:@{key:key}];
        NSArray  *ary =  [[self.all_data.rac_sequence filter:^BOOL(DiscoverModel *value) {
            return [value.name containsString:key];
        }] array];
        if (ary.count == 0) {
            [MBProgressHUD showMessag:@"没有与之相关的产品，请换个词试试" toView:self.view];
            return;
        }
        [self.dataAry removeAllObjects];
        [self.dataAry addObjectsFromArray:ary];
        [self.collectionView reloadData];
    }];
    //搜索栏将要清空事件
    [[self rac_signalForSelector:@selector(textFieldShouldClear:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        self.navBar.searchFD.text = @"";
        [self.dataAry removeAllObjects];
        [self.dataAry addObjectsFromArray:self.all_data];
        [self.collectionView reloadData];
    }];
    [self.navBar.searchFD.rac_textSignal subscribeNext:^(NSString *x) {
        @strongify(self);
        if (x.length == 0) {
            [self.dataAry removeAllObjects];
            [self.dataAry addObjectsFromArray:self.all_data];
            [self.collectionView reloadData];
        }
    }];
    [self.viewModel.museumListCmd execute:nil];
}

- (void)tapAction:(UIGestureRecognizer*)gesture{
    [self.view endEditing:YES];
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UICollectionView class]]||[touch.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return  NO;
}


- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectZero];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    _navBar = ({
        StoreNavBar *nav = [[StoreNavBar alloc]initWithFrame:CGRectZero];
        nav.searchFD.delegate = self;
        nav.backgroundColor = [UIColor clearColor];
        [topView addSubview:nav];
        nav;
    });
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        if (IPHONE_DEVICE) {
            layout.itemSize = CGSizeMake((kSCREEN_WIDTH - 10*3)/2, ((kSCREEN_WIDTH - 10*3)/2)*(73/52.0));
        }else{
            CGFloat width = (kSCREEN_WIDTH - kPADSETTING_LEFTMARGIN - 90 - 10)/2;
            layout.itemSize = CGSizeMake(width, width*(73/52.0));
        }
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[DiscoverItemCell class] forCellWithReuseIdentifier:cellID];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:collectionView];
        collectionView;
    });
    _tableControl = ({
        UIControl *control = [[UIControl alloc]initWithFrame:CGRectZero];
        control.backgroundColor = [UIColor clearColor];
        [control addTarget:self action:@selector(hideTable) forControlEvents:UIControlEventTouchUpInside];
        control.hidden = YES;
        [self.view addSubview:control];
        control;
    });

    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = HexRGBAlpha(0x000000, 0.7);
        tableView.rowHeight = 50;
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.tableControl addSubview:tableView];
        tableView;
    });
    
    
    if (IPHONE_DEVICE) {
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(IPHONEX_DEVICE?20:0);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.collectionView.mas_top).offset(-5);
        }];
        [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView).offset(20);
            make.left.right.bottom.equalTo(topView);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(IPHONEX_DEVICE?91:71, 10, IPHONEX_DEVICE?82:49, 10));
        }];
        [self.tableControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.collectionView);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.equalTo(self.tableControl);
            make.width.equalTo(@((kSCREEN_WIDTH - 5)/2+20));
        }];
    }else{
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@kPADSETTING_LEFTMARGIN);
            make.right.equalTo(self.view).offset(-90);
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.collectionView.mas_top).offset(-5);
        }];
        [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView).offset(20);
            make.left.right.bottom.equalTo(topView);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(80, kPADSETTING_LEFTMARGIN, 0, 90));
        }];
        [self.tableControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.collectionView);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.equalTo(self.tableControl);
            make.width.equalTo(@((kSCREEN_WIDTH- kPADSETTING_LEFTMARGIN - 5)/2+20));
        }];
    }
}

- (void)hideTable{
    self.tableControl.hidden = YES;
}

#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.museumAry.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tbCellID ];
    if (!cell) {
        cell = [[StoreTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tbCellID];
    }
    if (indexPath.row == 0) {
        cell.titleLB.text = [NSString stringWithFormat:@"全部  %li",self.museumAry.count];
    }else{
        MuseumModel *mu = [self.museumAry objectAtIndex:indexPath.row-1];
        cell.titleLB.text = mu.museum_name;
    }
//    cell.imgV.hidden = (indexPath.row == 0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self.tableView selectRowAtIndexPath:selIndex animated:NO scrollPosition:UITableViewScrollPositionTop];
       return;
    }
    MuseumModel *mu = [self.museumAry objectAtIndex:indexPath.row-1];
    [TalkingData trackEvent:@"首页文创店" label:mu.museum_name];
    [TalkingData trackEvent:mu.museum_name label:@"首页文创店"];
    [self.viewModel.loadGoodsCmd execute:mu.museum_id];
    self.tableControl.hidden = YES;
    selIndex = indexPath;
}


#pragma mark UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataAry.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    DiscoverModel *model = [self.dataAry objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[model.pic cloudPath]] placeholderImage:[UIImage imageNamed:@"loading"]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:model.name];
    attr.yy_lineSpacing = 4.f;
    cell.contentLabel.attributedText = attr;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    DiscoverModel *model = [self.dataAry objectAtIndex:indexPath.row];
    MuseumModel *mu = [self.museumAry objectAtIndex:selIndex.row-1];
    NSDate *now = [NSDate new];
    NSDateFormatter *fm = [[NSDateFormatter alloc]init];
    [fm setDateFormat:@"YYY-MM-dd HH:mm"];
    NSString *time = [fm stringFromDate:now];
    [TalkingData trackEvent:@"文创商品" label:mu.museum_name parameters:@{model.name?:@"":time}];
    [TalkingData trackEvent:mu.museum_name label:@"文创商品"  parameters:@{model.name?:@"":time}];
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeNative;
    showParam.backUrl=@"tbopen24770018://";
    showParam.isNeedPush=YES;
    id<AlibcTradePage> page = [AlibcTradePageFactory page: model.url];
    AlibcTradeTaokeParams *taoKeParams=[[AlibcTradeTaokeParams alloc] init];
    taoKeParams.pid=@"mm_126444785_0_0";
    [[AlibcTradeSDK sharedInstance].tradeService show:self.navigationController page:page showParams:showParam taoKeParams:taoKeParams trackParam:nil tradeProcessSuccessCallback:nil tradeProcessFailedCallback:nil];
}

#pragma lazy load
- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}

- (NSMutableArray *)all_data{
    if (!_all_data) {
        _all_data = [NSMutableArray array];
    }
    return _all_data;
}


- (NSMutableArray *)museumAry{
    if (!_museumAry) {
        _museumAry = [NSMutableArray array];
    }
    return _museumAry;
}


@end
