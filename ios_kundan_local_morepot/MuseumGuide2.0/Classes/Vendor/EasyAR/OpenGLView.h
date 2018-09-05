//=============================================================================================================================
//
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import <GLKit/GLKView.h>
#import "VideoRenderer.h"
@protocol TestProtocol
- (void)optionalMethod:(NSString*)name texid:(NSString *)texid;
@end

@interface OpenGLView : GLKView

- (void)start:(NSString *)path;
- (void)stop;
- (void)resize:(CGRect)frame orientation:(UIInterfaceOrientation)orientation;
- (void)setOrientation:(UIInterfaceOrientation)orientation;
@property(nonatomic,assign) id<TestProtocol> actiondelegate;

- (void)playVideoWithPath:(NSString *)path videoScale:(VideoScale)scale exhibitID:(NSString *)exid;
- (void)stopVideo;
//- (void)loadLoalAR:(NSString *)path;


@end
