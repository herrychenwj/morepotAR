//
//  SystemGuideViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSInteger,ControllerType){
    SystemGuideType,
    SystemAbout,
    SystemExemption
};
@interface SystemGuideViewController : BaseViewController
@property (nonatomic,assign)ControllerType type;

@end
