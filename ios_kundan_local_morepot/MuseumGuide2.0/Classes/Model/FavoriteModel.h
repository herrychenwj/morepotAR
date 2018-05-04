//
//  FavoriteModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/30.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteModel : NSObject

@property (nonatomic,copy)NSString *exhibit_id;
@property (nonatomic,copy)NSString *location;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *catename;
@property (nonatomic,copy)NSString *exhibition_title;
@property (nonatomic,copy)NSString *imageurl;
@property (nonatomic,copy)NSString *exhibitdesc;

@end
