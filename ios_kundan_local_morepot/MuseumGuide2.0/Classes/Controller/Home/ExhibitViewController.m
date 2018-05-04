//
//  ExhibitViewController.m
//
//  Created by Mr.Huang on 2017/2/28.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ExhibitViewController.h"
#import "Mp3Player.h"
#import "Communtil.h"
#import "DiscussTableViewCell.h"
#import "ExhibitCommentModel.h"
#import "ExhibitFooterView.h"
#import "ExhibitHeaderView.h"
#import "ExhibitInfoModel.h"
#import "ExhibitToolBar.h"
#import "ExhibitViewModel.h"
#import "MoviePlayViewController.h"
#import "MuItemButton.h"
#import "MuseumInfoTextTableViewCell.h"
#import "NSNumber+Page.h"
#import "ShareViewController.h"
#import "UIButton+SD.h"
#import "WebViewController.h"
#import "ZLPhotoPickerBrowserPhoto.h"
#import "ZLPhotoPickerBrowserViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MJRefresh/MJRefresh.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "UserInfoModel.h"
#import "ExhibitThumbModel.h"
#import "LoginViewController.h"
#import "MBProgressHUD+Add.h"
#import "HomeAdsView.h"
#import "AppDelegate.h"
#import "RewardViewController.h"
#import "DiscoverViewController.h"

#define kAnimationL 14.0

