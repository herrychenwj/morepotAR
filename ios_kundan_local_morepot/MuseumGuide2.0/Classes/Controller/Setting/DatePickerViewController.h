//
//  DatePickerViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/2.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface DatePickerViewController : BaseViewController

+ (DatePickerViewController *)datePickerWithDoneAction:(void(^)(NSDate*))doneAction;
@end

