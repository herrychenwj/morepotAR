//=============================================================================================================================
//
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import <Foundation/Foundation.h>
#import "VideoRenderer.h"




BOOL initialize(id delegate,NSString *path);
void finalize();
BOOL start();
BOOL stop();
void initGL();
void resizeGL(int width, int height);
void render(id delegate);
void playVideo(NSString *path,VideoScale scale,NSString *exid);
void stopVideo();
void loadLoalARresource(NSString *arpath);
void unloadtrackers();

