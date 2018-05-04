//
//  MuseumInfoModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/2/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MuseumInfoModel : NSObject

/**
 名字
 */
@property (nonatomic,strong)NSString *cn_name;

/**
 地址
 */
@property (nonatomic,strong)NSString *address;

/**
 主页
 */
@property (nonatomic,strong)NSString *homepage;

/**
 开馆时间
 */
@property (nonatomic,strong)NSString *opentime;

/**
 交通
 */
@property (nonatomic,strong)NSString *traffic;

/**
 服务支持电话
 */
@property (nonatomic,strong)NSString *appointtel;

/**
 投诉热线
 */
@property (nonatomic,strong)NSString *complaintel;

/**
 介绍
 */
@property (nonatomic,strong)NSString *mdescription;

/**
 图片地址
 */
@property (nonatomic,strong)NSArray *images;

/**
 音频地址
 */
@property (nonatomic,strong)NSString *audio;

/**
 视频地址
 */
@property (nonatomic,copy)NSString *video;

/**
 展馆分享
 */
@property (nonatomic,copy)NSString *share;




- (CGFloat)descRowHeight;
- (CGFloat)addressRowHeight;

@property (nonatomic,assign)BOOL isOpen;

@property (nonatomic,strong)NSAttributedString *attributeDesc;

@property (nonatomic,strong)NSAttributedString *attributeAddress;

@end
