//
//  MuseumListModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/12.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MuseumModel;

@interface MuseumListModel : NSObject

@property (nonatomic,strong)NSArray <MuseumModel*>*museums;
@property (nonatomic,strong)NSArray <MuseumModel*>*culture;

@property (nonatomic,copy)NSString *lastestversion;
@property (nonatomic,strong)NSNumber *updateflag;

@end
