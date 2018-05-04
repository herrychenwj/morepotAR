//
//  SearchAllModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/6/5.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MapSearchModel;

@interface SearchAllModel : NSObject
@property (nonatomic,copy)NSString *exhibition;
@property (nonatomic,strong)NSArray <MapSearchModel*>*exhibits;
@end
