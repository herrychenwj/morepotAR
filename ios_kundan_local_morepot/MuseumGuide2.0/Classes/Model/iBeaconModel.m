//
//  iBeaconModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/6/5.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "iBeaconModel.h"

@implementation iBeaconModel


- (void)setDistance:(NSString *)distance{
    if (distance) {
        NSArray *disAry = [distance componentsSeparatedByString:@","];
        if (disAry.count>0) {
            self.maxdis = [[disAry firstObject]floatValue];
        }
    }
}


- (CLBeaconRegion *)generateBeacon{
    CLBeaconRegion *beacon = [[CLBeaconRegion alloc]initWithProximityUUID:[[NSUUID alloc]initWithUUIDString:self.uuid] major:[self.major floatValue] minor:[self.minor floatValue] identifier:self.exhibit_id];
    [beacon setNotifyOnEntry:YES];
    [beacon setNotifyOnExit:YES];
    return beacon;
}

- (BOOL)isequalBeacon:(CLBeacon *)beacon{
    return  [[self.uuid lowercaseString] isEqualToString:[[[beacon proximityUUID]UUIDString] lowercaseString]] && [self.major isEqual:beacon.major] && [self.minor isEqual:beacon.minor];
}

- (BOOL)isInBeaconRange:(CLBeacon *)beacon{
    if (!self.distance || !self.maxdis) { //如果没有distance不需要判断范围
        return YES;
    }
    if ([Communtil calcDistByRSSI:beacon.rssi] < self.maxdis) {
        return YES;
    }
    return NO;
}

@end
