//
//  MuseumListModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/12.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MuseumListModel.h"

@implementation MuseumListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"museums":@"MuseumModel",@"culture":@"MuseumModel"};
}
@end
