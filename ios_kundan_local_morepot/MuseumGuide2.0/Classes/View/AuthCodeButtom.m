//
//  AuthCodeButtom.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/16.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "AuthCodeButtom.h"

@interface AuthCodeButtom ()

@property (nonatomic, strong) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval durationToValidity;

@end

@implementation AuthCodeButtom

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         self.isRunning = NO;
    }
    return self;
}


- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (self.isRunning && enabled) {
        self.enabled = NO;
    }
}



- (void)startUpTimer{
    _durationToValidity = kSMSDURATION;
    
    if (!self.isRunning) {
        self.isRunning = YES;
        self.enabled = NO;
    }
    [self setTitle:[NSString stringWithFormat:@"%.0f 秒", _durationToValidity] forState:UIControlStateNormal];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(redrawTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)invalidateTimer{
    if (self.isRunning) {
        self.isRunning = NO;
        self.enabled = YES;
    }
    [self setTitle:[TXSakuraManager tx_stringWithPath:@"send_identifyin_code"] forState:UIControlStateNormal];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)redrawTimer:(NSTimer *)timer {
    _durationToValidity--;
    if (_durationToValidity > 0) {
        self.isRunning = YES;
        self.titleLabel.text = [NSString stringWithFormat:@"%.0f 秒", _durationToValidity];//防止 button_title 闪烁
        [self setTitle:[NSString stringWithFormat:@"%.0f 秒", _durationToValidity] forState:UIControlStateNormal];
    }else{
        [self invalidateTimer];
    }
}



@end
