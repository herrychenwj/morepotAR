//
//  SearchViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "SearchViewController.h"
#import "EnshrineTableViewCell.h"
#import "ExhibitViewController.h"
#import "MapSearchModel.h"
#import "SearchViewModel.h"
#import "SearchCollectionViewCell.h"
#import "SearchAllModel.h"
#import "SearchHeaderCollectionReusableView.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic,strong)UITextField *searchFD;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *searchArray;
@property (nonatomic,strong)SearchViewModel *viewModel;
@property (nonatomic,strong)NSArray *allExhibitAry;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,assign)BOOL payCheck;
@property (nonatomic,assign)SearchType searchType;
@property (nonatomic,weak)MuseumModel *museum;
@property (nonatomic,copy)void(^searchResult)(MapSearchModel*);
@end
static NSString *const allcellID = @"SearchCollectionViewCell";
static NSString *const cellID = @"EnshrineTableViewCell";
static NSString *const reusableID = @"SearchHeaderCollectionReusableView";

@implementation SearchViewController
- (instancetype)initWithMuseumInfo:(MuseumModel *)museum searchType:(SearchType)type searchResult:(void(^)(MapSearchModel*))resultBlock{
    if (self = [super init]) {
        self.museum = museum;
        self.searchType = type;
        self.searchResult = resultBlock;
    }
    return self;
}



#pragma mark BindViewModel
- (void)bindViewModel{
    @weakify(self);
    self.viewModel = [[SearchViewModel alloc]initWithHUDShowView:self.view];
    RAC(self.viewModel,basicInfo) = RACObserve(self, museum);
    RAC(self.viewModel,keyword) = self.searchFD.rac_textSignal;
    RAC(self.collectionView,hidden) = [self.searchFD.rac_textSignal map:^id(NSString *value) {
        return @(value.length > 0);
    }];
    RAC(self.tableView,hidden) = [self.searchFD.rac_textSignal map:^id(NSString *value) {
        return @(value.length == 0);
    }];
    
    //点击键盘搜索按钮事件
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        self.searchType == MapSearch? [self.viewModel.mapSeachCmd execute:nil]:[self.viewModel.homeSeachCmd execute:nil];
    }];
    //搜索栏将要清空事件
    [[self rac_signalForSelector:@selector(textFieldShouldClear:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        self.searchFD.text = @"";
        [self.searchArray removeAllObjects];
        [self.tableView reloadData];
    }];
    //服务端返回搜索信息
    [[self.viewModel.mapSeachCmd.executionSignals.switchToLatest merge:self.viewModel.homeSeachCmd.executionSignals.switchToLatest]subscribeNext:^(id x) {
        @strongify(self);
        [self.searchArray removeAllObjects];
        [self.searchArray addObjectsFromArray:x];
        [self.view endEditing:YES];
        [self.tableView reloadData];
    }];

    [self.viewModel.exhibitInfoCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        ExhibitInfoModel *exhibitinfo = (ExhibitInfoModel*)x;
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:exhibitinfo.exhibition_name,@"label",[Communtil getCurrentDate], @"datetime",nil];
        [FileUtil saveTalkingdata:@"臻品查看.json" conent:[Communtil DataTOjsonString:dic]];
        
        ExhibitViewController *vc = [ExhibitViewController exhibitControllerWithInfo:x];
//        vc.museumInfo = self.museum;
//        vc.goodsAry = self.goodsAry;
        vc.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"search_back"].CGImage);
//        vc.refreshData = ^(){
//            @strongify(self);
//            [self.viewModel.allExhibitCmd execute:nil];
//            [self.viewModel.searchCmd execute:nil];
//        };
        [self.navigationController pushViewController:vc animated:YES];
    }];


    [self.viewModel.allExhibitCmd.executionSignals.switchToLatest subscribeNext:^(NSArray *x) {
        @strongify(self);
        self.allExhibitAry = x;
        [self.collectionView reloadData];
        //登录过后检测是否需要自动跳转支付界面
//        if (self.payCheck) {
//            BOOL lock = NO;
//            for (SearchAllModel *all in self.allExhibitAry) {
//                for (MapSearchModel *value in all.exhibits) {
//                    if (value.lock) {
//                        lock = YES;
//                        break;
//                    }
//                }
//            }
//            if (lock) {
//                [self payWithTrackName:nil];
//            }
//            self.payCheck = NO;
//        }
    }];
    [self.viewModel.allExhibitCmd execute:nil];

