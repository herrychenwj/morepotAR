//
//  TopExhibitionModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopExhibitionModel : NSObject

/**
 展品ID
 */
@property (nonatomic,copy)NSString *exhibit_id;

/**
 展品标题
 */
@property (nonatomic,copy)NSString *exhibition_title;

/**
 展品名称
 */
@property (nonatomic,copy)NSString *name;

/**
 展品定位
 */
@property (nonatomic,copy)NSString *location;

/**
 名字
 */
@property (nonatomic,copy)NSString *catename;
@property (nonatomic,copy)NSString *listorder;
/**
 楼层
 */
@property (nonatomic,copy)NSString *floor;

/**
 图片地址
 */
@property (nonatomic,copy)NSString *imageurl;

@end
