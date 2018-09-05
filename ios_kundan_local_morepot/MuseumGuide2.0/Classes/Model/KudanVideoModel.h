//
//  KudanVideoModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/5/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KudanVideoModel : NSObject

@property (nonatomic,copy)NSString *videoname;
@property (nonatomic,copy)NSString *audioname;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)float x;
@property (nonatomic,assign)float y;
@property (nonatomic,assign)float z;
@property (nonatomic,assign)float scale_x;
@property (nonatomic,assign)float scale_y;
@property (nonatomic,assign)BOOL isfollow;

@property (nonatomic,assign)float scale;

@end
