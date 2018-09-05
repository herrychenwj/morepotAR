
//
//  EasyARViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/10/26.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "EasyARViewController.h"
#import <easyar/player.oc.h>
#import "OpenGLView.h"
#import "KudanVideoModel.h"
#import "FileUtil.h"
@interface EasyARViewController ()<TestProtocol>
@property (nonatomic,strong)NSArray *imgAry;
@property (nonatomic,strong)NSArray *namesAry;
@property (nonatomic,strong)NSArray *videoAry;
@property (nonatomic,strong)UIButton *videoBtn;
@property (nonatomic,strong)UIControl *blankControl;
@property (nonatomic,strong)UIImageView *titleAnmiationView;
@property (nonatomic,strong)UIImageView *arAnmationView;
@property (nonatomic,copy)NSString *current_id;
@end

@implementation EasyARViewController{
    OpenGLView *glView;
}

- (void)loadView {
    self->glView = [[OpenGLView alloc] initWithFrame:CGRectZero];
    self.view = self->glView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self->glView setOrientation:self.interfaceOrientation];
    [self->glView setActiondelegate:self];
}



- (void)optionalMethod:(NSString*)name texid:(NSString *)texid{
    if ([name isEqualToString:@"videofinished"]) {
        [self hiddenVideo];
        if ([self.arDelegate respondsToSelector:@selector(finishVideo:)]) {
            [self.arDelegate finishVideo:texid];
        }
        return;
    }
    if (self.playVideo){
        return;
    }
    if (!name) {
        if (self.current_id) { //丢失追踪
            self.current_id = nil;
            if (self.arDelegate && [self.arDelegate respondsToSelector:@selector(lostTrack)]) {
                [self.arDelegate lostTrack];
            }
        }
    }else{
        [self onTracked:name];
    }
}

- (void)onTracked:(NSString *)name{
    if (self.playVideo) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.current_id) {
            self.current_id = name;
        }
        NSString *exhibit_id = [self exhibit_id:name];
        NSArray *names = [[self.namesAry.rac_sequence filter:^BOOL(NSDictionary *value) {
            return [[value objectForKey:@"id"] isEqualToString:exhibit_id];
        }]array];
        if (names.count > 0) {
            NSDictionary *nameDic = [names firstObject];
            NSArray *ids = [nameDic objectForKey:@"ids"];
            NSString *showName;
            BOOL enTitle;
            NSString *localizable = [[NSUserDefaults standardUserDefaults]objectForKey:kLOCALIZABLE];
            if ([localizable isEqualToString:@"en"]&&[[nameDic objectForKey:@"shownameE"] length]>0) {
                showName = [nameDic objectForKey:@"shownameE"];
                enTitle = YES;
            }else{
                showName = [nameDic objectForKey:@"showname"];
                enTitle = NO;
            }
            if (self.arDelegate && [self.arDelegate respondsToSelector:@selector(onTrack:Exhibition_name:hasARVideo:enTitle:)]) {
                BOOL hasVideo = [[self.videoAry.rac_sequence filter:^BOOL(KudanVideoModel *value) {
                    return [name isEqualToString:value.name];
                }]array].count > 0;
                if (ids && ids.count>0) {
                    [self.arDelegate onTrack:exhibit_id Exhibition_names:ids hasARVideo:hasVideo enTitle:enTitle];
                }
                [self.arDelegate onTrack:exhibit_id Exhibition_name:showName hasARVideo:hasVideo enTitle:enTitle];
            }
        }
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self->glView start:self.resourcePath];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self->glView stop];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self->glView resize:self.view.bounds orientation:1];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self->glView setOrientation:toInterfaceOrientation];
}

- (void)showARVideo:(NSString *)exhibition_id{
    NSArray *video =[[self.videoAry.rac_sequence filter:^BOOL(KudanVideoModel *value) {
        return [exhibition_id isEqualToString:value.name];
    }]array];
    if (video.count > 0) {
        KudanVideoModel *vodeX = [video firstObject];
        VideoScale videoScale;
        videoScale.scalex = vodeX.scale_x;
        videoScale.scaley = vodeX.scale_y;
        videoScale.x = vodeX.x;
        videoScale.y = vodeX.y;
        videoScale.z = vodeX.z;
        [glView playVideoWithPath:[self.resourcePath stringByAppendingPathComponent:vodeX.videoname] videoScale:videoScale exhibitID:exhibition_id];
        self.playVideo = YES;
    }
}


- (BOOL)isARVideoWithExhibitID:(NSString *)exhibit_id{
    BOOL hasVideo = [[self.videoAry.rac_sequence filter:^BOOL(KudanVideoModel *value) {
        return [exhibit_id isEqualToString:value.name];
    }]array].count > 0;
    return hasVideo;
}


- (void)hiddenVideo{
    [glView stopVideo];
    self.playVideo = NO;
    self.current_id = nil;
}

- (void)setResourcePath:(NSString *)resourcePath{
    if (_resourcePath != resourcePath) {
        if ([self.arDelegate respondsToSelector:@selector(configStart)]) {
            [self.arDelegate configStart];
        }
        _resourcePath = resourcePath;
//        NSString *imgs = [_resourcePath stringByAppendingPathComponent:@"imageplus"];
        [self->glView start:self.resourcePath];
        self.videoAry = nil;
        self.namesAry = nil;
        self.imgAry = nil;
        NSLog(@"%@",self.imgAry);
        if ([self.arDelegate respondsToSelector:@selector(configEnd)]) {
            [self.arDelegate configEnd];
        }
    }
}

#pragma mark lazyload
- (NSArray *)namesAry{
    if (!_namesAry) {
        NSString *path = [self.resourcePath stringByAppendingPathComponent:@"names.json"];
        NSDictionary *names = [Communtil readlocalJsonFile:path];
        _namesAry = [names objectForKey:@"objects"];
    }
    return _namesAry;
}

- (NSArray *)imgAry{
    if (!_imgAry) {
        NSString *path = [self.resourcePath stringByAppendingPathComponent:@"imageid.json"];
        NSDictionary *names = [Communtil readlocalJsonFile:path];
        _imgAry = [names objectForKey:@"images"];
    }
    return _imgAry;
}

- (NSString *)exhibit_id:(NSString *)exid{
//    NSArray *imgs = [[[self.imgAry rac_sequence]filter:^BOOL(NSDictionary *value) {
//        return [[value objectForKey:@"image"] isEqualToString:exid];
//    }]array] ;
//    if (imgs.count == 0 || !imgs ) {
//        return nil;
//    }
//    NSDictionary *img = [imgs firstObject];
    NSString *exhibit_id = exid;
    NSMutableArray *ary = [[exhibit_id componentsSeparatedByString:@"_"] mutableCopy];
    NSString *lastName = [ary lastObject];
    if (lastName.length ==2 && [Communtil isNum:lastName]) {
        [ary removeObject:lastName];
        exhibit_id = [ary componentsJoinedByString:@"_"];
    }
    return exhibit_id;
}

- (NSArray *)videoAry{
    if (!_videoAry) {
        NSString *path = [self.resourcePath stringByAppendingPathComponent:@"video.json"];
        NSDictionary *names = [Communtil readlocalJsonFile:path];
        NSArray *videos;
        if (!names) {
            videos = [NSArray array];
        }else{
            videos = [names objectForKey:@"objects"];
        }
        _videoAry = [KudanVideoModel mj_objectArrayWithKeyValuesArray:videos];
    }
    return _videoAry;
}




@end
