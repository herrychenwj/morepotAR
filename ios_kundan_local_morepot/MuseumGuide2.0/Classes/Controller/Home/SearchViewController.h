//
//  SearchViewController.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MuseumModel.h"

@class MapSearchModel;

typedef NS_ENUM(NSInteger,SearchType){
    HomeSearch = 0,
    MapSearch
};


@interface SearchViewController : BaseViewController

- (instancetype)initWithMuseumInfo:(MuseumModel *)museum searchType:(SearchType)type searchResult:(void(^)(MapSearchModel*))resultBlock;
@property (nonatomic,weak)NSArray *goodsAry;

@end
