//
//  NewsDetailModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/5.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsDetailModel : NSObject
@property (nonatomic,strong)NSString *museum_news_id;
@property (nonatomic,strong)NSString *createdate;
@property (nonatomic,strong)NSString *museum_name;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *logo;
@property (nonatomic,strong)NSString *content;
@end
