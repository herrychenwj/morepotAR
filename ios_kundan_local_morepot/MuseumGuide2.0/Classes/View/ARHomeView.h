//
//  ARHomeView.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2018/5/10.
//  Copyright © 2018年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticalButton.h"
#import "HomeFooterView.h"
#import "VerticalButton.h"
#import "HorizontalButton.h"

@interface ARHomeView : UIView


@property (nonatomic,strong)UIButton *logoBtn;
@property (nonatomic,strong)UILabel *warningLB;
@property (nonatomic,strong)VerticalButton *exhibitBtn;
@property (nonatomic,strong)HorizontalButton *enExhibitBtn;
@property (nonatomic,strong)HomeFooterView *footerView;
@property (nonatomic,strong)UIButton *closeVideoBtn;

- (void)hideAllElement;

- (void)showExhibitName:(NSString *)name en:(BOOL)is_en;

- (void)resetExhibitName;

- (void)showLogoAndFoot;

- (void)hideLogoAndFoot;

- (void)tapAnmiationhide;



@end
