//=============================================================================================================================
//
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "helloar.h"

#import "BoxRenderer.h"

#import <easyar/types.oc.h>
#import <easyar/camera.oc.h>
#import <easyar/frame.oc.h>
#import <easyar/framestreamer.oc.h>
#import <easyar/imagetracker.oc.h>
#import <easyar/imagetarget.oc.h>
#import <easyar/renderer.oc.h>
#import <easyar/cloud.oc.h>
#import "ARVideo.h"
#import "OpenGLView.h"
#include <OpenGLES/ES2/gl.h>
#import "VideoRenderer.h"
#import "Communtil.h"
#import "FileUtil.h"

//extern NSString * cloud_server_address;
//extern NSString * cloud_key;
//extern NSString * cloud_secret;

easyar_CameraDevice * camera;
VideoScale videoScale;
easyar_CameraFrameStreamer * streamer;
NSMutableArray<easyar_ImageTracker *> * trackers;
easyar_Renderer * videobg_renderer;
BoxRenderer * box_renderer;
easyar_CloudRecognizer * cloud_recognizer;
easyar_Renderer * videobg_renderer = nil;
NSMutableArray<VideoRenderer *> * video_renderers = nil;
VideoRenderer * current_video_renderer = nil;
ARVideo * video = nil;
easyar_Matrix44F  *default_cameraview;
int tracked_target = 0;
int active_target = 0;

id ardeletegate;

bool viewport_changed = false;
int view_size[] = {0, 0};
int view_rotation = 0;
int viewport[] = {0, 0, 1280, 720};
NSMutableSet<NSString *> * uids;

void loadFromImage(easyar_ImageTracker * tracker, NSString * repath)
{
    NSString *path = [repath stringByAppendingPathComponent:@"names.json"];
    NSDictionary *names = [Communtil readlocalJsonFile:path];
    NSArray *tmp = names[@"objects"];
    for (NSDictionary *exhibit in tmp) {
        easyar_ImageTarget * target = [easyar_ImageTarget create];
        NSString *name = exhibit[@"id"];
        NSString *imgPath = [NSString stringWithFormat:@"%@/imageplus/%@.jpg",repath,name];
        NSString *str=[NSString stringWithFormat:@"{\"images\":[{\"image\":\"%@\",\"name\":\"%@\"}]}",imgPath,name];
        [target setup:str storageType:(easyar_StorageType_Json|easyar_StorageType_Absolute|easyar_StorageType_App) name:name];
        [tracker loadTarget:target callback:^(easyar_Target * target, bool status) {
            NSLog(@"load target (%d): %@ (%d)", status, [target name], [target runtimeID]);
        }];
    }
}

void loadLoalARresource(NSString *arpath){
    if(!arpath){return;};
    easyar_ImageTracker * tracker;
   tracker = [easyar_ImageTracker create];
    [tracker attachStreamer:streamer];
    loadFromImage(tracker, arpath);
//    NSDictionary *dic = @{@"path":arpath,@"tracker":tracker};
    [trackers addObject:tracker];
}

BOOL initialize(id delegate,NSString *path)
{
    camera = [easyar_CameraDevice create];
    streamer = [easyar_CameraFrameStreamer create];
    [streamer attachCamera:camera];
    cloud_recognizer = [easyar_CloudRecognizer create];
    [cloud_recognizer attachStreamer:streamer];
    bool status = true;
    status &= [camera open:easyar_CameraDeviceType_Default];
    [camera setSize:[easyar_Vec2I create:@[@1280, @720]]];
    if(!uids){
        uids = [[NSMutableSet<NSString *> alloc] init];
    }
    if (!status) { return status; }
    trackers = [[NSMutableArray<easyar_ImageTracker *> alloc] init];
    loadLoalARresource(path);
    if (IPAD_DEVICE) {
        default_cameraview = [easyar_Matrix44F create: @[@(-0.9518258),@(-0.1187401), @(0.2827162), @0, @(-0.1007968), @(0.991904), @(0.07724264), @0,@(0.2895991), @(-0.04502465), @(0.9560885), @0, @(0.03338737), @(0.154984), @(-2.120883), @(1.0f)]];
    }else {
        default_cameraview = [easyar_Matrix44F create: @[@(-0.008995744),@(-0.9999517), @(0.003958957), @0, @(-0.9983432), @(0.009206148), @(0.05679841), @0,@(0.05683211), @(0.003441454), @(0.9983778), @0, @(0.04916509), @(-0.05850305), @(-2.215296), @(1.0f)]];
    }
    return status;
}


