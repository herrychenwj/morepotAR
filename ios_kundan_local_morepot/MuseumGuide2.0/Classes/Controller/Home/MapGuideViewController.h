//
//  EnshrineViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MuseumModel.h"

@interface MapGuideViewController : BaseViewController
- (instancetype)initWithMuseumInfo:(MuseumModel *)museum;

@end
