//
//  ExhibitViewController.m
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ExhibitViewController.h"
#import "Mp3Player.h"
#import "DiscussTableViewCell.h"
#import "ExhibitCommentModel.h"
#import "ExhibitHeaderView.h"
#import "ExhibitInfoModel.h"
#import "ExhibitViewModel.h"
#import "MoviePlayViewController.h"
#import "MuItemButton.h"
#import "MuseumInfoTextTableViewCell.h"
#import "NSNumber+Page.h"
#import "WebViewController.h"
#import "ZLPhotoPickerBrowserPhoto.h"
#import "ZLPhotoPickerBrowserViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "ExhibitThumbModel.h"
#import "AppDelegate.h"

#define kAnimationL 14.0

@interface ExhibitViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)ExhibitHeaderView *headerView;
@property (nonatomic,strong)MuItemButton *goBackBtn;
@property (nonatomic,strong)ExhibitViewModel *viewModel;
@property (nonatomic,strong)MuseumInfoTextTableViewCell *tableViewHeader;
@property(nonatomic,strong)Mp3Player *audioPlayer;

//@property (nonatomic,strong)HomeAdsView *adsView;

@end
static NSString *const cellID = @"MuseumInfoTextTableViewCell";
static NSString *const discussCellID = @"DiscussTableViewCell";

@implementation ExhibitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.headerView.collectBtn setEnabled:NO];
    [self.headerView.shareBtn setEnabled:NO];
}


#pragma mark init
+ (ExhibitViewController *)exhibitControllerWithInfo:(ExhibitInfoModel *)exhibitInfo museumInfo:(MuseumModel *)museumInfo{
    ExhibitViewController *vc = [[ExhibitViewController alloc]initWithExhibitInfo:exhibitInfo];
    vc.museumInfo = museumInfo;
    return vc;
}
+ (ExhibitViewController *)exhibitControllerWithInfo:(ExhibitInfoModel *)exhibitInfo{
    ExhibitViewController *vc = [[ExhibitViewController alloc]initWithExhibitInfo:exhibitInfo];
    return vc;
}
- (instancetype)initWithExhibitInfo:(ExhibitInfoModel *)exhibitInfo{
    if (self = [super init]) {
        self.exhibitInfo = exhibitInfo;
    }
    return self;
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.exhibitInfo.comments.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    DiscussTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:discussCellID forIndexPath:indexPath];
    ExhibitCommentModel *comment = [self.exhibitInfo.comments objectAtIndex:indexPath.section ];
    comment.isOpen = YES;
    [cell setComment:comment];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExhibitCommentModel *comment = [self.exhibitInfo.comments objectAtIndex:indexPath.section ];
    return comment.cellHeight;
}

