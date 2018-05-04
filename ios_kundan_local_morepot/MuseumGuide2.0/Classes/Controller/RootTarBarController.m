//
//  RootTarBarController.m
//  PRO_TEST
//
//  Created by Mr.Huang on 2017/7/13.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import "RootTarBarController.h"
#import "UserCenterViewController.h"
#import "StoreViewController.h"
#import "RootViewController.h"
#import "MLNavigationController.h"
#import "MBProgressHUD+Add.h"
#import "AppDelegate.h"
#import "MuseumModel.h"
#import "FileUtil.h"
#import "RootTabBar.h"
#import "ARHomeViewController.h"
#import "LocalARManager.h"
#import "LocalJsonManager.h"
//#import "DiscoverViewController.h"

# define TABBAR_HEIGHT 65
@interface RootTarBarController ()

@end

@implementation RootTarBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [LocalJsonManager unzipJsonswithComplete:nil];
//    _arVC = ({
//
//        vc;
//    });
//    @weakify(self);
//    [LocalARManager unzipResourceWithComplete:^(NSString *path) {
//        @strongify(self);
//
//    }];
    KudanARViewController *arVC = [[KudanARViewController alloc]init];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"localApi" ofType:@"bundle"];
    arVC.resourcePath = [NSString stringWithFormat:@"%@/ahbwysjy_museum/",bundlePath];
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
//    self.arVC.resourcePath = path;

//    //卡主线程  延后0.1秒执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.arVC.museum = museum;
        self.arVC.resourcePath = path;
    });
}

//- (void)configKuDan:(MuseumModel *)museum{
//    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.mode = MBProgressHUDModeIndeterminate;
//    HUD.label.text = [TXSakuraManager tx_stringWithPath:@"xlistview_header_hint_loading"];
//    //卡主线程  延后0.1秒执行
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.arVC.museum = museum;
//        self.arVC.resourcePath = [FileUtil getFilePath:[museum cacheResourceDir]];
//        [HUD hideAnimated:YES];
//    });
//}

- (void)configChildController{

}


//- (void)configChildController{
//    StoreViewController *storeVC = [[StoreViewController alloc]init];
//    MLNavigationController *storeNav = [[MLNavigationController alloc]initWithRootViewController:storeVC];
//    RootViewController *mainVC = [[RootViewController alloc]init];
//    MLNavigationController *mainNav = [[MLNavigationController alloc]initWithRootViewController:mainVC];
//    UserCenterViewController *userVC = [[UserCenterViewController alloc]init];
//    MLNavigationController *userNav = [[MLNavigationController alloc]initWithRootViewController:userVC];
//    [self addChildViewController:storeNav];
//    [self addChildViewController:mainNav];
//    [self addChildViewController:userNav];
//
////    UIEdgeInsets edge;
////    UIOffset offset;
////    if (IPHONE_DEVICE) {
////       edge = UIEdgeInsetsMake(-13, 0, 13, 0);
////        offset = UIOffsetMake(6, -6);
////    }else{
////        edge = UIEdgeInsetsMake(-26, 33, 26, -33);
////        offset = UIOffsetMake(0, 6);
////    }
//    
//    storeVC.tabBarItem.sakura.title(@"store");
//    [storeVC.tabBarItem setSelectedImage:[[UIImage imageNamed:@"store"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    storeVC.tabBarItem.image = [[UIImage imageNamed:@"store_un"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
////    storeVC.tabBarItem.imageInsets =  edge;
////    storeVC.tabBarItem.titlePositionAdjustment = offset;
//    
//    mainNav.tabBarItem.sakura.title(@"guide");
//    mainNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_guide"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    mainNav.tabBarItem.image = [[UIImage imageNamed:@"tab_guide_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
////    mainNav.tabBarItem.imageInsets = edge;
////    mainNav.tabBarItem.titlePositionAdjustment = offset;
//    
//    userNav.tabBarItem.sakura.title(@"mine");
//    [userNav.tabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_user"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    userNav.tabBarItem.image = [[UIImage imageNamed:@"tab_user_off"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
////    userNav.tabBarItem.imageInsets =  edge;
////    userNav.tabBarItem.titlePositionAdjustment = offset;
//    [[UITabBar appearance]setBackgroundColor:HexRGBAlpha(0x000000, 0.5)];
//    [[UITabBar appearance]setBackgroundImage:[UIImage new]];
//    [[UITabBar appearance]setShadowImage:[UIImage new]];
//    [[UITabBar appearance]setTintColor:[UIColor whiteColor]];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
////    ,NSFontAttributeName : [UIFont  systemFontOfSize:13]
//    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:HexRGB(0xEC6728)} forState:UIControlStateSelected];
//    self.selectedIndex = 1;
//}


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
