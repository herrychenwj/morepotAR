

//
//  DiscoverViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/10/11.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverItemCell.h"
#import "DiscoverNavBar.h"
#import "DiscoverModel.h"
#import "DiscoverViewModel.h"
#import "NSString+URL.h"
#import "MBProgressHUD+Add.h"
#import <AlibcTradeBiz/AlibcTradeBiz.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>

@interface DiscoverViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)DiscoverNavBar *navBar;
@property (nonatomic,strong)DiscoverViewModel *viewModel;
@property (nonatomic,strong)NSMutableArray *dataAry;
@end
static NSString *const cellID = @"DiscoverItemCell";
@implementation DiscoverViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [TalkingData trackEvent:@"内部文创店" label:self.museumInfo.museum_name];
    [TalkingData trackEvent:self.museumInfo.museum_name label:@"内部文创店"];

}

- (void)bindViewModel{
    @weakify(self);
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        NSString *key = self.navBar.searchFD.text;
        if (key.length == 0) {return;}
        [TalkingData trackEvent:@"文创搜索" label:self.museumInfo.museum_name parameters:@{key:key}];
        [TalkingData trackEvent:self.museumInfo.museum_name label:@"文创搜索" parameters:@{key:key}];

        NSArray  *ary =  [[self.goodsAry.rac_sequence filter:^BOOL(DiscoverModel *value) {
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
        [self.dataAry addObjectsFromArray:self.goodsAry];
        [self.collectionView reloadData];
    }];
    [self.navBar.searchFD.rac_textSignal subscribeNext:^(NSString *x) {
        @strongify(self);
        if (x.length == 0) {
            [self.dataAry removeAllObjects];
            [self.dataAry addObjectsFromArray:self.goodsAry];
            [self.collectionView reloadData];
        }
    }];
    [[self rac_signalForSelector:@selector(scrollViewDidEndDragging:willDecelerate:) fromProtocol:@protocol(UIScrollViewDelegate)]subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
}

- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectZero];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    _navBar = ({
        DiscoverNavBar *nav = [[DiscoverNavBar alloc]initWithFrame:CGRectZero];
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
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[DiscoverItemCell class] forCellWithReuseIdentifier:cellID];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:collectionView];
        collectionView;
    });
    if (IPHONE_DEVICE) {
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.bottom.equalTo(self.collectionView.mas_top).offset(-5);
        }];
        [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView).offset(IPHONEX_DEVICE?40:20);
            make.left.right.equalTo(topView);
            make.bottom.equalTo(topView).offset(-5);
        }];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(IPHONEX_DEVICE?86:66, 10, 0, 10));
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
    }

    @weakify(self);
    self.navBar.titleLabel.text = self.museumInfo.museum_name;
    [[self.navBar.backControl rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
//    [self.navBar.titleLabel setTitle:[NSString stringWithFormat:@"%@旗舰店",self.museumInfo.museum_name?:@""] forState:UIControlStateNormal];
//    [[self.navBar.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
//        @strongify(self);
//        [self.navigationController popViewControllerAnimated:YES];
//    }];

}



//- (void)bindViewModel{
//    _viewModel = [[DiscoverViewModel alloc]initWithHUDShowView:self.view];
//    [self.viewModel.loadInfoCmd.executionSignals.switchToLatest subscribeNext:^(NSArray *x) {
//        [self.dataAry addObjectsFromArray:x];
//        [self.collectionView reloadData];
//    }];
//    [self.viewModel.loadInfoCmd execute:self.museumInfo.museum_id];
//
//}

#pragma mark UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataAry.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    DiscoverModel *model = [self.dataAry objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[model.pic cloudPath]] placeholderImage:[UIImage imageNamed:@"loading"]];
    cell.contentLabel.text = model.name;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
        return 0.1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    DiscoverModel *model = [self.dataAry objectAtIndex:indexPath.row];
    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
    showParam.openType = AlibcOpenTypeNative;
    showParam.backUrl=@"tbopen24770018://";
    showParam.isNeedPush=YES;
    id<AlibcTradePage> page = [AlibcTradePageFactory page: model.url];
    AlibcTradeTaokeParams *taoKeParams=[[AlibcTradeTaokeParams alloc] init];
    taoKeParams.pid=@"mm_126444785_0_0";
    showParam.openType = AlibcOpenTypeNative;
    [[AlibcTradeSDK sharedInstance].tradeService show:self.navigationController page:page showParams:showParam taoKeParams:taoKeParams trackParam:nil tradeProcessSuccessCallback:nil tradeProcessFailedCallback:nil];
}

#pragma mark lazy load
- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}


@end