//void unloadtrackers(){
//    for(NSDictionary *dic in trackers){
//        easyar_ImageTracker *tracker = dic[@"tracker"];
//        [tracker stop];
//    }
//}

void finalize()
{
    [trackers removeAllObjects];
    [video_renderers removeAllObjects];

    cloud_recognizer = nil;
    box_renderer = nil;
    videobg_renderer = nil;
    streamer = nil;
    camera = nil;
}

BOOL start()
{
    bool status = true;
    status &= (camera != nil) && [camera start];
    status &= (streamer != nil) && [streamer start];
    status &= (cloud_recognizer != nil) && [cloud_recognizer start];
    [camera setFocusMode:easyar_CameraDeviceFocusMode_Continousauto];
    for (easyar_ImageTracker * tracker in trackers) {
        status &= [tracker start];
    }
    return status;
}

BOOL stop()
{
    bool status = true;
    for (easyar_ImageTracker * tracker in trackers) {
        status &= [tracker stop];
    }
    status &= (cloud_recognizer != nil) && [cloud_recognizer stop];
    status &= (streamer != nil) && [streamer stop];
    status &= (camera != nil) && [camera stop];
    return status;
}

void initGL()
{
    videobg_renderer = [easyar_Renderer create];
    box_renderer = [BoxRenderer alloc];
    [box_renderer init_];
    
    if (active_target != 0) {
        [video onLost];
        video = nil;
        tracked_target = 0;
        active_target = 0;
    }
    videobg_renderer = nil;
    videobg_renderer = [easyar_Renderer create];
    video_renderers = [[NSMutableArray<VideoRenderer *> alloc] init];
    for (int k = 0; k < 3; k += 1) {
        VideoRenderer * video_renderer = [[VideoRenderer alloc] init];
        [video_renderer init_];
        [video_renderers addObject:video_renderer];
    }
    current_video_renderer = nil;
}

void resizeGL(int width, int height)
{
    view_size[0] = width;
    view_size[1] = height;
    viewport_changed = true;
}

void updateViewport()
{
    easyar_CameraCalibration * calib = camera != nil ? [camera cameraCalibration] : nil;
    int rotation = calib != nil ? [calib rotation] : 0;
    if (rotation != view_rotation) {
        view_rotation = rotation;
        viewport_changed = true;
    }
    if (viewport_changed) {
        int size[] = {1, 1};
        if (camera && [camera isOpened]) {
            size[0] = [[[camera size].data objectAtIndex:0] intValue];
            size[1] = [[[camera size].data objectAtIndex:1] intValue];
        }
        if (rotation == 90 || rotation == 270) {
            int t = size[0];
            size[0] = size[1];
            size[1] = t;
        }
        float scaleRatio = MAX((float)view_size[0] / (float)size[0], (float)view_size[1] / (float)size[1]);
        int viewport_size[] = {(int)roundf(size[0] * scaleRatio), (int)roundf(size[1] * scaleRatio)};
        int viewport_new[] = {(view_size[0] - viewport_size[0]) / 2, (view_size[1] - viewport_size[1]) / 2, viewport_size[0], viewport_size[1]};
        memcpy(&viewport[0], &viewport_new[0], 4 * sizeof(int));
        
        if (camera && [camera isOpened])
            viewport_changed = false;
    }
}

