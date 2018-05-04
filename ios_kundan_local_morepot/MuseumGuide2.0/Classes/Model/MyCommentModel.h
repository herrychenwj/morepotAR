//
//  MyCommentModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/5.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCommentModel : NSObject
@property (nonatomic,copy)NSString *exhibit_id;
@property (nonatomic,copy)NSString *exhibitname;
@property (nonatomic,copy)NSString *imageurl;
@property (nonatomic,copy)NSString *datatime;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *created_at;


@end
