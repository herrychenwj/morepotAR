//
//  MuseumInfoViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "Mp3Player.h"
#import "MuItemButton.h"
#import "MuseumInfoHeaderView.h"
#import "MuseumInfoModel.h"
#import "MuseumInfoTextTableViewCell.h"
#import "MuseumInfoTextView.h"
#import "MuseumInfoViewController.h"
#import "MuseumViewModel.h"
#import "YYLabel.h"
#import "ZLPhotoPickerBrowserPhoto.h"
#import "ZLPhotoPickerBrowserViewController.h"
#import <MJExtension/MJExtension.h>

@interface MuseumInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)MuseumInfoHeaderView *headerView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MuseumViewModel *viewModel;
@property (nonatomic,strong)MuItemButton *goBackBtn;
@property (nonatomic,strong)Mp3Player *audioPlayer;
@end

static NSString *const cellID = @"MuseumInfoTextTableViewCell";

@implementation MuseumInfoViewController

- (instancetype)initWithBasicInfo:(MuseumModel *)basicInfo detailInfo:(MuseumInfoModel *)detailInfo{
    if (self = [super init]) {
        self.bascInfo = basicInfo;
        self.detailInfo = detailInfo;
    }
    return self;
}

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MuseumInfoTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MuseumInfoTextTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID hasMore:YES];
    }
    cell.contentLB.attributedText = (indexPath.section == 0)?self.detailInfo.attributeDesc:self.detailInfo.attributeAddress;
    cell.closeBtn.hidden = !(self.detailInfo.isOpen && indexPath.section == 0);
    @weakify(self);
    cell.reload = ^(){
        @strongify(self);
        [Communtil playClickSound];
        self.detailInfo.isOpen = !self.detailInfo.isOpen;
        [self.tableView reloadData];
    };
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.section == 0)? [self.detailInfo descRowHeight]:[self.detailInfo addressRowHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}


#pragma mark initUI
- (void)initUI{
    self.view.backgroundColor = [UIColor clearColor];
    _headerView = ({
        MuseumInfoHeaderView *header = [[MuseumInfoHeaderView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:header];
        header;
    });
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView;
    });
    _goBackBtn = ({
        MuItemButton *goBackBtn = [[MuItemButton alloc]initWithFrame:CGRectZero];
        goBackBtn.itemLB.font = [UIFont systemFontOfSize:IPHONE_DEVICE?12:15];
        goBackBtn.itemLB.sakura.text(@"back");
        goBackBtn.itemIcon.image = [UIImage imageNamed:@"back"];
        [self.view addSubview:goBackBtn];
        goBackBtn;
    });
     IPHONE_DEVICE?[self layoutiPhone]:[self layoutPad];
    [self.headerView.shareBtn setEnabled:NO];
}

- (void)layoutiPhone{
    [self.goBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@60);
        make.right.equalTo(self.tableView.mas_left);
        make.centerY.equalTo(self.view);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(42);
        make.top.equalTo(self.view).offset(IPHONEX_DEVICE?42:22);
        make.right.equalTo(self.view);
        make.height.equalTo(self.headerView.mas_width).multipliedBy(0.7);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView);
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view).offset(-20);
    }];
}


- (void)layoutPad{
    [self.goBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(IPHONE_DEVICE?@50:@60);
        make.height.equalTo(IPHONE_DEVICE?@60:@82);
        make.left.equalTo(self.view).offset(43);
        make.centerY.equalTo(self.view);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(45);
        make.right.equalTo(self.view).offset(-80);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.42);
        make.height.equalTo(self.headerView.mas_width).multipliedBy(0.7);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView);
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view).offset(-100);
    }];
}



- (void)bindViewModel{
    self.audioPlayer = [[Mp3Player alloc]init];
    @weakify(self);
    MuseumViewModel *viewModel = [[MuseumViewModel alloc]initWithHUDShowView:self.view];
    RAC(viewModel,basicInfo) = RACObserve(self, bascInfo);
    RAC(viewModel,detailInfo) = RACObserve(self, detailInfo);
    //博物馆信息加载
    __block BOOL isFirstPlay = YES;
    //音频预播
    [viewModel.audioReadyCmd.executionSignals.switchToLatest subscribeNext:^(NSString *x) {
        @strongify(self);
        [self.audioPlayer playAudioWithFilePath:x progress:nil didComplete:^(){
            @strongify(self);
            self.audioPlayer.currentTime = 0.0;
            self.headerView.playBtn.selected = !self.headerView.playBtn.selected;
        }];
        self.headerView.playBtn.selected = !self.headerView.playBtn.selected;
        [self.audioPlayer play];
        isFirstPlay = NO;
    }];
    //音乐播放按钮事件
    [[self.headerView.playBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        @strongify(self);
        if (!x.selected && isFirstPlay) {
            //如果第一次播放 进行播放准备
            [viewModel.audioReadyCmd execute:nil];
            return;
        }else if (!x.selected){
            [self.audioPlayer play];
        }else{
            [self.audioPlayer pause];
        }
        x.selected = !x.selected;
    }];
    
    
    //图片点击事件
    self.headerView.bannerView.clickItemOperationBlock = ^(NSInteger currentIndex){
        ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
        @strongify(self);
        pickerBrowser.photos = [[self.detailInfo.images.rac_sequence map:^id(NSString *value) {
            return [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:[Communtil imageFromlocalpath:value]];
        }] array];
        pickerBrowser.editing = NO;
        pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        [pickerBrowser show];
    };
    RAC(self.headerView.titleLB,text) = RACObserve(self.detailInfo,cn_name);
    RAC(self.headerView.bannerView,imageURLStringsGroup) = [RACObserve(self.detailInfo, images) map:^id(NSArray *value) {
        return [[value.rac_sequence map:^id(NSString *value) {
            return value.cloudPath;
        }] array];
    }];
    [[self.goBackBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self AnimationDismiss];
    }];
    self.viewModel = viewModel;
    [[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
         @strongify(self);
         [self.audioPlayer stop];
    }];
}

- (void)dealloc{
    self.audioPlayer = nil;
}


@end