void render(id delegate)
{
    glClearColor(1.f, 1.f, 1.f, 1.f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    ardeletegate = delegate;
    if (videobg_renderer != nil) {
        int default_viewport[] = {0, 0, view_size[0], view_size[1]};
        easyar_Vec4I * oc_default_viewport = [easyar_Vec4I create:@[[NSNumber numberWithInt:default_viewport[0]], [NSNumber numberWithInt:default_viewport[1]], [NSNumber numberWithInt:default_viewport[2]], [NSNumber numberWithInt:default_viewport[3]]]];
        glViewport(default_viewport[0], default_viewport[1], default_viewport[2], default_viewport[3]);
        if ([videobg_renderer renderErrorMessage:oc_default_viewport]) {
            return;
        }
    }

    if (streamer == nil) { return; }
    easyar_Frame * frame = [streamer peek];
    updateViewport();
    glViewport(viewport[0], viewport[1], viewport[2], viewport[3]);

    if (videobg_renderer != nil) {
        [videobg_renderer render:frame viewport:[easyar_Vec4I create:@[[NSNumber numberWithInt:viewport[0]], [NSNumber numberWithInt:viewport[1]], [NSNumber numberWithInt:viewport[2]], [NSNumber numberWithInt:viewport[3]]]]];
    }
    
    if (current_video_renderer != nil&&video != nil) {
        [video update];
        if ([video isRenderTextureAvailable]) {
            easyar_Vec2F *size = [easyar_Vec2F create:@[@1,@1]];
            [current_video_renderer render:[camera projectionGL:0.2f farPlane:500.f] cameraview:default_cameraview size:size scale:videoScale];
        }
    }
    
    NSArray<easyar_TargetInstance *> * targetInstances = [frame targetInstances];
    if (targetInstances.count>0) {
        for (easyar_TargetInstance * targetInstance in [frame targetInstances]) {
            easyar_TargetStatus status = [targetInstance status];
            if (status == easyar_TargetStatus_Tracked) {
                easyar_Target * target = [targetInstance target];
                int runtimeID = [target runtimeID];
                if (active_target != 0 && active_target != runtimeID) {
//                    [video onLost];
                    video = nil;
                    tracked_target = 0;
                    active_target = 0;
                }
                easyar_ImageTarget * imagetarget = [target isKindOfClass:[easyar_ImageTarget class]] ? (easyar_ImageTarget *)target : nil;
//                if (imagetarget != nil) {
//                    if (current_video_renderer != nil) {
//                        [video update];
//                        if ([video isRenderTextureAvailable]) {
//                            [current_video_renderer render:[camera projectionGL:0.2f farPlane:500.f] cameraview:[targetInstance poseGL] size:[imagetarget size] scale:videoScale];
//                        }
//                    }
//                }
  

                if (imagetarget == nil) {
                    continue;
                }
                if (delegate) {
                    [delegate optionalMethod:[target name] texid:[target uid]];
                }
                
            }
        }
    }
    else
    {
        if (delegate) {
            [delegate optionalMethod:nil texid:nil];
        }
        if (tracked_target != 0) {
//            [video onLost];
            tracked_target = 0;
        }
    }
    
}

void playVideo(NSString *path,VideoScale scale,NSString *exid){
    video = nil;
    if (video == nil && [video_renderers count] > 0) {
        video = [[ARVideo alloc] init];
        [video openTransparentVideoFile:path texid:[[video_renderers objectAtIndex:1] texid] storageType:easyar_StorageType_Absolute complete:^(){
            if (ardeletegate) {
                [ardeletegate optionalMethod:@"videofinished" texid:exid];
            }
        }];
        videoScale = scale;
        current_video_renderer = [video_renderers objectAtIndex:1];
    }
}

void stopVideo(){
    [video onLost];
     video = nil;
}




