//
//  MuseumModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/14.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
@class MuseumPayment;

@interface MuseumModel : NSObject


- (BOOL)isEqualToMuseum:(MuseumModel *)object;

- (void)calculatethedistancebetween:(BMKUserLocation *)curLocation;


@property (nonatomic,assign)BOOL taobaoke;

/**
 博物馆ID
 */
@property (nonatomic,copy)NSString *museum_id;

/**
 博物馆名称
 */
@property (nonatomic,copy)NSString *museum_name;

/**
 博物馆服务器地址
 */
@property (nonatomic,copy)NSString *museum_serverhost;

/**
 博物馆logo地址
 */
@property (nonatomic,copy)NSString *museum_logourl;


@property (nonatomic,strong)NSString *gps;

@property (nonatomic,assign)float latitude;
@property (nonatomic,assign)float longitude;

@property (nonatomic,assign)CLLocationDistance distance;
/**
 应用内logo地址
 */
@property (nonatomic,copy)NSString *home_logourl;

/**
 博物馆类型
 */
@property (nonatomic,copy)NSString *museum_type;

/**
 博物馆文件路径
 */
@property (nonatomic,copy)NSString *museum_documenturl;

/**
 博物馆地址
 */
@property (nonatomic,copy)NSString *address;

/**
 资源下载地址
 */
@property (nonatomic,copy)NSString *resourceurl;

/**
 MD5值
 */
@property (nonatomic,copy)NSString *zip_md5;


@property (nonatomic,strong)NSArray <MuseumPayment *> *payment;

@property (nonatomic,assign)BOOL isCalure;

- (NSString *)cacheResourceDir;

@end


@interface MuseumPayment : NSObject

@property (nonatomic,copy)NSString *pay_id;
@property (nonatomic,copy)NSString *payment;
@property (nonatomic,copy)NSString *price;

@end
