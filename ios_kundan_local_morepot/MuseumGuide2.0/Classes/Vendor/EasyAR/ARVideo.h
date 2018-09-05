//=============================================================================================================================
//
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import <Foundation/Foundation.h>
#import <easyar/player.oc.h>

@interface ARVideo : NSObject{
        BOOL prepared;
}

- (void)openVideoFile:(NSString *)path texid:(int)texid storageType:(easyar_StorageType)storageType complete:(void(^)())complete;
- (void)openTransparentVideoFile:(NSString *)path texid:(int)texid storageType:(easyar_StorageType)storageType complete:(void(^)())complete;;
- (void)openStreamingVideo:(NSString *)url texid:(int)texid;
- (void)setVideoStatus:(int)status;
- (void)onFound;
- (void)onLost;
- (void)update;
- (bool)isRenderTextureAvailable;

@end