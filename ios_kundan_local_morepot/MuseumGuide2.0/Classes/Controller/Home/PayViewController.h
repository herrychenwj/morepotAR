//
//  PayViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/8/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "BaseViewController.h"
#import "MuseumModel.h"

@interface PayViewController : BaseViewController


- (instancetype)initWithMuseum:(MuseumModel *)museum;


@property (nonatomic,copy)void(^completeBlock)();

@property (nonatomic,copy)void(^loginBlock)();




/**
 审核模式（YES审核模式,只显示苹果支付）
 */
//@property (nonatomic,assign)BOOL reviewsMode;


@property (nonatomic,copy)NSString *trackName;


@property (nonatomic,weak)MuseumModel *museum;




@end
