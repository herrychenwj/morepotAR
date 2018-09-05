//
//  RootTarBarController.m
//  PRO_TEST
//
//  Created by Mr.Huang on 2017/7/13.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import "RootTarBarController.h"
#import "MLNavigationController.h"
#import "MBProgressHUD+Add.h"
#import "AppDelegate.h"
#import "MuseumModel.h"
#import "FileUtil.h"
#import "ARHomeViewController.h"
#import "LocalJsonManager.h"
#import "EasyARViewController.h"


# define TABBAR_HEIGHT 65
@interface RootTarBarController ()

@end

@implementation RootTarBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    EasyARViewController *arVC = [[EasyARViewController alloc]init];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"localApi" ofType:@"bundle"];
    arVC.resourcePath = [NSString stringWithFormat:@"%@/archive/",bundlePath];
    arVC.view.frame = self.view.bounds;
    [self.view addSubview:arVC.view];
    [self.view sendSubviewToBack:arVC.view];
    self.arVC = arVC;
    self.tabBar.hidden = YES;
    ARHomeViewController *vc = [[ARHomeViewController alloc]initWithMuseumInfo:self.arVC.museum];
    MLNavigationController *nav = [[MLNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)configKuDan:(NSString *)path{
//    //卡主线程  延后0.1秒执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.arVC.resourcePath = path;
    });
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    [Communtil playClickSound];
}

- (BOOL)shouldAutorotate{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}


@end
