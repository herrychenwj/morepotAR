//
//  UIViewController+Modal.m
//  PresentStyle
//
//  Created by Mr.Huang on 2017/2/24.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import "UIViewController+Modal.h"

#define KEY_WINDOW [[UIApplication sharedApplication]keyWindow]

@implementation UIViewController (Modal)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{}


- (void)addModalGesture{
   UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:pan];
    __block BOOL isMoving ;
    __block CGFloat startTouchX;
    BOOL swapCheck = [Communtil swapCheck];
    @weakify(self);
    [[pan rac_gestureSignal]subscribeNext:^(UIGestureRecognizer  *gestureRecognizer) {
        @strongify(self);
        CGPoint touchPoint = [gestureRecognizer locationInView:KEY_WINDOW];
        if (swapCheck) {
            touchPoint = CGPointMake(touchPoint.y, touchPoint.x);
            if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) {
                touchPoint = CGPointMake([UIScreen mainScreen].bounds.size.height - touchPoint.x, touchPoint.y);
            }
        }
        switch (gestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:{
                isMoving = YES;
                startTouchX = touchPoint.x;
                return;
            }
            break;
            case UIGestureRecognizerStateEnded:{
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                [UIView animateWithDuration:0.3 animations:^{
                    [self moveViewWithX:(touchPoint.x - startTouchX > width / 4)?width:0];
                } completion:^(BOOL finished) {
                    isMoving = NO;
                    if (touchPoint.x - startTouchX > width / 4) {
                        [self dismissViewControllerAnimated:NO completion:nil];
                    }
                }];
                return;
            }
            case  UIGestureRecognizerStateCancelled:{
                [UIView animateWithDuration:0.3 animations:^{
                    [self moveViewWithX:0];
                }completion:^(BOOL finished) {
                    isMoving = NO;
                }];
                return;
            }
            break;
            default:
            break;
        }
        if (isMoving) {
            [self moveViewWithX:touchPoint.x - startTouchX];
        }

    }];
}

- (void)addModalGestureWithComplete:(void(^)())dismissBlock{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:pan];
    __block BOOL isMoving ;
    __block CGFloat startTouchX;
    BOOL swapCheck = [Communtil swapCheck];
    @weakify(self);
    [[pan rac_gestureSignal]subscribeNext:^(UIGestureRecognizer  *gestureRecognizer) {
        @strongify(self);
        CGPoint touchPoint = [gestureRecognizer locationInView:KEY_WINDOW];
        if (swapCheck) {
            touchPoint = CGPointMake(touchPoint.y, touchPoint.x);
            if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft) {
                touchPoint = CGPointMake([UIScreen mainScreen].bounds.size.height - touchPoint.x, touchPoint.y);
            }
        }
        switch (gestureRecognizer.state) {
            case UIGestureRecognizerStateBegan:{
                isMoving = YES;
                startTouchX = touchPoint.x;
                return;
            }
                break;
            case UIGestureRecognizerStateEnded:{
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                [UIView animateWithDuration:0.3 animations:^{
                    [self moveViewWithX:(touchPoint.x - startTouchX > width / 4)?width:0];
                } completion:^(BOOL finished) {
                    isMoving = NO;
                    if (touchPoint.x - startTouchX > width / 4) {
                        if (dismissBlock) {
                            dismissBlock();
                        }
                    }
                }];
                return;
            }
            case  UIGestureRecognizerStateCancelled:{
                [UIView animateWithDuration:0.3 animations:^{
                    [self moveViewWithX:0];
                }completion:^(BOOL finished) {
                    isMoving = NO;
                }];
                return;
            }
                break;
            default:
                break;
        }
        if (isMoving) {
            [self moveViewWithX:touchPoint.x - startTouchX];
        }
        
    }];
}
    
- (void)moveViewWithX:(CGFloat)x{
    if (x < 0) return;
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
}

- (void)presentTransparentAnimationController:(UIViewController *)controller{
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    controller.view.layer.hidden = YES;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)controller;
        UIViewController *vc =  [nav.viewControllers firstObject];
        [vc addModalGesture];
    }else{
        [controller addModalGesture];
    }
    [self presentViewController:controller animated:YES completion:^(){
         controller.view.layer.hidden = NO;
         [controller.view.layer addAnimation:animation forKey:nil];
    }];
}


- (void)presentTransparentController:(UIViewController *)controller{
    [self presentTransparentController:controller animated:NO];
}

- (void)presentTransparentController:(UIViewController *)controller animated:(BOOL)animated{
    controller.view.backgroundColor = [UIColor clearColor];
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:controller animated:animated completion:^(void){
        controller.view.superview.backgroundColor = [UIColor clearColor];
    }];
}



- (void)AnimationDismiss{
    [UIView animateWithDuration:0.3 animations:^{
        [self moveViewWithX:kSCREEN_WIDTH];
    }completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}





@end

