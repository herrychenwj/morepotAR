//
//  ProgressBar.h
//  PresentStyle
//
//  Created by Mr.Huang on 2017/3/22.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBar : UIView


/**
 当前进度
 */
@property (nonatomic,assign)float currentValue;


@end


@interface TagView : UIView

@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UILabel *titleLB;


@end
