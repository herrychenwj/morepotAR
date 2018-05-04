//
//  NSString+URL.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/22.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)


- (NSString *)apiPath;

- (NSString *)paymentPath;

- (NSString *)localPath;


/**
 拼接云端资源地址

 @return 拼接云端Server host的资源地址
 */
- (NSString *)cloudPath;


- (NSString *)highPicturePath;


///**
// talkingData事件名 xxx博物馆_事件名
//
// */
//- (NSString *)talkingDataString;

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;



@end