- (void)bindViewModel{
    @weakify(self);
    self.viewModel = [[ExhibitViewModel alloc]initWithHUDShowView:self.view];
    RAC(self.viewModel,basicInfo) = RACObserve(self, museumInfo);
    //头部标题名称
    RAC(self.headerView.titleLB,text) = RACObserve(self.exhibitInfo, name);
    //副标题名称
    RAC(self.headerView.subLB,text) = RACObserve(self.exhibitInfo, exhibition_name);
    RAC(self.viewModel ,exhibit_id) = RACObserve(self.exhibitInfo, exhibit_id);
    RAC(self.headerView.collectBtn,enabled) = self.viewModel .allowCollection;
    
    RAC(self.headerView.D3Btn,enabled) = [RACObserve(self.exhibitInfo, _3d_url) map:^id(NSString *value) {
        return @(value.length > 0);
    }];
    
    //是否可收藏
    RAC(self.viewModel ,canCollect) = [RACObserve(self.exhibitInfo, is_favorited) map:^id(NSNumber *value) {
        return @(![value boolValue]);
    }];

    //方言按钮隐藏绑定
    RAC(self.headerView.audioPlayView,dialectShow) = [RACObserve(self.exhibitInfo, dialect) map:^id(NSString *value) {
        return @(value && value.length > 0);
    }];
    //方言按钮点击
    [[self.headerView.audioPlayView.languageBtn rac_signalForControlEvents:UIControlEventTouchUpInside]  subscribeNext:^(UIButton *x) {
        @strongify(self);
        [self.viewModel.playCmd execute:x.selected?self.exhibitInfo.mandarin.localPath:self.exhibitInfo.dialect.localPath];
        x.selected = !x.selected;
    }];

    __block BOOL firstPlay = NO;
    //播放按钮
    [[self.headerView.audioPlayView.playBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
        @strongify(self);
        if (!x.selected) { //第一次播放
            if (!firstPlay) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[Communtil getCurrentDate], @"datetime",nil];
                [FileUtil saveTalkingdata:@"展品语音.json" conent:[Communtil DataTOjsonString:dic]];
                
                [self.viewModel.playCmd execute:self.exhibitInfo.mandarin.localPath];
            }
            [self playAudio];
        }else{
            [self pauseAudio];
        }
    }];
    
    //切换歌曲
    [self.viewModel.playCmd.executionSignals.switchToLatest subscribeNext:^(NSString *x) {
        @strongify(self);
        [self changeMusic:x];
        [self playAudio];
        if (!firstPlay) {
            [self pauseAudio];
        }
        firstPlay = YES;
    }];
    __block BOOL showAnimation = NO;
    [[self rac_signalForSelector:@selector(viewWillAppear:)]subscribeNext:^(id x) {
          @strongify(self);
        if (!showAnimation) {
            [UIView animateWithDuration:0.9 delay:0.0 usingSpringWithDamping:0.91 initialSpringVelocity:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.headerView.center = CGPointMake(self.headerView.center.x - kAnimationL*kSCREEN_WIDTH, self.headerView.center.y);
            } completion:nil];
            [UIView animateWithDuration:0.9 delay:0.1 usingSpringWithDamping:0.91 initialSpringVelocity:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.tableViewHeader.center = CGPointMake(self.tableViewHeader.center.x + kAnimationL*kSCREEN_WIDTH, self.tableViewHeader.center.y);
            } completion:nil];
            [UIView animateWithDuration:0.9 delay:0.1 usingSpringWithDamping:0.91 initialSpringVelocity:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.goBackBtn.center = CGPointMake(self.goBackBtn.center.x + kAnimationL*kSCREEN_WIDTH, self.goBackBtn.center.y);
            } completion:nil];
            [UIView animateWithDuration:0.9 delay:0.2 usingSpringWithDamping:0.91 initialSpringVelocity:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.tableView.center = CGPointMake(self.tableView.center.x + kAnimationL*kSCREEN_WIDTH, self.tableView.center.y);
            } completion:^(BOOL finished){
                //刷新UI
                CGFloat viewWidth = IPHONE_DEVICE?(kSCREEN_WIDTH - kINFOCONTROLLERLEFT_MARGIN - kINFOCONTROLLERRIGHT_MARGIN):kSCREEN_WIDTH*0.33;
                CGFloat viewCenterX = IPHONE_DEVICE ? (viewWidth/2+kINFOCONTROLLERLEFT_MARGIN):(kSCREEN_WIDTH-viewWidth/2-90);
                CGFloat tableViewHeight = kSCREEN_HEIGHT- 40 - 2*8 - CGRectGetMaxY(self.headerView.frame);
                self.tableViewHeader.frame = self.tableViewHeader.bounds;
                self.tableView.tableHeaderView = self.tableViewHeader;
                self.tableView.center = CGPointMake(viewCenterX, CGRectGetMaxY(self.headerView.frame)+8+tableViewHeight/2+22.5);
                self.tableView.bounds = CGRectMake(0, 0, viewWidth, tableViewHeight+45);
            }];
            showAnimation = YES;
        }
    }];
    
    
    [self.viewModel.reloadCmtCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        if (!self.exhibitInfo.comments) {
            self.exhibitInfo.comments = [NSMutableArray array];
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self.viewModel .moreCmtCmd refreshingAction:@selector(execute:)];
        }
        [self.exhibitInfo.comments removeAllObjects];
        [self.exhibitInfo.comments addObjectsFromArray:x];
        [self.tableView reloadData];
    }];
    
    [self.viewModel.moreCmtCmd.executionSignals.switchToLatest  subscribeNext:^(id x) {
        @strongify(self);
        if (!x) {return;}
        [self.exhibitInfo.comments addObjectsFromArray:x];
        [self.tableView reloadData];
    }];
    self.headerView.audioPlayView.allTimeLB.text = [Communtil stringWithTime:[Communtil durationWithAudio:self.exhibitInfo.mandarin.cloudPath]];
    self.headerView.audioPlayView.enabled = (self.exhibitInfo.mandarin.length > 0);
    
    [[self rac_signalForSelector:@selector(viewWillDisappear:)]subscribeNext:^(id x) {
        @strongify(self);
        [self pauseAudio];
    }];
    
    self.audioPlayer = [[Mp3Player alloc]init];
    [[self.goBackBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
//        self.adsView.hidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    

    
    //3D按钮点击事件
    [[[self.headerView.D3Btn rac_signalForControlEvents:UIControlEventTouchUpInside] autoPlaySound] subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.exhibitInfo.name,@"label",[Communtil getCurrentDate], @"datetime",nil];
        [FileUtil saveTalkingdata:@"展品3D.json" conent:[Communtil DataTOjsonString:dic]];
        
        WebViewController *vc = [WebViewController webControllerWithHtml:self.exhibitInfo.exhibit_id];
        [[vc rac_signalForSelector:@selector(viewWillAppear:)]subscribeNext:^(id x) {
            @strongify(self);
            self.goBackBtn.hidden = self.headerView.hidden = self.tableView.hidden =  YES;
        }];
        [[vc rac_signalForSelector:@selector(viewWillDisappear:)]subscribeNext:^(id x) {
            @strongify(self);
            self.goBackBtn.hidden = self.headerView.hidden = self.tableView.hidden =  NO;
        }];
        vc.skipType = VCSkipTypePresent;
        vc.D3 = YES;
        [self presentTransparentController:vc];
    }];
    
    //进度条滑动事件
    [[self.headerView.audioPlayView.slider rac_signalForControlEvents:UIControlEventValueChanged]subscribeNext:^(UISlider *x) {
        @strongify(self);
        self.audioPlayer.currentTime = x.value * self.audioPlayer.duration;
    }];
    
    NSMutableArray *tmp = [NSMutableArray array];
    if (self.exhibitInfo.video.videourl&&self.exhibitInfo.video.videourl.length > 0) { //如果有视频 显示视频地址
        ExhibitThumbModel *thumb = [[ExhibitThumbModel alloc]init];
        thumb.thumbUrl = self.exhibitInfo.video.img;
        thumb.moiveMode = YES;
        [tmp addObject:thumb];
    }
    [tmp addObjectsFromArray:[[self.exhibitInfo.images.rac_sequence map:^id(NSString  *value) {
        ExhibitThumbModel *model = [[ExhibitThumbModel alloc]init];
        model.thumbUrl = value;
        return model;
    }] array]];
    self.headerView.thumbImgAry = [tmp copy];
    self.headerView.selectIndexAt = ^(ExhibitThumbModel *model, NSInteger index){
        @strongify(self);
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.exhibitInfo.name,@"label",[Communtil getCurrentDate], @"datetime",nil];
        [FileUtil saveTalkingdata:@"展开视频.json" conent:[Communtil DataTOjsonString:dic]];
        
        if (model.moiveMode) { //点了视屏
            MoviePlayViewController *vc =  [MoviePlayViewController moviePlayerWithVideoUrl:[NSString stringWithFormat:@"local_api/%@",self.exhibitInfo.video.videourl]];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self showPhotosWitnIndex:index];
        }
    };
    [self.viewModel.playCmd execute:self.exhibitInfo.mandarin.localPath];

    
}


