//=============================================================================================================================
//
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "ARVideo.h"

@interface  ARVideo()
@property (nonatomic,copy)void(^videoComplete)();
@end


@implementation ARVideo {
    easyar_VideoPlayer * player;

    BOOL found;
    NSString * path_;
}

- (instancetype)init
{
    player = [easyar_VideoPlayer create];
    prepared = NO;
    found = NO;
    return self;
}

- (void)openVideoFile:(NSString *)path texid:(int)texid storageType:(easyar_StorageType)storageType complete:(void(^)())complete
{
    self->path_ = path;
    [player setRenderTexture:(void *)(texid)];
    [player setVideoType:easyar_VideoType_Normal];
    __weak ARVideo * weak_self = self;
    [player open:path_ storageType:storageType callback:^(easyar_VideoStatus status) {
        [weak_self setVideoStatus:status];
    }];
    self.videoComplete = complete;
}

- (void)openTransparentVideoFile:(NSString *)path texid:(int)texid storageType:(easyar_StorageType)storageType complete:(void(^)())complete
{
    self->path_ = path;
    [player setRenderTexture:(void *)(texid)];
    [player setVideoType:easyar_VideoType_TransparentSideBySide];
    __weak ARVideo * weak_self = self;
    [player open:path_ storageType:storageType callback:^(easyar_VideoStatus status) {
        [weak_self setVideoStatus:status];
    }];
    self.videoComplete = complete;
}

- (void)openStreamingVideo:(NSString *)url texid:(int)texid
{
    self->path_ = url;
    [player setRenderTexture:(void *)(texid)];
    [player setVideoType:easyar_VideoType_Normal];
    __weak ARVideo * weak_self = self;
    [player open:url storageType:easyar_StorageType_Absolute callback:^(easyar_VideoStatus status) {
        [weak_self setVideoStatus:status];
    }];
}

- (void)setVideoStatus:(int)status
{
    NSLog(@"video: %@ (%d)", path_, status);
    if (status == easyar_VideoStatus_Ready) {
        prepared = YES;
         [player play];
//        if (found) {
//            [player play];
//        }
    } else if (status == easyar_VideoStatus_Completed) {
        [self onLost];
        if (self.videoComplete) {
            self.videoComplete();
        }
//        if (found) {
//            [player play];
//        }
    }
}

- (void)onFound
{
    found = YES;
//    if (prepared) {
//        [player play];
//    }
}

- (void)onLost
{
    found = NO;
    if (prepared) {
        [player close];
    }
}

- (void)update
{
    [player updateFrame];
}

- (bool)isRenderTextureAvailable
{
    return [player isRenderTextureAvailable];
}

@end
