//
//  MoviePlayViewController.m
//  Mp3Player
//
//  Created by Mr.Huang on 2017/3/8.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MoviePlayViewController.h"
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Communtil.h"
#import "ZFPlayer.h"
#import "AppDelegate.h"
#import "LocalJsonManager.h"

@interface MoviePlayViewController ()<ZFPlayerDelegate>
@property (strong, nonatomic) ZFPlayerView *playerView;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic,strong)UIView *playerbackground;
@end

@implementation MoviePlayViewController

+ (MoviePlayViewController *)moviePlayerWithVideoUrl:(NSString *)url{
    MoviePlayViewController *vc = [[MoviePlayViewController alloc]init];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *fileUrls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
//    NSURL *documentsURL = fileUrls[0];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"localApi" ofType:@"bundle"];
    NSString *expathPath = [NSString stringWithFormat:@"%@/%@",bundlePath,url];
    NSURL *dc = [NSURL fileURLWithPath:expathPath];
    vc.videoURL = dc;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.playerView autoPlayTheVideo];
    [self.playerView _fullScreenAction];
    @weakify(self);
    self.playerView.didFinished = ^(){
        @strongify(self);
        [self.navigationController popViewControllerAnimated:NO];
    };
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView pause];
}


#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
     [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Lazy load

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.videoURL         = self.videoURL;
        _playerModel.placeholderImage = [Communtil createImageWithColor:[UIColor blackColor]];
        _playerModel.fatherView       = self.playerbackground;
    }
    return _playerModel;
}


- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        [_playerView playerControlView:nil playerModel:self.playerModel];
        _playerView.delegate = self;
    }
    return _playerView;
}


- (UIView *)playerbackground{
    if (!_playerbackground) {
        _playerbackground = [[UIView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_playerbackground];
    }
    return _playerbackground;
}



@end