#pragma mark initUI
- (void)initUI{
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    CGFloat viewWidth = IPHONE_DEVICE?(kSCREEN_WIDTH - kINFOCONTROLLERLEFT_MARGIN - kINFOCONTROLLERRIGHT_MARGIN):kSCREEN_WIDTH*0.33;
    CGFloat viewCenterX = IPHONE_DEVICE ? (viewWidth/2+kINFOCONTROLLERLEFT_MARGIN):(kSCREEN_WIDTH-viewWidth/2-90);
    _headerView = ({
        ExhibitHeaderView *headerView = [[ExhibitHeaderView alloc]initWithFrame:CGRectZero];
        headerView.bounds = CGRectMake(0, 0, viewWidth+kINFOCONTROLLERRIGHT_MARGIN,viewWidth*0.6);
        headerView.center = CGPointMake(viewCenterX+20/2 + kAnimationL*kSCREEN_WIDTH, (IPHONEX_DEVICE?20:0)+20+(viewWidth*0.6)/2);
        [self.view addSubview:headerView];
        headerView;
    });
    
    _goBackBtn = ({
        MuItemButton *goBackBtn = [[MuItemButton alloc]initWithFrame:CGRectZero];
        goBackBtn.bounds = CGRectMake(0, 0, IPHONE_DEVICE?50:60,  IPHONE_DEVICE?60:82);
        goBackBtn.center = CGPointMake((IPHONE_DEVICE?22:70) - kAnimationL*kSCREEN_WIDTH, kSCREEN_HEIGHT/2);
        goBackBtn.itemLB.sakura.text(@"back");
        goBackBtn.itemIcon.image = [UIImage imageNamed:@"back"];
        [self.view addSubview:goBackBtn];
        goBackBtn;
    });
    
    _tableViewHeader = ({
        MuseumInfoTextTableViewCell * tableViewHeader = [[MuseumInfoTextTableViewCell alloc]initWithFrame:CGRectZero];
        tableViewHeader.center = CGPointMake(viewCenterX+ - kAnimationL*kSCREEN_WIDTH,CGRectGetMaxY(self.headerView.frame)+8+([self.exhibitInfo cellHeight]+26)/2);
        tableViewHeader.bounds = CGRectMake(0, 0, viewWidth, [self.exhibitInfo cellHeight]+26);
        tableViewHeader.contentLB.attributedText = self.exhibitInfo.attrDescription;
        [self.view addSubview:tableViewHeader];
        tableViewHeader;
    });
    
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        CGFloat tableViewHeight = kSCREEN_HEIGHT - 40- 8 - CGRectGetMaxY(self.tableViewHeader.frame);
        tableView.center = CGPointMake(viewCenterX - kAnimationL*kSCREEN_WIDTH, CGRectGetMaxY(self.tableViewHeader.frame)+tableViewHeight/2+22.5);
        tableView.bounds = CGRectMake(0, 0, viewWidth, tableViewHeight+45);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        [tableView registerClass:[DiscussTableViewCell class] forCellReuseIdentifier:discussCellID];
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView;
    });
    @weakify(self);
    self.tableViewHeader.reload = ^(){
        @strongify(self);
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.exhibitInfo.name,@"label",[Communtil getCurrentDate], @"datetime",nil];
        [FileUtil saveTalkingdata:@"展开全文.json" conent:[Communtil DataTOjsonString:dic]];
        
        
        self.exhibitInfo.isDescOpen = !self.exhibitInfo.isDescOpen;
        self.tableViewHeader.center = CGPointMake(viewCenterX, CGRectGetMaxY(self.headerView.frame)+8+([self.exhibitInfo cellHeight]+26)/2);
        self.tableViewHeader.bounds = CGRectMake(0, 0, viewWidth, [self.exhibitInfo cellHeight]+26);
        self.tableViewHeader.closeBtn.hidden = !self.exhibitInfo.isDescOpen;
        self.tableView.tableHeaderView = nil;
        self.tableView.tableHeaderView = self.tableViewHeader;
    };
}


