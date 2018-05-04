//
//  RootSwitch.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/26.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SwitchButton;

@interface RootSwitch : UIView


@property (nonatomic,strong)SwitchButton *bottonA;
@property (nonatomic,strong)SwitchButton *bottonB;
@property (nonatomic,strong)UILabel *titleLB;
@property (nonatomic,strong)UILabel *subLB;

@property(nonatomic) NSInteger selectedSegmentIndex;

- (void)selectAtIndex:(NSInteger)index;


@end

@interface SwitchButton : UIButton

@property (nonatomic)BOOL didSelected;

@property (nonatomic,strong)UILabel *textLabel;


@end

