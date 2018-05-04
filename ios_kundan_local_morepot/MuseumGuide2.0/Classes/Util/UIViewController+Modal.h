//
//  UIViewController+Modal.h
//  PresentStyle
//
//  Created by Mr.Huang on 2017/2/24.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Modal)

- (void)AnimationDismiss;
- (void)addModalGesture;
- (void)addModalGestureWithComplete:(void(^)())dismissBlock;
- (void)presentTransparentController:(UIViewController *)controller animated:(BOOL)animated;
- (void)presentTransparentAnimationController:(UIViewController *)controller;
- (void)presentTransparentController:(UIViewController *)controller;

@end