- (void)showPhotosWitnIndex:(NSInteger)index{
    if (self.exhibitInfo.images && self.exhibitInfo.images.count > 0 ) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.exhibitInfo.name,@"label",[Communtil getCurrentDate], @"datetime",nil];
        [FileUtil saveTalkingdata:@"查看大图.json" conent:[Communtil DataTOjsonString:dic]];
        ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
        pickerBrowser.photos = [[self.exhibitInfo.images.rac_sequence map:^id(NSString *value) {
            return [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:[Communtil imageFromlocalpath:value.highPicturePath]];
        }]array];
        pickerBrowser.editing = NO;
        pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [pickerBrowser show];
    }
}

- (void)changeMusic:(NSString *)path{
    @weakify(self);
    [self.audioPlayer playAudioWithFilePath:path progress:^(float progress, NSTimeInterval currentTime) {
        @strongify(self);
        self.headerView.audioPlayView.slider.value = progress;
        self.headerView.audioPlayView.timeLB.text = [Communtil stringWithTime:currentTime];
    } didComplete:^(){
        @strongify(self);
        self.headerView.audioPlayView.slider.value = 0.0;
        self.audioPlayer.currentTime = 0.0;
        self.headerView.audioPlayView.playBtn.selected = NO;
    }];
    //设置mp3事件长度
    self.headerView.audioPlayView.allTimeLB.text = [Communtil stringWithTime:self.audioPlayer.duration];
}

- (void)playAudio{
    [self.audioPlayer play];
    self.headerView.audioPlayView.playBtn.selected = YES;
}

- (void)pauseAudio{
    [self.audioPlayer pause];
    self.headerView.audioPlayView.playBtn.selected = NO;
}


- (void)dealloc{
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}


@end
