//
//  FootprintViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/12/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "FootprintViewController.h"
#import "SearchCollectionViewCell.h"
#import "FavoriteModel.h"
#import "EnshrineViewModel.h"
#import "ExhibitViewController.h"
@interface FootprintViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UILabel *nodataLabel;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong)EnshrineViewModel *viewModel;
@end
static NSString *const cellID = @"SearchCollectionViewCell";
@implementation FootprintViewController


#pragma mark UICollectionVIew Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataAry.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    FavoriteModel *model = [self.dataAry objectAtIndex:indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.imageurl.cloudPath] placeholderImage:kPLACEHOLDERIMAGE];
    cell.nameLB.text = model.name;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 18;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteModel *model = [self.dataAry objectAtIndex:indexPath.row];
    [TalkingData trackEvent:@"我的足迹" label:model.name];
    [self.viewModel.exhibitInfoCmd execute:model.exhibit_id?:@""];
}


- (void)bindViewModel{
    self.viewModel = [[EnshrineViewModel alloc]initWithHUDShowView:self.view];
    @weakify(self);
    [self.viewModel.footprintCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.dataAry addObjectsFromArray:x];
        [self.collectionView reloadData];
        self.nodataLabel.hidden = (self.dataAry.count > 0);
    }];
    //展品信息加载完成后
    [[self.viewModel.exhibitInfoCmd.executionSignals switchToLatest]subscribeNext:^(ExhibitInfoModel *x) {
        @strongify(self);
        //不用检测支付状态
        x.ispaid = YES;
        ExhibitViewController *vc = [ExhibitViewController exhibitControllerWithInfo:x];
        vc.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"search_back"].CGImage);
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.viewModel.footprintCmd execute:nil];
}



- (void)initUI{
    self.view.backgroundColor = HexRGB(0x414141);
    [self setBackTitle:[TXSakuraManager tx_stringWithPath:@"footprint"]];
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = HexRGB(0x5f5f5f);
    [self.view addSubview:line];

    _nodataLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = @"您还没有浏览足迹哦";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:22];
        label.hidden = YES;
        [self.view addSubview:label];
        label;
    });

    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemW = IPHONE_DEVICE ? (kSCREEN_WIDTH - 40 - 36)/3.0: (kSCREEN_WIDTH -kPADSETTING_LEFTMARGIN-90-36)/3.0;
        layout.itemSize = CGSizeMake(itemW, itemW*1.04);
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [collectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:collectionView];
        collectionView;
    });
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(IPHONE_DEVICE?(IPHONEX_DEVICE?106:86):120, IPHONE_DEVICE?20:kPADSETTING_LEFTMARGIN, 0, IPHONE_DEVICE?20:90));
    }];
    [self.nodataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.collectionView.mas_top).offset(-20);
        make.height.equalTo(@1);
        make.left.right.equalTo(self.view);
    }];
}

- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}

@end
