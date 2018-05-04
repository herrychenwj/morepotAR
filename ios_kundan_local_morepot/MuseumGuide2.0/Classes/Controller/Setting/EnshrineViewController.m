//
//  EnshrineViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "EnshrineViewController.h"
#import "EnshrineTableViewCell.h"
#import "MyCommentViewController.h"
#import "EnshrineViewModel.h"
#import "NSNumber+Page.h"
#import "MyCommentModel.h"
#import "FavoriteModel.h"
#import "ExhibitViewController.h"
#import "ExhibitInfoModel.h"
#import "MLNavigationController.h"

@interface EnshrineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)ListControllerType cType;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong)EnshrineViewModel *viewModel;
@property (nonatomic,strong)UILabel *nodataLabel;
@end
static NSString *const cellID = @"EnshrineTableViewCell";
@implementation EnshrineViewController

+ (EnshrineViewController *)Controller:(ListControllerType)type{
    EnshrineViewController *vc = [[EnshrineViewController alloc]init];
    vc.cType = type;
    return vc;
}


#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EnshrineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (self.cType == ListControllerType_Comment) {
        MyCommentModel *model = [self.dataAry objectAtIndex:indexPath.row];
        cell.titleLB.text = model.exhibitname;
        cell.introduceLB.text = model.content;
        cell.timeLB.text = model.created_at;
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.imageurl.cloudPath] placeholderImage:kPLACEHOLDERIMAGE];
    }else{
        FavoriteModel *model = [self.dataAry objectAtIndex:indexPath.row];
        cell.titleLB.text = model.name;
        cell.introduceLB.text = model.exhibitdesc;
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.imageurl.cloudPath] placeholderImage:kPLACEHOLDERIMAGE];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [Communtil playClickSound];
    if (self.cType == ListControllerType_Comment) {
        MyCommentModel *cmtModel = [self.dataAry objectAtIndex:indexPath.row];
        MyCommentViewController *vc = [MyCommentViewController controllerWithComment:cmtModel];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        FavoriteModel *model = [self.dataAry objectAtIndex:indexPath.row];
        [TalkingData trackEvent:@"我的收藏" label:model.name];
        [self.viewModel.exhibitInfoCmd execute:model.exhibit_id?:@""];
    }

}


#pragma mark BindViewModel
- (void)bindViewModel{
    self.viewModel = [[EnshrineViewModel alloc]initWithHUDShowView:self.view];
    @weakify(self);
    [self.viewModel.favCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.dataAry addObjectsFromArray:x];
        [self.tableView reloadData];
        self.nodataLabel.hidden = (self.dataAry.count > 0);
    }];
    
    [self.viewModel.footprintCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.dataAry addObjectsFromArray:x];
        [self.tableView reloadData];
        self.nodataLabel.hidden = (self.dataAry.count > 0);
    }];
    
    [self.viewModel.cmtlistCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        [self.dataAry addObjectsFromArray:x];
        [self.tableView reloadData];
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
    switch (self.cType) {
        case ListControllerType_Collection:
            [self.viewModel.favCmd execute:nil];
            break;
        case ListControllerType_Comment:
            [self.viewModel.cmtlistCmd execute:nil];
            break;
        case ListControllerType_Footprint:
            [self.viewModel.footprintCmd execute:nil];
            break;
        default:
            break;
    }

}





#pragma mark initUI
- (void)initUI{
    self.view.backgroundColor = HexRGB(0x414141);
    NSString *title;
    switch (self.cType) {
        case ListControllerType_Collection:
            title = @"mycollect";
            break;
        case ListControllerType_Comment:
            title = @"mycomment";
            break;
        case ListControllerType_Footprint:
            title = @"footprint";
            break;
        default:
            break;
    }
    [self setBackTitle:[TXSakuraManager tx_stringWithPath:title]];
    UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
    line.backgroundColor = HexRGB(0x5f5f5f);
    [self.view addSubview:line];
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        [tableView registerClass:[EnshrineTableViewCell class] forCellReuseIdentifier:cellID];
        tableView.rowHeight = 68.f;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
    
    _nodataLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        NSString *title;
        switch (self.cType) {
            case ListControllerType_Collection:
                title = @"您还没有收藏哦";
                break;
            case ListControllerType_Comment:
                title = @"您还没有评论哦";
                break;
            case ListControllerType_Footprint:
                title = @"您还没有浏览足迹哦";
                break;
            default:
                break;
        }
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:22];
        label.hidden = YES;
        [self.view addSubview:label];
        label;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(IPHONE_DEVICE?(IPHONEX_DEVICE?106:86):120, IPHONE_DEVICE?0:kPADSETTING_LEFTMARGIN, 0, IPHONE_DEVICE?0:90));
    }];
     [self.nodataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
     [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableView.mas_top).offset(-20);
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
