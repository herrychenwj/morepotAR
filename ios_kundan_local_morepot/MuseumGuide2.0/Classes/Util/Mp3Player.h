//
//  Mp3Player.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/7.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mp3Player : NSObject
@property (nonatomic,assign) NSTimeInterval currentTime;
@property (nonatomic,assign) NSTimeInterval duration;

- (void)playAudioWithFilePath:(NSString *)path progress:(void(^)(float,NSTimeInterval))progress didComplete:(void(^)())complete;
/** 暂停 */
- (void)pause;

/** 继续 **/
- (void)play;

/** 停止 */
- (void)stop;
@end
