//
//  MLNavigationController.m
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#define KEY_WINDOW [[UIApplication sharedApplication]keyWindow]
#define TOP_VIEW  self.topViewController.view


#import "MLNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "ARHomeViewController.h"

@interface MLNavigationController ()
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    float viewAlpha;
    UIViewController *currentVC;
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,assign) BOOL isMoving;

@end

@implementation MLNavigationController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view.
    self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
    self.canDragBack = YES;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(paningGestureReceive:)];
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
    self.navigationBarHidden = YES;
}


- (void)dealloc{
    self.screenShotsList = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
    UIImage *capturedImage = [self capture];
    currentVC = viewController;
    if (capturedImage) {
        [self.screenShotsList addObject:capturedImage];
    }
    [super pushViewController:viewController animated:animated];
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (self.screenShotsList && self.screenShotsList.count>0) {
        [self.screenShotsList removeLastObject];
    }
     self.backgroundView.hidden = YES;
    
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Utility Methods -

// get the current view screen shot
- (UIImage *)capture{
    UIGraphicsBeginImageContextWithOptions(TOP_VIEW.bounds.size, TOP_VIEW.opaque, 0.0);
    [TOP_VIEW.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x
{
    x = x < 0 ? 0 : x;
    
    CGRect frame = TOP_VIEW.frame;
    frame.origin.x = x;
    TOP_VIEW.frame = frame;
    
    float topviewalpha = 1 - (x / TOP_VIEW.frame.size.width);
    TOP_VIEW.alpha = topviewalpha;
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.viewControllers.count <= 1 || !self.canDragBack) return NO;
    return YES;
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer{
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView: KEY_WINDOW];
    // If the viewControllers has only one vc or disable the interaction, then return.
    
    if (self.viewControllers.count <= 1 || [self.viewControllers.lastObject isKindOfClass:[ARHomeViewController class]]  || !self.canDragBack) return;
    if ([self swapCheck]) {
        touchPoint=CGPointMake(touchPoint.y, touchPoint.x);
        if ([[UIApplication sharedApplication] statusBarOrientation]==UIInterfaceOrientationLandscapeLeft) {
            touchPoint=CGPointMake([UIScreen mainScreen].bounds.size.height - touchPoint.x, touchPoint.y);
        }
    }
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;

        CGRect frame = TOP_VIEW.frame;
        if (!self.backgroundView) {
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        }
        self.backgroundView.backgroundColor=[UIColor clearColor];
        TOP_VIEW.superview.frame=frame;
        [TOP_VIEW.superview insertSubview:self.backgroundView belowSubview:TOP_VIEW];
        
        self.backgroundView.hidden = NO;
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView addSubview:lastScreenShotView];

    } else if(recoginzer.state == UIGestureRecognizerStateEnded) {
        CGFloat width=[UIScreen mainScreen].bounds.size.width;
        if ([self swapCheck]) {
            width=[UIScreen mainScreen].bounds.size.height;
        }
        
        if (touchPoint.x - startTouch.x > width/4)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:width];
            } completion:^(BOOL finished) {
                [lastScreenShotView removeFromSuperview];
                lastScreenShotView = nil;
                
                [self popViewControllerAnimated:NO];
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                [lastScreenShotView removeFromSuperview];
                lastScreenShotView = nil;
                _isMoving = NO;
            }];
            
        }
        return;
        
    } else if (recoginzer.state == UIGestureRecognizerStateCancelled) {
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            [lastScreenShotView removeFromSuperview];
            lastScreenShotView = nil;
            _isMoving = NO;
        }];
        
        return;
    }
    
    // it keeps move with touch
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }

}



-(bool)swapCheck {
    bool swapFlag=NO;
    
    if (([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) && ([[UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPad)) {
        swapFlag=YES;
    }
    
    return swapFlag;
}


- (BOOL)shouldAutorotate {
    return [self.viewControllers.lastObject shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

@end
