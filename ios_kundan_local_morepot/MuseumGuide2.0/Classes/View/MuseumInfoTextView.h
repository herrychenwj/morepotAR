//
//  MuseumInfoTextView.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LayoutNeed)();
@interface MuseumInfoTextView : UIView

- (void)setContentText:(NSString *)string;
@property (nonatomic,copy)LayoutNeed relayout;


@end
