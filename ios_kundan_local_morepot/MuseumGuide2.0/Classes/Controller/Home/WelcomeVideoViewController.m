//
//  WelcomeVideoViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/5/26.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "WelcomeVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "MuItemButton.h"

@interface WelcomeVideoViewController ()
@property (nonatomic,strong)MuItemButton *goBackBtn;
@property (nonatomic,strong)AVPlayer *avplayer;
@end

@implementation WelcomeVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupVideo];
    @weakify(self);
    _goBackBtn = ({
        MuItemButton *goBackBtn = [[MuItemButton alloc]initWithFrame:CGRectZero];
        goBackBtn.itemIcon.image = [UIImage imageNamed:@"back"];
        goBackBtn.itemLB.sakura.text(@"back");
        goBackBtn.hidden = [Communtil app_welcome];
        [self.view addSubview:goBackBtn];
        goBackBtn;
    });
    [self.goBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(IPHONE_DEVICE?@50:@60);
        make.height.equalTo(IPHONE_DEVICE?@60:@82);
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).offset(IPHONE_DEVICE?0:43);
    }];
    [[self.goBackBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if ([Communtil app_welcome] && IPHONE_DEVICE) {
            [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:kAPPLICARION_WELCOME];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setupVideo{
    _avplayer = ({
        NSString *path = [[NSBundle mainBundle]pathForResource:@"0562" ofType:@"mp4"];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
        AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
        player;
    });

    AVPlayerLayer *showVodioLayer = [AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    showVodioLayer.frame = self.view.frame;
    showVodioLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:showVodioLayer];
    [self.avplayer play];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:nil]subscribeNext:^(id x) {
        @strongify(self);
        if ([Communtil app_welcome] && IPHONE_DEVICE) {
            [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:kAPPLICARION_WELCOME];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [[self rac_signalForSelector:@selector(viewWillDisappear:)]subscribeNext:^(id x) {
        @strongify(self);
        [self.avplayer pause];
        self.avplayer = nil;
        if ([Communtil app_welcome] && IPHONE_DEVICE) {
            [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:kAPPLICARION_WELCOME];
        }
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
