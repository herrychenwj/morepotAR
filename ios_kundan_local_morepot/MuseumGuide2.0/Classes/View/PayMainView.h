//
//  PayMainView.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/6/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ThirdPayView;


@interface PayMainView : UIView
- (instancetype)initWithFrame:(CGRect)frame reviewsMode:(BOOL)reviewsMode;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)ThirdPayView *payView;
@property (nonatomic,strong)UIButton *closeBtn;

@property (nonatomic,assign)BOOL reviewsMode;


@end


@interface ThirdPayView : UIView


- (instancetype)initWithFrame:(CGRect)frame reviewsMode:(BOOL)reviewsMode;

@property (nonatomic,strong)UIButton *appleBtn;



@end