//    if (self.searchType == HomeSearch) {
//        [self.viewModel.allExhibitCmd execute:nil];
//    }
#pragma mark TableView Delegate
    [[[[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] autoPlaySound]reduceEach:^id(UITableView *tableView,NSIndexPath *indexPath){
        @strongify(self);
        return self.searchArray[indexPath.row];
    }]subscribeNext:^(MapSearchModel *x) {
        @strongify(self);
        if (self.searchType == MapSearch) { //如果是地图搜索 返回地图界面
            if (self.searchResult) {
                self.searchResult(x);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{ //如果是首页搜索 直接跳转到 展品界面
            [self.viewModel.exhibitInfoCmd execute:x.exhibit_id];
           
//            x.lock?[self payWithTrackName:x.name]:[self.viewModel.exhibitInfoCmd execute:x.exhibit_id];
        }
    }];
#pragma mark CollectionView Delegate
    [[[self rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:) fromProtocol:@protocol(UICollectionViewDelegate)]reduceEach:^id(UICollectionView *collectionView,NSIndexPath *indexPath){
        @strongify(self);
        return  [((SearchAllModel *)[self.allExhibitAry objectAtIndex:indexPath.section]).exhibits objectAtIndex:indexPath.row];
    }]subscribeNext:^(MapSearchModel *x) {
        @strongify(self);
        [self.viewModel.exhibitInfoCmd execute:x.exhibit_id];
//         x.lock?[self payWithTrackName:x.name]:[self.viewModel.exhibitInfoCmd execute:x.exhibit_id];
    }];
    
    [[self rac_signalForSelector:@selector(scrollViewDidEndDragging:willDecelerate:) fromProtocol:@protocol(UIScrollViewDelegate)]subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
    
}
#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EnshrineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    MapSearchModel *exhibit = [self.searchArray objectAtIndex:indexPath.row];
    cell.titleLB.text = exhibit.name;
    cell.introduceLB.text = exhibit.mdescription;
//    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:exhibit.logourl.cloudPath] placeholderImage:kPLACEHOLDERIMAGE];
    cell.imgView.image = [Communtil imageFromlocalpath:exhibit.logourl];
    return cell;
}

#pragma mark UICollectionVIew Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ((SearchAllModel *)[self.allExhibitAry objectAtIndex:section]).exhibits.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.allExhibitAry.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:allcellID forIndexPath:indexPath];
    MapSearchModel *exhibit = [((SearchAllModel *)[self.allExhibitAry objectAtIndex:indexPath.section]).exhibits objectAtIndex:indexPath.row];
    cell.nameLB.text = exhibit.name;
//    cell.lockImgView.hidden = !exhibit.lock;
//    cell.lockView.hidden = !exhibit.lock;
    cell.imgView.image = [Communtil imageFromlocalpath:exhibit.logourl];
//    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:exhibit.logourl.cloudPath] placeholderImage:kPLACEHOLDERIMAGE];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 18;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SearchHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableID forIndexPath:indexPath];
        header.titleLB.text = [NSString stringWithFormat:@"一 %@ 一",((SearchAllModel *)[self.allExhibitAry objectAtIndex:indexPath.section]).exhibition];
        return header;
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={kSCREEN_WIDTH,50};
    return size;
}



#pragma mark InitUI
- (void)initUI{
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"search_back"].CGImage);
    [self setBackTitle:@"AR"];
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[EnshrineTableViewCell class] forCellReuseIdentifier:cellID];
        tableView.rowHeight = 74.f;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
    _searchFD = ({
        UITextField *fd = [[UITextField alloc]initWithFrame:CGRectZero];
        fd.backgroundColor = [UIColor colorWithRed:93./255.0 green:93.0/255.0 blue:93.0/255.0 alpha:0.7];
        fd.clearButtonMode = UITextFieldViewModeWhileEditing;
        fd.textColor= [UIColor whiteColor];
        fd.layer.cornerRadius = 4.f;
        fd.layer.masksToBounds = YES;
        NSMutableAttributedString *attrSearch = [[NSMutableAttributedString alloc]initWithString:[TXSakuraManager tx_stringWithPath:@"input_search_key"] attributes:@{NSForegroundColorAttributeName:HexRGB(0xb6b6b7)}];
        fd.attributedPlaceholder = [attrSearch copy];
        fd.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(8, 6, 32, 20)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.image = [UIImage imageNamed:@"find"];
        fd.leftView = img;
        fd.returnKeyType = UIReturnKeySearch;
        fd.delegate = self;
        [self.view addSubview:fd];
        fd;
    });
    if (self.searchType == HomeSearch) {
        _collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
            CGFloat itemW = IPHONE_DEVICE ? (kSCREEN_WIDTH - 40 - 36)/3.0: (kSCREEN_WIDTH -kPADSETTING_LEFTMARGIN-90-36)/3.0;
            layout.itemSize = CGSizeMake(itemW, itemW*1.04);
            UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
            [collectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:allcellID];
            [collectionView registerClass:[SearchHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusableID];
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.backgroundColor = [UIColor clearColor];
            collectionView.showsVerticalScrollIndicator = NO;
            [self.view addSubview:collectionView];
            collectionView;
        });
    }
    IPHONE_DEVICE?[self layoutiPhone]:[self layoutPad];
}

- (void)layoutiPhone{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(86, 0, 0, 16));
    }];
    [self.searchFD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@32);
        make.centerY.equalTo(self.backBtn);
        make.left.equalTo(self.view).offset(100);
        make.right.equalTo(self.view).offset(-30);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(IPHONEX_DEVICE?86:66, 20, 0, 20));
    }];
}

- (void)layoutPad{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(120, kPADSETTING_LEFTMARGIN, 0, 90));
    }];
    [self.searchFD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@32);
        make.right.equalTo(self.tableView);
        make.centerY.equalTo(self.backBtn);
        make.left.equalTo(self.backBtn.mas_right).offset(20);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(80, kPADSETTING_LEFTMARGIN, 0, 90));
    }];
}




#pragma mark lazy load
- (NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}




@end
