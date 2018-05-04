//
//  StoreNavBar.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/11/7.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StoreButton;
@interface StoreNavBar : UIView
@property (nonatomic,strong)StoreButton *selectBtn;
@property (nonatomic,strong)UITextField *searchFD;

@end

@interface StoreButton:UIButton
@property (nonatomic,strong)UIImageView *imgV;
@property (nonatomic,strong)UILabel *titleLB;
@property (nonatomic,assign)BOOL select;

@end

