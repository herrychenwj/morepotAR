//
//  CURExhibitModel.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2018/5/17.
//  Copyright © 2018年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CURExhibitModel : NSObject
    
+ (CURExhibitModel *)CURExhibit:(NSString *)exhibit_id bluetooth:(BOOL)blue;
    
    
@property (nonatomic,copy)NSString *exhibit_id;
@property (nonatomic,assign)BOOL bluetooth;
@end
