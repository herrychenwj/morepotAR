//
//  MapModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/15.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapModel : NSObject


/**
 楼层
 */
@property (nonatomic,copy)NSString *floor;

/**
 地图ID
 */
@property (nonatomic,copy)NSString *mapid;

/**
 文件名
 */
@property (nonatomic,copy)NSString *filename;

@end
