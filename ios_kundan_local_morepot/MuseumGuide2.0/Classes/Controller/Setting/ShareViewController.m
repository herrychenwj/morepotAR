//
//  ShareViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareCollectionViewCell.h"


@interface ShareViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UIControl *blankControl;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *itemArray;

@end
static NSString *const cellID = @"ShareCollectionViewCell";
@implementation ShareViewController

+ (ShareViewController *)shareWithObject:(UMShareWebpageObject *)shareObj{
    ShareViewController *vc = [[ShareViewController alloc]init];
    if (shareObj.descr.length >= 30) {
        shareObj.descr = [shareObj.descr substringToIndex:30];
    }
    vc.shareObject = shareObj;
    return vc;
}

#pragma mark UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSDictionary *dic = [self.itemArray objectAtIndex:indexPath.row];
    cell.itemTitleLB.sakura.text([dic objectForKey:@"title"]);
    cell.itemImg.image = [UIImage imageNamed:[dic objectForKey:@"icon"]];
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 32, 0, 32);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return (kSCREEN_WIDTH - 3*80)/4;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    UMSocialPlatformType type;
    switch (indexPath.row) {
        case 0:
            type = UMSocialPlatformType_WechatTimeLine;
            break;
        case 1:
            type = UMSocialPlatformType_WechatSession;
            break;
        case 2:
            type = UMSocialPlatformType_Sina;
            break;
        case 3:
            type = UMSocialPlatformType_Qzone;
            break;
        case 4:
            type = UMSocialPlatformType_QQ;
            break;
        default:
            type = UMSocialPlatformType_WechatTimeLine;
            break;
    }

    [self shareWebPageToPlatformType:type];
    
}


#pragma mark initUI
- (void)initUI{
    @weakify(self);
    self.view.backgroundColor = [UIColor blackColor];
    _blankControl = ({
        UIControl *cl = [[UIControl alloc]initWithFrame:CGRectZero];
        cl.backgroundColor = HexRGBAlpha(0x000000, 0.4);
        [[cl rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            @strongify(self);
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
        [self.view addSubview:cl];
        cl;
    });
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(80, 100);
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = HexRGBAlpha(0x202126, 0.8);
        [collectionView registerClass:[ShareCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self.view addSubview:collectionView];
        collectionView;
    });
    if (IPAD_DEVICE) {
        UIControl *blank = [[UIControl alloc]initWithFrame:CGRectZero];
        blank.backgroundColor = HexRGBAlpha(0x000000, 0.8);
        [[blank rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
        [self.view addSubview:blank];
        [blank mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.collectionView.mas_left);
            make.top.bottom.equalTo(self.collectionView);
        }];
    }
    
    
    [self.blankControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.collectionView.mas_top);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IPHONE_DEVICE) {
            make.left.right.bottom.equalTo(self.view);
        }else{
            make.left.equalTo(self.view).offset(kPADSETTING_LEFTMARGIN);
            make.right.equalTo(self.view).offset(90);
            make.bottom.equalTo(self.view);
        }
        make.height.equalTo(@250);
    }];
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType{
    if (!self.shareObject) return;
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = self.shareObject;
    //调用分享接口
    NSString *trackName;
    switch (platformType) {
        case UMSocialPlatformType_WechatTimeLine:
            trackName = @"微信朋友圈分享";
            break;
        case UMSocialPlatformType_WechatSession:
            trackName = @"微信好友分享";
            break;
        case UMSocialPlatformType_Sina:
            trackName = @"新浪分享";
            break;
        case UMSocialPlatformType_Qzone:
            trackName = @"QQ空间分享";
            break;
        case UMSocialPlatformType_QQ:
            trackName = @"QQ分享";
            break;
        default:
            break;
    }
    if (self.shareObject && self.trackLabel && [self.shareObjType isEqualToString:@"展品"]) {
        [TalkingData trackEvent:self.museum.museum_name?:@"云观博"  label:trackName parameters:@{self.trackLabel:self.trackLabel}];
        [TalkingData trackEvent:trackName  label:self.museum.museum_name?:@"云观博" parameters:@{self.trackLabel:self.trackLabel}];

    }
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (!error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

//"weichat":"微信朋友圈",
//"wei":"微信",
//"sina":"新浪微博",
//"QQspace":"QQ空间",
//"QQ":"QQ",
#pragma mark lazy load
- (NSArray *)itemArray{
    if (!_itemArray) {
        _itemArray = @[@{@"title":@"weichat",@"icon":@"weixinpy"},@{@"title":@"wei",@"icon":@"weixin"},@{@"title":@"sina",@"icon":@"sina"},@{@"title":@"QQspace",@"icon":@"qqkj"},@{@"title":@"QQ",@"icon":@"qqshare"}];
    }
    return _itemArray;
}





@end
