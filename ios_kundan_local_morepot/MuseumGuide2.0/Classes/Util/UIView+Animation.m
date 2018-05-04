//
//  UIView+Animation.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/4.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)shakeAnimation{
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    keyAnimaion.values = @[@(-10 / 180.0 * M_PI),@(10 /180.0 * M_PI),@(-10/ 180.0 * M_PI)];
    keyAnimaion.removedOnCompletion = YES;
    keyAnimaion.fillMode = kCAFillModeForwards;
    keyAnimaion.duration = 0.3;
    keyAnimaion.repeatCount = 5;
    [self.layer addAnimation:keyAnimaion forKey:nil];
}

- (void)magnifyAnimation{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1.5;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    animation.values = values;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    [self.layer addAnimation:animation forKey:nil];
}


- (void)alphaAnimation{
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = 1.5;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:animation forKey:nil];

}


- (void)springAnimation{
    CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position"];
    spring.damping = 5;
    spring.stiffness = 100;
    spring.mass = 1;
    spring.initialVelocity = 0;
    spring.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.layer.position.x, self.layer.position.y)];
    spring.toValue = [NSValue valueWithCGPoint:CGPointMake(self.layer.position.x - 18, self.layer.position.y-18)];
    spring.duration = spring.settlingDuration;
    spring.fillMode=kCAFillModeForwards;
    spring.removedOnCompletion = NO;
    [self.layer addAnimation:spring forKey:nil];
}

@end
