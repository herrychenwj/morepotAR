//
//  EnshrineViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//
#import "MapGuideViewController.h"
#import "NAMapView.h"
#import "SVGKImage.h"
#import "MapExhibitView.h"
#import "MapExhibitCollectionViewCell.h"
#import "MuItemButton.h"
#import "SearchViewController.h"
#import "MuseumGuideViewController.h"
#import "MapGuideViewModel.h"
#import "MapModel.h"
#import "MapFloorTableViewCell.h"
#import "NAMapView+Cache.h"
#import "TopExhibitionModel.h"
#import "MapSearchModel.h"
#import "MuItemButton.h"
#import "WebViewController.h"

@interface MapGuideViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign)NSInteger current_floor;
@property (nonatomic,strong)MapExhibitView *exhibitView;
@property (nonatomic,strong)MuItemButton *goBackBtn;
@property (nonatomic,strong)NAMapView *mapView;
@property (nonatomic,strong)NSMutableArray *mapArray;
@property (nonatomic,strong)NSMutableArray *topArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MapGuideViewModel *viewModel;
@property (nonatomic,weak)MuseumModel *museum;

@end

static NSString *const cellID = @"MapExhibitCollectionViewCell";
static NSString *const floorCellID = @"MapFloorTableViewCell";


@implementation MapGuideViewController


- (instancetype)initWithMuseumInfo:(MuseumModel *)museum{
    if (self = [super init]) {
        self.museum = museum;
    }
    return self;
}

#pragma mark UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.topArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MapExhibitCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    TopExhibitionModel *exhibitModel = [self.topArray objectAtIndex:indexPath.row];
    cell.numLB.text = [NSString stringWithFormat:@"NO.%li",indexPath.row+1];
    cell.nameLB.text = [NSString stringWithFormat:@"  %@",exhibitModel.name];
    cell.exhibitImg.image = [Communtil imageFromlocalpath:exhibitModel.imageurl];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.01;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kSCREEN_WIDTH - (IPHONE_DEVICE?60:100))/(IPHONE_DEVICE?3:5), IPHONE_DEVICE?100:160);
}


#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mapArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MapFloorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:floorCellID forIndexPath:indexPath];
    MapModel *map = [self.mapArray objectAtIndex:indexPath.section];
    cell.floorLB.text = map.floor;
    return cell;
}



#pragma mark bindViewModel

- (void)bindViewModel{
    @weakify(self);
    MapGuideViewModel *viewModel = [[MapGuideViewModel alloc]initWithHUDShowView:self.view];
    RAC(viewModel,basicInfo) = RACObserve(self, museum);
    //地图信息
    [viewModel.mapInfoCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.mapArray addObjectsFromArray:x];
        if (self.mapArray.count == 0) {return;}
        MapModel *map = [self.mapArray firstObject];
        [self.mapView displaySVGMapWithURL:map.filename.cloudPath museum_id:self.museum.museum_id];
        [self.mapView setZoomScale:0 animated:NO];
        [self.mapView removeAllAnnotations:YES];
        [self.tableView reloadData];
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }];
    //头部展品加载完成
    [viewModel.topExhibitionCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.topArray addObjectsFromArray:x];
        [self.exhibitView.collectionView reloadData];
    }];
    
    [[self.goBackBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[[self rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:) fromProtocol:@protocol(UICollectionViewDelegate)]reduceEach:^id(UICollectionView *cv,NSIndexPath *indexPath){
        return @(indexPath.row);
    }]subscribeNext:^(NSNumber *x) {
        @strongify(self);
        [Communtil playClickSound];
        TopExhibitionModel *exhibitModel = [self.topArray objectAtIndex:[x integerValue]];

        MapModel *map = [self.mapArray objectAtIndex:self.current_floor];
        if ([map.floor isEqualToString:exhibitModel.floor]) {
            NSArray *location = [exhibitModel.location componentsSeparatedByString:@","];
            if ([location count] == 2) {
                NAAnnotation * brisbane = [NAAnnotation annotationWithPoint:CGPointMake([location[0] floatValue], [location[1] floatValue])];
                [self.mapView addPinAnnotation:brisbane imageName:@"wenwugps" animated:NO];
                [self.mapView setZoomScale:0 animated:NO];
            }
            return;
        }
        NSArray *mapFloor = [[self.mapArray.rac_sequence filter:^BOOL(MapModel *value) {
            return [value.floor isEqualToString:exhibitModel.floor];
        }] array];
        if (mapFloor.count > 0) { //存在地图  显示一下地图
            MapModel *map = [mapFloor firstObject];
            [self.mapView displaySVGMapWithURL:map.filename.cloudPath museum_id:self.museum.museum_id];
            [self.mapView setZoomScale:0 animated:NO];
            [self.mapView removeAllAnnotations:YES];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:[self.mapArray indexOfObject:map]] animated:NO scrollPosition:UITableViewScrollPositionNone];
            self.current_floor = [self.mapArray indexOfObject:map];
            NSArray *location = [exhibitModel.location componentsSeparatedByString:@","];
            if ([location count] == 2) {
                NAAnnotation * brisbane = [NAAnnotation annotationWithPoint:CGPointMake([location[0] floatValue], [location[1] floatValue])];
                [self.mapView addPinAnnotation:brisbane imageName:@"wenwugps" animated:NO];
                [self.mapView setZoomScale:0 animated:NO];
            }
        }
    }];
    [[[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)]reduceEach:^id(UITableView *tv,NSIndexPath *indexPath){
        return @(indexPath.section);
    }]subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (self.current_floor != [x integerValue]) {
            [Communtil playClickSound];
            MapModel *map = [self.mapArray objectAtIndex:[x integerValue]];
            [self.mapView displaySVGMapWithURL:map.filename.cloudPath museum_id:self.museum.museum_id];
            [self.mapView setZoomScale:0 animated:NO];
            [self.mapView removeAllAnnotations:YES];
            self.current_floor = [x integerValue];
        }
    }];
    self.viewModel = viewModel;
    [viewModel.topExhibitionCmd execute:nil];
    [viewModel.mapInfoCmd execute:nil];
}



