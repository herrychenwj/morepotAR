//
//  iBeaconManager.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/7.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "iBeaconManager.h"

@interface iBeaconManager ()<CBPeripheralManagerDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong)CBPeripheralManager *peripheralManager;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,strong)NSArray<iBeaconModel *> *beaconModelsAry;
@property (nonatomic,strong)NSArray <CLBeaconRegion *>*beaconRangesAry;
@property (nonatomic,assign)NSInteger unknowTag;

@end


@implementation iBeaconManager

- (instancetype)init{
    if (self = [super init]) {
        self.unknowTag = 0;
        _locationManager = ({
            CLLocationManager *manager = [[CLLocationManager alloc]init];
            manager.delegate = self;
            manager.activityType = CLActivityTypeFitness;
            manager.distanceFilter = kCLDistanceFilterNone;
            manager.desiredAccuracy = kCLLocationAccuracyBest;
            manager;
        });
        [self.locationManager startUpdatingLocation];
        // 如果没有授权则请求用户授权
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            [self.locationManager requestWhenInUseAuthorization];
        }
        self.peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:nil];
    }
    return self;
}



- (void)setBeaconRangesAry:(NSArray<CLBeaconRegion *> *)beaconRangesAry{
    if (_beaconRangesAry != beaconRangesAry) {
        if (_beaconRangesAry || !beaconRangesAry) { //如果当前已经在监听或者传入空值 停止所有监听
            [self stopRangingBeacons:_beaconRangesAry];
        }
        _beaconRangesAry = nil;
        _beaconRangesAry = beaconRangesAry;
        [self startRangingBeacons:_beaconRangesAry];
    }
}


- (void)setBeaconModelsAry:(NSArray<iBeaconModel *> *)beaconModelsAry{
    if (_beaconModelsAry != beaconModelsAry) {
        _beaconModelsAry = beaconModelsAry;
        [self setBeaconRangesAry:[[_beaconModelsAry.rac_sequence map:^id(iBeaconModel *value) {
            return [value generateBeacon];
        }] array]];
    }
}


- (void)cleanLocation{
    self.curBeaconModel = nil;
    self.beaconModelsAry = nil;
    [self stopRangingBeacons:self.beaconRangesAry];
}

//删除所有regions监听
- (void)stopRangingBeacons:(NSArray *)beacons{
    if (!beacons || beacons.count == 0) return;
    for (CLBeaconRegion *beaconRegion in beacons) {
        [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
    }
}

//开启所有regions监听
- (void)startRangingBeacons:(NSArray *)beacons{
    if (!beacons || beacons.count == 0) return;
    for (CLBeaconRegion *beaconRegion in beacons) {
        [beaconRegion setNotifyOnEntry:YES];
        [beaconRegion setNotifyOnExit:YES];
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    }
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
    }
}



- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    if ((int)peripheral.state == CBManagerStatePoweredOn) { //已打开
        [self.locationManager startUpdatingLocation];
    }else {
        [self.locationManager stopUpdatingLocation];
    }
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    if (!(beacons.count > 0)){ //连续100次
        _unknowTag ++;
        if (_unknowTag >= 100) {
            if (self.curBeaconModel) {
                self.curBeaconModel = nil;
            }
        }
        return;
    }
    CLBeacon *inBeacon = [beacons firstObject];
    if ([self.curBeaconModel isequalBeacon:inBeacon]){ //当前识别到beacon和当前beacon相同
        if ([self.curBeaconModel isInBeaconRange:inBeacon]) {
            return;
        }else{
            self.curBeaconModel = nil;
        }
    }else{ //不相同
        NSArray *mapAry = [[self.beaconModelsAry.rac_sequence filter:^BOOL(iBeaconModel *value) {
            return [value isequalBeacon:inBeacon];
        }]array];
        if (mapAry.count > 0) {
            iBeaconModel *sbeacon = [mapAry firstObject];
            if ([sbeacon isInBeaconRange:inBeacon]) { //是否在范围内
                self.curBeaconModel = sbeacon;
                _unknowTag = 0;
            }
        }else{
            self.curBeaconModel = nil;
            _unknowTag ++;
        }
    }
}



//离开
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    
}
//失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"beacons error. --> %@", error.description);
}
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)startUpdatinglocation{
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatinglocation{
    [self.locationManager stopUpdatingLocation];
}



@end
