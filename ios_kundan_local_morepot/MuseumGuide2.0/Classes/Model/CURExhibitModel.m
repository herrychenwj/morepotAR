//
//  CURExhibitModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2018/5/17.
//  Copyright © 2018年 Heyunguanbo. All rights reserved.
//

#import "CURExhibitModel.h"

@implementation CURExhibitModel
+ (CURExhibitModel *)CURExhibit:(NSString *)exhibit_id bluetooth:(BOOL)blue{
    CURExhibitModel *md = [[CURExhibitModel alloc]init];
    md.exhibit_id = exhibit_id;
    md.bluetooth = blue;
    return md;
}
@end
