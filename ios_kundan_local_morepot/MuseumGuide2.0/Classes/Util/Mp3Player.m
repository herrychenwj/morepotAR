//
//  Mp3Player.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/7.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "Mp3Player.h"
#import <AVFoundation/AVFoundation.h>

@interface Mp3Player()<AVAudioPlayerDelegate>
@property (nonatomic,strong)AVAudioPlayer *player;
@property (nonatomic,copy)void(^complete)();
@property (nonatomic,strong)NSString *mp3path;
@property (nonatomic,strong)NSTimer *progressTimer;
@property (nonatomic,copy)void(^progress)(float,NSTimeInterval);
@end


@implementation Mp3Player

- (void)playAudioWithFilePath:(NSString *)path progress:(void(^)(float,NSTimeInterval))progress didComplete:(void(^)())complete;{
    if (_mp3path != path) {
        NSError *error;
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:&error];
        if (error) {
            return;
        }
        self.mp3path = path;
        if (progress) {
            self.progress = progress;
            if (!_progressTimer) {
                _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(countProgress:) userInfo:nil repeats:YES];
            }
        }
        self.progress = progress;
        self.player.delegate  = self;
        self.complete = complete;
        [self.player prepareToPlay];
    }
}


- (void)countProgress:(NSTimer *)timer{
    if (self.progress) {
        self.progress(self.player.currentTime/self.player.duration,self.currentTime);
    }
}

//播放完成时调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (self.complete) {
        self.complete();
    }
}
//播放
- (void)play{
    [self.player play];
}
//暂停
- (void)pause{
    [self.player pause];
}
//停止
- (void)stop{
    self.player.currentTime = 0;  //当前播放时间设置为0
    [self pause];
    [self.player stop];
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

#pragma mark setters 和getters方法
- (NSTimeInterval)currentTime {
    return self.player.currentTime;
}

- (NSTimeInterval)duration {
    return self.player.duration;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    self.player.currentTime = currentTime;
}

@end
