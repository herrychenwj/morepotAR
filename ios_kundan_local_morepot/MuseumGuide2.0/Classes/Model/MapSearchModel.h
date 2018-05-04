//
//  MapSearchModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/23.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MapSearchModel.h"

@interface MapSearchModel : NSObject

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *mdescription;
@property (nonatomic,strong)NSString *exhibit_id;
@property (nonatomic,strong)NSString *logourl;
@property (nonatomic,strong)NSString *mID;
@property (nonatomic,strong)NSString *location;
@property (nonatomic,strong)NSString *floor;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,assign)BOOL lock;

@end