#pragma mark initUI

- (void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _exhibitView = ({
        MapExhibitView *exhibitView = [[MapExhibitView alloc]initWithFrame:CGRectMake(0,IPHONEX_DEVICE?33:0, kSCREEN_WIDTH, IPHONE_DEVICE?100:160)];
        exhibitView.collectionView.delegate = self;
        exhibitView.collectionView.dataSource = self;
        [exhibitView.collectionView registerClass:[MapExhibitCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        exhibitView.collectionView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:exhibitView];
        exhibitView;
    });
    _mapView = ({
        NAMapView *mapView = [[NAMapView alloc]initWithFrame:CGRectZero];
        mapView.minimumZoomScale = 0.5f;
        mapView.maximumZoomScale = 1.5f;
        [mapView setZoomScale:0 animated:NO];
        [self.view addSubview:mapView];
        mapView;
    });

    _goBackBtn = ({
        MuItemButton *goBackBtn = [[MuItemButton alloc]initWithFrame:CGRectZero];
        goBackBtn.itemIcon.image = [UIImage imageNamed:@"back"];
        goBackBtn.itemLB.sakura.text(@"back");
        [self.view addSubview:goBackBtn];
        goBackBtn;
    });
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[MapFloorTableViewCell class] forCellReuseIdentifier:floorCellID];
        tableView.scrollEnabled = NO;
        tableView.bounces = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
    [self.goBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(IPHONE_DEVICE?@50:@60);
        make.height.equalTo(IPHONE_DEVICE?@60:@82);
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).offset(IPHONE_DEVICE?0:43);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.width.equalTo(@54);
        make.top.equalTo(self.mapView).offset(60);
        make.bottom.equalTo(self.mapView);
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.exhibitView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-100);
    }];

    @weakify(self);
    [[self.exhibitView.scrollBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.topArray.count > 0) {
            [Communtil playClickSound];
            NSIndexPath *currentIndexPath = [[self.exhibitView.collectionView indexPathsForVisibleItems] lastObject];
            [self.exhibitView.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow: (currentIndexPath.row == self.topArray.count - 1) ?0:currentIndexPath.row+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }
    }];
}



#pragma mark lazy load

- (NSMutableArray *)mapArray{
    if (!_mapArray) {
        _mapArray = [NSMutableArray array];
    }
    return _mapArray;
}

- (NSMutableArray *)topArray{
    if (!_topArray) {
        _topArray = [NSMutableArray array];
    }
    return _topArray;
}


@end
