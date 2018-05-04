//
//  ExhibitThumbModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/6/13.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExhibitThumbModel : NSObject
//缩略图地址
@property (nonatomic,copy)NSString *thumbUrl;
//是否是视屏
@property (nonatomic,assign)BOOL moiveMode;



@end
