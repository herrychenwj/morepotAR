//
//  iBeaconModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/6/5.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iBeaconModel : NSObject

@property (nonatomic,copy)NSString *distance;
@property (nonatomic,copy)NSString *exhibit_id;
@property (nonatomic,copy)NSString *exhibit_name;
@property (nonatomic,strong)NSNumber *major;
@property (nonatomic,strong)NSNumber *minor;
@property (nonatomic,copy)NSString *uuid;
@property (nonatomic,assign)float maxdis;


/**
 生成CLBeaconRegion

 @return CLBeaconRegion
 */
- (CLBeaconRegion *)generateBeacon;


/**
 是否与CLBeacon相同(判断uuid，minor,major是否相等)

 @param beacon 对比beacon
 @return  是否相等
 */
- (BOOL)isequalBeacon:(CLBeacon *)beacon;


/**
 判断是否在蓝牙范围内

 @param beacon <#beacon description#>
 @return <#return value description#>
 */
- (BOOL)isInBeaconRange:(CLBeacon *)beacon;



@end
