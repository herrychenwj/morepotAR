//
//  RootTabBar.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/10/25.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "RootTabBar.h"
#import <UIKit/UIKit.h>

@implementation RootTabBar

- (void)layoutSubviews{
    [super layoutSubviews];
    for (UIView *item in self.subviews) {
        if (item.center.x > kSCREEN_WIDTH/2) {
            item.center = CGPointMake(item.center.x-30, item.center.y);
        }else{
            item.center = CGPointMake(item.center.x+30, item.center.y);
        }
    }
}


@end
