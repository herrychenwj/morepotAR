//
//  iBeaconManager.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/7.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import "iBeaconModel.h"
@interface iBeaconManager : NSObject
/**
 开始定位
 */
- (void)startUpdatinglocation;
/**
 停止定位
 */
- (void)stopUpdatinglocation;


- (void)cleanLocation;



- (void)setBeaconModelsAry:(NSArray<iBeaconModel *> *)beaconModelsAry;

@property (nonatomic,strong)iBeaconModel *curBeaconModel;
@end