@interface ExhibitViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)ExhibitToolBar *toolBar;
@property (nonatomic,strong)ExhibitHeaderView *headerView;
@property (nonatomic,strong)ExhibitFooterView  *footerView;
@property (nonatomic,strong)MuItemButton *goBackBtn;
@property (nonatomic,strong)MuItemButton *discoverBtn;
@property (nonatomic,strong)MuItemButton *rewardBtn;
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
    if ( [self.museumInfo.museum_id isEqualToString:@"4"] && ![[NSUserDefaults standardUserDefaults]objectForKey:kSHOWREWARD]) {
        AppDelegate *delgate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delgate.arCount += 1;
    }
    if ([self.museumInfo.museum_id isEqualToString:@"40"]) {
        self.rewardBtn.hidden = YES;
    }
    [self.headerView.collectBtn setEnabled:NO];
    [self.headerView.shareBtn setEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *delgate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (![[NSUserDefaults standardUserDefaults]objectForKey:kSHOWREWARD] && delgate.arCount == 6 && [self.museumInfo.museum_id isEqualToString:@"4"] ) {
        [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:kSHOWREWARD];
        RewardViewController *vc = [[RewardViewController alloc]init];
        @weakify(self);
        vc.trackName = self.museumInfo.museum_name;
        vc.rewardSuccess = ^(){
            @strongify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showMessag:[TXSakuraManager tx_stringWithPath:@"rewardsu"] toView:self.view];
            });
        };
        [self presentTransparentController:vc];
    }
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
//    [[[cell.supportBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(UIButton *x) {
//        @strongify(self);
//        [Communtil playClickSound];
//        if (comment.member_comment_id) {
//            [self.viewModel.likeCmtCmd execute:comment.member_comment_id];
//        }
//    }];
//    cell.reload = ^(){
//        @strongify(self);
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.exhibitInfo.name, @"label", [Communtil getCurrentDate], @"datetime",nil];
//        [FileUtil saveTalkingdata:@"展开全文.json" conent:[Communtil DataTOjsonString:dic]];
//
//        [Communtil playClickSound];
//        comment.isOpen = !comment.isOpen;
//        [self.tableView reloadData];
//    };
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
    RAC(self.viewModel,comment) = self.toolBar.contentFD.rac_textSignal;
    //头部标题名称
    RAC(self.headerView.titleLB,text) = RACObserve(self.exhibitInfo, name);
    //副标题名称
    RAC(self.headerView.subLB,text) = RACObserve(self.exhibitInfo, exhibition_name);
    //点赞总数
    RAC(self.footerView.likeBtn.countLB,text) = [RACObserve(self.exhibitInfo,like)map:^id(NSNumber *value) {
        return  ([value integerValue]>0) ? [NSString stringWithFormat:@"%@",value]:@"";
    }];
    RAC(self.viewModel ,exhibit_id) = RACObserve(self.exhibitInfo, exhibit_id);
    RAC(self.headerView.collectBtn,enabled) = self.viewModel .allowCollection;
    self.footerView.likeBtn.rac_command = self.viewModel .likeCmd;
    self.toolBar.submitBtn.rac_command = self.viewModel .cmtCmd;
    //收藏
    [[[[self.headerView.collectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] autoPlaySound] talkingDataTracking:@"收藏" label:self.museumInfo.museum_name params:@{self.exhibitInfo.name?:@"":self.exhibitInfo.name?:@""}]subscribeNext:^(id x) {
        @strongify(self);
        [TalkingData trackEvent:self.museumInfo.museum_name label:@"收藏" parameters:@{self.exhibitInfo.name?:@"":self.exhibitInfo.name?:@""}];
        if (![Communtil isLogin]) {
            LoginViewController *loginVC = [LoginViewController loginControllerWithLoginSuccess:^{
                [self.viewModel .collectCmd execute:nil];
            }];
            [self.navigationController pushViewController:loginVC animated:NO];
            return;
        }
        [self.viewModel .collectCmd execute:nil];
    }];
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
    [[[self.headerView.audioPlayView.languageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] talkingDataTracking:@"播放语音" label:self.exhibitInfo.name?:@"" params:nil]subscribeNext:^(UIButton *x) {
        @strongify(self);
        [self.viewModel.playCmd execute:x.selected?self.exhibitInfo.mandarin.localPath:self.exhibitInfo.dialect.localPath];
        x.selected = !x.selected;
    }];
    //收藏成功
    [self.viewModel.likeCmtCmd.executionSignals.switchToLatest subscribeNext:^(NSString *x) {
      @strongify(self);
      NSArray *tmp = [[self.exhibitInfo.comments.rac_sequence filter:^BOOL(ExhibitCommentModel *value) {
            return [value.member_comment_id isEqualToString:x];
        }]array];
        if (tmp.count > 0) {
            ExhibitCommentModel *model = [tmp firstObject];
            model.like = [NSString stringWithFormat:@"%li",[model.like integerValue]+1];
            model.isCmt = YES;
            [self.tableView reloadData];
        }
    }];

    //评论
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        [TalkingData trackEvent:self.museumInfo.museum_name?:@"云观博" label:@"评论" parameters:@{self.exhibitInfo.name:self.exhibitInfo.name}];
        [TalkingData trackEvent:@"评论" label:self.museumInfo.museum_name?:@"云观博"       parameters:@{self.exhibitInfo.name:self.exhibitInfo.name}];
        [self.viewModel .cmtCmd execute:nil];
    }];
    //评论成功
    [self.viewModel .cmtCmd.executionSignals.switchToLatest subscribeNext:^(NSString *x) {
        @strongify(self);
        [MBProgressHUD showMessag:[TXSakuraManager tx_stringWithPath:@"successful"] toView:self.view];
        self.toolBar.contentFD.text = @"";
        [self.toolBar.contentFD resignFirstResponder];
        self.toolBar.hidden = YES;
        self.toolBar.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 45);
        [self.viewModel .reloadCmtCmd execute:nil];
    }];
    //点赞成功
    [[[self.viewModel.likeCmd.executionSignals.switchToLatest autoPlaySound]talkingDataTracking:@"展品点赞" label:self.museumInfo.museum_name params:@{self.exhibitInfo.name?:@"":self.exhibitInfo.name?:@""}] subscribeNext:^(id x) {
        @strongify(self);
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.exhibitInfo.name,@"label",[Communtil getCurrentDate], @"datetime",nil];
        [FileUtil saveTalkingdata:@"展品点赞.json" conent:[Communtil DataTOjsonString:dic]];
        
        [TalkingData trackEvent:self.museumInfo.museum_name label:@"展品点赞" parameters:@{self.exhibitInfo.name?:@"":self.exhibitInfo.name?:@""}];
        self.exhibitInfo.like = [NSNumber numberWithInteger:[self.exhibitInfo.like integerValue]+1];
        self.footerView.likeBtn.status = YES;
    }];

    //收藏成功
    [self.viewModel.collectCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        self.headerView.collectBtn.enabled = NO;
        [MBProgressHUD showMessag:[TXSakuraManager tx_stringWithPath:@"successfulcollect"] toView:self.view];
    }];
    __block BOOL firstPlay = NO;
    //播放按钮
    [[self.headerView.audioPlayView.playBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *x) {
        @strongify(self);
//        if (!self.exhibitInfo.ispaid) {//支付检测
//            [self pay];
//            return;
//        }
        if (!x.selected) { //第一次播放
            if (!firstPlay) {
                
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[Communtil getCurrentDate], @"datetime",nil];
                [FileUtil saveTalkingdata:@"展品语音.json" conent:[Communtil DataTOjsonString:dic]];
                
//                [TalkingData trackEvent:self.museumInfo.museum_name?:@"云观博" label:@"展品语音" parameters:@{@"普通话":@"普通话"}];
//                [TalkingData trackEvent:@"展品语音" label:self.museumInfo.museum_name?:@"云观博" parameters:@{@"普通话":@"普通话"}];
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
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(NSNotification *x) {
        @strongify(self);
        NSDictionary *info = [x userInfo];
        self.toolBar.hidden = NO;
        self.toolBar.frame = ([[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y != kSCREEN_HEIGHT) ? CGRectMake(0,  - (kSCREEN_HEIGHT - [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y),kSCREEN_WIDTH, kSCREEN_HEIGHT): CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 45);
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
                self.rewardBtn.center = CGPointMake(self.rewardBtn.center.x + kAnimationL*kSCREEN_WIDTH, self.rewardBtn.center.y);
                self.discoverBtn.center = CGPointMake(self.discoverBtn.center.x + kAnimationL*kSCREEN_WIDTH, self.discoverBtn.center.y);
            } completion:nil];
            [UIView animateWithDuration:0.9 delay:0.2 usingSpringWithDamping:0.91 initialSpringVelocity:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.tableView.center = CGPointMake(self.tableView.center.x + kAnimationL*kSCREEN_WIDTH, self.tableView.center.y);
            } completion:^(BOOL finished){
                //刷新UI
                CGFloat viewWidth = IPHONE_DEVICE?(kSCREEN_WIDTH - kINFOCONTROLLERLEFT_MARGIN - kINFOCONTROLLERRIGHT_MARGIN):kSCREEN_WIDTH*0.33;
                CGFloat viewCenterX = IPHONE_DEVICE ? (viewWidth/2+kINFOCONTROLLERLEFT_MARGIN):(kSCREEN_WIDTH-viewWidth/2-90);
                CGFloat tableViewHeight = CGRectGetMinY(self.footerView.frame) - 2*8 - CGRectGetMaxY(self.headerView.frame);
                self.tableViewHeader.frame = self.tableViewHeader.bounds;
                self.tableView.tableHeaderView = self.tableViewHeader;
                self.tableView.center = CGPointMake(viewCenterX, CGRectGetMaxY(self.headerView.frame)+8+tableViewHeight/2+22.5);
                self.tableView.bounds = CGRectMake(0, 0, viewWidth, tableViewHeight+45);
            }];
            [UIView animateWithDuration:1.0 delay:0.3 usingSpringWithDamping:0.91 initialSpringVelocity:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.footerView.center = CGPointMake(self.footerView.center.x + kAnimationL*kSCREEN_WIDTH, self.footerView.center.y);
            } completion:nil];
            showAnimation = YES;
        }
    }];
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self.viewModel.reloadCmtCmd refreshingAction:@selector(execute:)];
//
//    if (self.exhibitInfo.comments.count > 0) {
//        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self.viewModel.moreCmtCmd refreshingAction:@selector(execute:)];
//    }
    
    [[self.viewModel.reloadCmtCmd.executionSignals.switchToLatest talkingDataTracking:@"上拉评论" label:self.museumInfo.museum_name params:@{self.exhibitInfo.name?:@"":self.exhibitInfo.name?:@""}]subscribeNext:^(id x) {
        @strongify(self);
        [TalkingData trackEvent:self.museumInfo.museum_name label:@"上拉评论" parameters:@{self.exhibitInfo.name?:@"":self.exhibitInfo.name?:@""}];
        if (!self.exhibitInfo.comments) {
            self.exhibitInfo.comments = [NSMutableArray array];
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self.viewModel .moreCmtCmd refreshingAction:@selector(execute:)];
        }
        [self.exhibitInfo.comments removeAllObjects];
        [self.exhibitInfo.comments addObjectsFromArray:x];
        [self.tableView reloadData];
    }];
    
    [[self.viewModel.moreCmtCmd.executionSignals.switchToLatest talkingDataTracking:@"上拉评论"  label:self.museumInfo.museum_name params:@{self.exhibitInfo.name?:@"":self.exhibitInfo.name?:@""}] subscribeNext:^(id x) {
        @strongify(self);
        [TalkingData trackEvent:self.museumInfo.museum_name label:@"上拉评论"  parameters:@{self.exhibitInfo.name?:@"":self.exhibitInfo.name?:@""}];
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
    [[self.toolBar.blankControl rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
    [[self.goBackBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
//        self.adsView.hidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [[self.discoverBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [TalkingData trackEvent:@"寻宝"];
        DiscoverViewController *vc = [[DiscoverViewController alloc]init];
        vc.museumInfo = self.museumInfo;
        vc.goodsAry = self.goodsAry;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [[self.rewardBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        //打赏
        [TalkingData trackEvent:@"打赏"];
        RewardViewController *vc = [[RewardViewController alloc]init];
        @weakify(self);
        vc.trackName = self.museumInfo.museum_name;
        vc.rewardSuccess = ^(){
            @strongify(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD showMessag:[TXSakuraManager tx_stringWithPath:@"rewardsu"] toView:self.view];
            });
        };
        [self presentTransparentController:vc];
    }];
    [[self.footerView.commentBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        //弹出键盘
        @strongify(self);
        self.toolBar.contentFD.text = @"";
        [self.toolBar.contentFD becomeFirstResponder];
    }];
    
    [[[self.footerView.topBtn rac_signalForControlEvents:UIControlEventTouchUpInside] autoPlaySound]subscribeNext:^(UIButton *x) {
        @strongify(self);
        [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
    }];
    
    //3D按钮点击事件
    [[[[self.headerView.D3Btn rac_signalForControlEvents:UIControlEventTouchUpInside] autoPlaySound] talkingDataTracking:@"展品3D" label:self.exhibitInfo.name params:nil]subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.exhibitInfo.name,@"label",[Communtil getCurrentDate], @"datetime",nil];
        [FileUtil saveTalkingdata:@"展品3D.json" conent:[Communtil DataTOjsonString:dic]];
        
        WebViewController *vc = [WebViewController webControllerWithHtml:self.exhibitInfo.exhibit_id];
        [[vc rac_signalForSelector:@selector(viewWillAppear:)]subscribeNext:^(id x) {
            @strongify(self);
           self.discoverBtn.hidden = self.rewardBtn.hidden = self.goBackBtn.hidden = self.headerView.hidden = self.tableView.hidden = self.footerView.hidden = YES;
        }];
        [[vc rac_signalForSelector:@selector(viewWillDisappear:)]subscribeNext:^(id x) {
            @strongify(self);
            self.discoverBtn.hidden = self.rewardBtn.hidden = self.goBackBtn.hidden = self.headerView.hidden = self.tableView.hidden = self.footerView.hidden = NO;        }];
        vc.skipType = VCSkipTypePresent;
        vc.D3 = YES;
        [self presentTransparentController:vc];
    }];
    //广告关闭按钮事件
//    [[self.adsView.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
//        @strongify(self);
//        [self.navigationController popViewControllerAnimated:NO];
//    }];
    
    //进度条滑动事件
    [[self.headerView.audioPlayView.slider rac_signalForControlEvents:UIControlEventValueChanged]subscribeNext:^(UISlider *x) {
        @strongify(self);
        self.audioPlayer.currentTime = x.value * self.audioPlayer.duration;
    }];
    
    //分享按钮点击事件
    [[[self.headerView.shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] autoPlaySound]subscribeNext:^(id x) {
        @strongify(self);
        NSString *shareImg = self.exhibitInfo.images.count>0?[self.exhibitInfo.images firstObject] : nil;
        UIImage *shareSimage;
        if ([shareImg hasSuffix:@"webp"]) {
            ExhibitThumbImageCell *cell = (ExhibitThumbImageCell *)[self.headerView.autoScrollView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            shareSimage = cell.thumbImgView.image;
        }
        UMShareWebpageObject *obj = [UMShareWebpageObject shareObjectWithTitle:self.exhibitInfo.name?:@"" descr:self.exhibitInfo.mDescription?:@"" thumImage:shareSimage?:shareImg.cloudPath];
        obj.webpageUrl = self.exhibitInfo.share_url.cloudPath;
        ShareViewController *vc = [ShareViewController shareWithObject:obj];
        vc.trackLabel = self.exhibitInfo.name;
        vc.shareObjType = @"展品";
        [self presentTransparentController:vc animated:YES];
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
        [TalkingData trackEvent:@"展品视频"  label:self.exhibitInfo.name];
        
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

   
//    [self.viewModel.exhibitInfoCmd.executionSignals.switchToLatest subscribeNext:^(ExhibitInfoModel *x) {
//        @strongify(self);
//        self.exhibitInfo.ispaid = x.ispaid;
////        if (!self.exhibitInfo.ispaid) {
////            [self pay];
////        }
//    }];
    
//    [self.adsView.adsImgView sd_setImageWithURL:[NSURL URLWithString:@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=757533107,1157858375&fm=27&gp=0.jpg"]];
//    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]init];
//    [self.adsView addGestureRecognizer:tapG];
//    [[tapG rac_gestureSignal] subscribeNext:^(id x) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://item.taobao.com/item.htm?spm=a21bt.10222149.854198.7.51eee96fIAPQ1H&id=555598691480"]];
//    }];
    
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
//    if (self.goodsAry.count > 0) {
//        _discoverBtn = ({
//            MuItemButton *goBackBtn = [[MuItemButton alloc]initWithFrame:CGRectZero];
//            goBackBtn.bounds = CGRectMake(0, 0, IPHONE_DEVICE?50:60,  IPHONE_DEVICE?60:82);
//            goBackBtn.center = CGPointMake((IPHONE_DEVICE?22:70) - kAnimationL*kSCREEN_WIDTH, kSCREEN_HEIGHT/2-85);
//            goBackBtn.itemLB.sakura.text(@"discover");
//            goBackBtn.itemIcon.image = [UIImage imageNamed:@"discover"];
//            [self.view addSubview:goBackBtn];
//            goBackBtn;
//        });
//    }

    
    _goBackBtn = ({
        MuItemButton *goBackBtn = [[MuItemButton alloc]initWithFrame:CGRectZero];
        goBackBtn.bounds = CGRectMake(0, 0, IPHONE_DEVICE?50:60,  IPHONE_DEVICE?60:82);
        goBackBtn.center = CGPointMake((IPHONE_DEVICE?22:70) - kAnimationL*kSCREEN_WIDTH, kSCREEN_HEIGHT/2);
        goBackBtn.itemLB.sakura.text(@"back");
        goBackBtn.itemIcon.image = [UIImage imageNamed:@"back"];
        [self.view addSubview:goBackBtn];
        goBackBtn;
    });
//    _rewardBtn = ({
//        MuItemButton *goBackBtn = [[MuItemButton alloc]initWithFrame:CGRectZero];
//        goBackBtn.bounds = CGRectMake(0, 0, IPHONE_DEVICE?50:60,  IPHONE_DEVICE?60:82);
//        goBackBtn.center = CGPointMake((IPHONE_DEVICE?22:70) - kAnimationL*kSCREEN_WIDTH, kSCREEN_HEIGHT/2+85);
//        goBackBtn.itemLB.sakura.text(@"dashang");
//        goBackBtn.itemIcon.image = [UIImage imageNamed:@"reward"];
//        [self.view addSubview:goBackBtn];
//        goBackBtn;
//    });
    _footerView = ({
        ExhibitFooterView *footer = [[ExhibitFooterView alloc]initWithFrame:CGRectZero];
        footer.center = CGPointMake(viewCenterX - kAnimationL*kSCREEN_WIDTH, kSCREEN_HEIGHT  -12 - 45.0/2);
        footer.bounds = CGRectMake(0, 0, viewWidth, 45);
        [self.view addSubview:footer];
        footer;
    });
    [_footerView setHidden:YES];
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
        CGFloat tableViewHeight = CGRectGetMinY(self.footerView.frame) - 8 - CGRectGetMaxY(self.tableViewHeader.frame);
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
    _toolBar = ({
        ExhibitToolBar  *toolBar = [[ExhibitToolBar alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        toolBar.contentFD.delegate = self;
        [self.view addSubview:toolBar];
        toolBar;
    });
    @weakify(self);
    self.tableViewHeader.reload = ^(){
        @strongify(self);
        [TalkingData trackEvent:self.museumInfo.museum_name label:@"展开全文" parameters:@{self.exhibitInfo.name:self.exhibitInfo.name}];
        [TalkingData trackEvent:@"展开全文" label:self.museumInfo.museum_name parameters:@{self.exhibitInfo.name:self.exhibitInfo.name}];

        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.exhibitInfo.name,@"label",[Communtil getCurrentDate], @"datetime",nil];
        [FileUtil saveTalkingdata:@"展开全文.json" conent:[Communtil DataTOjsonString:dic]];
        
        
        self.exhibitInfo.isDescOpen = !self.exhibitInfo.isDescOpen;
        self.tableViewHeader.center = CGPointMake(viewCenterX, CGRectGetMaxY(self.headerView.frame)+8+([self.exhibitInfo cellHeight]+26)/2);
        self.tableViewHeader.bounds = CGRectMake(0, 0, viewWidth, [self.exhibitInfo cellHeight]+26);
        self.tableViewHeader.closeBtn.hidden = !self.exhibitInfo.isDescOpen;
        self.tableView.tableHeaderView = nil;
        self.tableView.tableHeaderView = self.tableViewHeader;
    };
    
//    _adsView = ({
//        HomeAdsView *adsV =  [[HomeAdsView alloc]initWithFrame:CGRectZero];
//        adsV.hidden = YES;
//
//        [self.view addSubview:adsV];
//        adsV;
//    });
//    [self.adsView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
}


- (void)showPhotosWitnIndex:(NSInteger)index{
//    if (!self.exhibitInfo.ispaid) { //是否支付检测
//        [self pay];
//        return;
//    }
    if (self.exhibitInfo.images && self.exhibitInfo.images.count > 0 ) {
        [TalkingData trackEvent:@"查看大图" label:self.exhibitInfo.name?:@""];
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




//- (void)pay{
//    @weakify(self);
//    PayViewController *payVC = [[PayViewController alloc]initWithMuseum:self.museumInfo];
//    payVC.trackName = self.exhibitInfo.name;
//    payVC.completeBlock = ^(){
//        @strongify(self);
//        self.exhibitInfo.ispaid = YES;
//        if (self.refreshData) {
//            self.refreshData();
//        }
//    };
//    payVC.loginBlock = ^(){
//        @strongify(self);
//        LoginViewController *loginVC = [LoginViewController loginControllerWithLoginSuccess:^(){
//            //重新拉取是否支付
//            @strongify(self);
//            [self.viewModel.exhibitInfoCmd execute:self.exhibitInfo.exhibit_id];
//        }];
//        [self.navigationController pushViewController:loginVC animated:YES];
//    };
//    [self presentTransparentController:payVC];
//}




- (void)dealloc{
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}


@end
