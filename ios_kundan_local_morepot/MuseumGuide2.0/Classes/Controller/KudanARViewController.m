//
//  KudanARViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/5/27.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "KudanARViewController.h"
#import "KudanVideoModel.h"
#import "VerticalButton.h"
#import "AppDelegate.h"

@interface KudanARViewController ()<ARPlayableTextureDelegate>
@property (nonatomic,strong)ARImageTrackableSet *trackableSet;
@property (nonatomic,strong)NSArray *namesAry;
@property (nonatomic,strong)NSArray *videoAry;
@property (nonatomic,strong)ARImageTrackable *curTrackable;
@property (nonatomic,strong)UIButton *videoBtn;
@property (nonatomic,strong)UIControl *blankControl;
@property (nonatomic,strong)UIImageView *titleAnmiationView;
@property (nonatomic,strong)UIImageView *arAnmationView;

@property (nonatomic,strong)NSMutableArray *videoNodeAry;
@end


@implementation KudanARViewController

//- (void)viewDidLoad{
//    [super viewDidLoad];
//    AppDelegate *del = [UIApplication sharedApplication].delegate;
//    self.resourcePath = del.arPath;
//}

- (void)showARVideo:(NSString *)exhibition_id{
    if (self.playVideo) {return;}
    if (![self.curTrackable.name hasPrefix:exhibition_id]) {return;}
    NSArray *video =[[self.videoAry.rac_sequence filter:^BOOL(KudanVideoModel *value) {
        return [self.curTrackable.name isEqualToString:value.name];
    }]array];
    if (video.count > 0) {
        KudanVideoModel *vodeX = [video firstObject];
//        ARAlphaVideoNode *nodeV;
//        ARImageNode *nodeImg;
        ARAlphaVideoNode *nodeV = (ARAlphaVideoNode *)[self.cameraView.contentViewPort.camera findChildWithName:self.curTrackable.name];
        if (!nodeV) {
            nodeV = (ARAlphaVideoNode *)[self.curTrackable.world findChildWithName:self.curTrackable.name];
        }
//        if (vodeX.isfollow) {
//
//        }else{
//
//            NSString *trackName = [NSString stringWithFormat:@"%@-image",self.curTrackable.name];
//            nodeImg =  (ARImageNode *)[self.cameraView.contentViewPort.camera findChildWithName:trackName];
//        }
        NSArray *names = [[self.namesAry.rac_sequence filter:^BOOL(NSDictionary *value) {
            return [[value objectForKey:@"id"] isEqualToString:vodeX.name];
        }]array];
        if (names.count > 0) {
            NSDictionary *nameDic = [names firstObject];
            NSString *showName = [nameDic objectForKey:@"showname"];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:showName, @"label", [Communtil getCurrentDate], @"datetime",nil];
            [FileUtil saveTalkingdata:@"AR.json" conent:[Communtil DataTOjsonString:dic]];
        }
        if (!nodeV) {
            [self addAlphaVideoNode:self.curTrackable video:vodeX];
        }else{
            [nodeV setVisible:YES];
            [nodeV.videoTexture play];
//            [nodeImg setVisible:YES];
        }
        self.playVideo = YES;
    }
}

//- (void)addAlphaImageNodeVideo:(KudanVideoModel *)video{
//    UIImage *img = [UIImage imageWithContentsOfFile:[self.resourcePath stringByAppendingPathComponent:video.imgname]];
//    if (!img) {
//        return;
//    }
//    NSString *trackname = [NSString stringWithFormat:@"%@-image",video.name];
//    ARImageNode *imgNode = [[ARImageNode alloc]initWithImage:img];
//    ARQuaternion *orientation = [self wallOrientationForDeviceOrientation:[UIDevice currentDevice].orientation];
//    imgNode.orientation = orientation;
//    ARVector3 *nodePosition = [ARVector3 vectorWithValuesX:video.imgX y:video.imgY z:video.imgZ];
//    imgNode.position = nodePosition;
//    imgNode.name = trackname;
//    [imgNode scaleByUniform:video.imgscale];
//    [imgNode setVisible:YES];
//    [self.cameraView.contentViewPort.camera addChild:imgNode];
//}

- (void)addAlphaVideoNode:(ARImageTrackable *)able video:(KudanVideoModel *)video{
    
//    if (video.imgname&&!self.museum.isCalure) {
//        [self addAlphaImageNodeVideo:video];
//    }
    
    ARVideoTexture *videoTexture = [[ARVideoTexture alloc]initWithVideoFile:[self.resourcePath stringByAppendingPathComponent:video.videoname] audioFile:[self.resourcePath stringByAppendingPathComponent:video.audioname]];
    ARAlphaVideoNode *alphaVideoNode = [[ARAlphaVideoNode alloc] initWithVideoTexture:videoTexture];
    //如果不跟随，设置视频方向
    if (!video.isfollow) {
        ARQuaternion *orientation = [self wallOrientationForDeviceOrientation:[UIDevice currentDevice].orientation];
        alphaVideoNode.orientation = orientation;
    }
    ARVector3 *nodePosition = [ARVector3 vectorWithValuesX:video.x y:video.y z:video.z];
    alphaVideoNode.position = nodePosition;
    alphaVideoNode.name = video.name;
    alphaVideoNode.videoTexture.delegate = self;
    [alphaVideoNode addTouchTarget:self withAction:@selector(videoWasTouched:)];
    [alphaVideoNode scaleByUniform:video.scale];
    [alphaVideoNode setVisible:YES];
    [alphaVideoNode.videoTexture play];
    if (video.isfollow) {
        [able.world addChild:alphaVideoNode];
    }else{
        for (ARNode *node in self.videoNodeAry) {
            [node remove];
        }
        [self.videoNodeAry addObject:alphaVideoNode];
        [self.cameraView.contentViewPort.camera addChild:alphaVideoNode];
    }
}

- (void)setupContent{
    NSLog(@"%@.........",self.resourcePath);
    if (!self.resourcePath) return;
    self.canEditAR = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(kudanConfigStart)]) {
        [self.delegate kudanConfigStart];
    }
    [[ARCameraStream getInstance]stop];
//    [self.cameraView.contentViewPort.camera removeAllChildren];
    ARImageTrackerManager *trackerManager = [ARImageTrackerManager getInstance];
    if (![trackerManager isInitialised]) {
        [trackerManager initialise];
        [trackerManager setRecoveryMode:YES];
    }
    NSMutableArray * arrayTemp = [trackerManager.trackables mutableCopy];
    NSArray * array = [NSArray arrayWithArray: arrayTemp];
    for (ARImageTrackable * obj in array) {
        [obj removeTrackingEventTarget:self action:@selector(onTracked:) forEvent:ARImageTrackableEventTracked];
        [obj removeTrackingEventTarget:self action:@selector(lostTracked:) forEvent:ARImageTrackableEventLost];
        [obj.world removeAllChildren];
        [trackerManager removeTrackable:obj];
    }
    ARImageTrackableSet *trackableSet = [[ARImageTrackableSet alloc]initWithPath:[self.resourcePath stringByAppendingPathComponent:@"museum.KARMarker"]];
    for (int i = 0; i<trackableSet.numberOfTrackables; i++) {
        ARImageTrackable *obj = [trackableSet.trackables objectAtIndex:i];
        ARImageTrackable *eobj = [trackerManager findTrackableByName:obj.name];
        if (eobj) {
            [trackerManager removeTrackable:eobj];
        }
        [obj addTrackingEventTarget:self action:@selector(onTracked:) forEvent:ARImageTrackableEventTracked];
        [obj addTrackingEventTarget:self action:@selector(lostTracked:) forEvent:ARImageTrackableEventLost];
        [trackerManager addTrackable:obj];
    }
    [[ARCameraStream getInstance]start];
    self.canEditAR = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(kudanConfigEnd)]) {
        [self.delegate kudanConfigEnd];
    }
    if (self.configSuccess) {
        self.configSuccess(self.museum);
    }
}



- (void)playableTextureDidFinish:(ARPlayableTexture *)texture{
//    [texture reset];
    NSString *exhibit_id = [Communtil exhibit_id:self.curTrackable.name];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(kudanFinishVideo:)]) {
            [self.delegate kudanFinishVideo:exhibit_id];
        }
    });
    [self hiddenVideo];

}

- (void)onTracked:(ARImageTrackable *)x{
    if (self.playVideo) {
        return;
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.curTrackable) {
            self.curTrackable = x;
        }
        NSString *exhibit_id = [self exhibit_id:x.name];
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
//            NSString *exhibit_id = x.name;
//            NSMutableArray *ary = [[exhibit_id componentsSeparatedByString:@"_"] mutableCopy];
//            NSString *lastName = [ary lastObject];
//            if ([Communtil isNum:lastName]) {
//                [ary removeObject:lastName];
//                exhibit_id = [ary componentsJoinedByString:@"_"];
//            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(kudanOnTrack:Exhibition_name:hasARVideo:enTitle:)]) {
                BOOL hasVideo = [[self.videoAry.rac_sequence filter:^BOOL(KudanVideoModel *value) {
                    return [x.name isEqualToString:value.name];
                }]array].count > 0;
                if (ids && ids.count>0) {
                    [self.delegate kudanOnTrack:exhibit_id Exhibition_names:ids hasARVideo:hasVideo enTitle:enTitle];
                }
                [self.delegate kudanOnTrack:exhibit_id Exhibition_name:showName hasARVideo:hasVideo enTitle:enTitle];
            }
        }
    });
}

- (BOOL)isARVideoWithExhibitID:(NSString *)exhibit_id{
    BOOL hasVideo = [[self.videoAry.rac_sequence filter:^BOOL(KudanVideoModel *value) {
        return [exhibit_id isEqualToString:value.name];
    }]array].count > 0;
    return hasVideo;
}

//- (void)setResourcePath:(NSString *)resourcePath{
//    if (_resourcePath != resourcePath) {
//        for (ARNode *node in self.videoNodeAry) {
//            [node remove];
//        }
//        _resourcePath = resourcePath;
//        self.videoAry = nil;
//        self.namesAry = nil;
//        self.videoNodeAry = nil;
//        [self setupContent];
//    }
//}



- (void)hiddenVideo{
        NSArray *video=[[self.videoAry.rac_sequence filter:^BOOL(KudanVideoModel *value) {
            return [self.curTrackable.name isEqualToString:value.name];
        }]array];
        if (video.count > 0) { //
            KudanVideoModel *vodeX = [video firstObject];
            ARAlphaVideoNode *nodeV;
//            ARImageNode *nodeImg;
            if (vodeX.isfollow) {
                nodeV = (ARAlphaVideoNode *)[self.curTrackable.world findChildWithName:self.curTrackable.name];
            }else{
                nodeV = (ARAlphaVideoNode *)[self.cameraView.contentViewPort.camera findChildWithName:self.curTrackable.name];
//                NSString *trackName = [NSString stringWithFormat:@"%@-image",self.curTrackable.name];
//                nodeImg =  (ARImageNode *)[self.cameraView.contentViewPort.camera findChildWithName:trackName];
            }
            [nodeV.videoTexture reset];
//            [nodeImg setVisible:NO];
            [nodeV setVisible:NO];
            self.playVideo = NO;
            self.curTrackable = nil;
        }


}


- (void)lostTracked:(ARImageTrackable *)sender{
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSString *ex_id = [Communtil exhibit_id:self.curTrackable.name];
        NSArray *video =[[self.videoAry.rac_sequence filter:^BOOL(KudanVideoModel *value) {
            return [ex_id isEqualToString:value.name];
        }]array];
        if (video.count > 0) {
            KudanVideoModel *vodeX = [video firstObject];
            if (self.playVideo&&!vodeX.isfollow) {
                return;
            }
            if (vodeX.isfollow) {
                [self hiddenVideo];
            }
        }
        if (self.curTrackable) {
            self.curTrackable = nil;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(kudanLostTrack)]) {
            [self.delegate kudanLostTrack];
        }
    });
}

//- (void)videoWasTouched:(id)sender{
//    if ([sender isKindOfClass:[ARAlphaVideoNode class]]) {
//        ARAlphaVideoNode *node = (ARAlphaVideoNode *)sender;
//        [node.videoTexture reset];
//        [node setVisible:NO];
//        if (self.delegate && [self.delegate respondsToSelector:@selector(kudanFinishVideo:)]) {
//            [self.delegate kudanFinishVideo:exhibit_id];
//        }
//    }
//}

- (NSArray *)namesAry{
    if (!_namesAry) {
        NSString *path = [self.resourcePath stringByAppendingPathComponent:@"names.json"];
        NSDictionary *names = [Communtil readlocalJsonFile:path];
        if (!names) {
            _namesAry = [NSArray array];
        }else{
            _namesAry = [names objectForKey:@"objects"];
        }
        
    }
    return _namesAry;
}
- (NSString *)exhibit_id:(NSString *)exid{
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
        NSString *path = [self.resourcePath stringByAppendingPathComponent:@"videonew.json"];
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


// Returns the correct orientation for the wall target node for various device orientations
- (ARQuaternion *)wallOrientationForDeviceOrientation:(UIDeviceOrientation)orientation
{
    switch (orientation)
    {
        case UIDeviceOrientationPortrait:
            return [ARQuaternion quaternionWithDegrees:-90 axisX:0 y:0 z:1];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            return [ARQuaternion quaternionWithDegrees:90 axisX:0 y:0 z:1];
            break;
        case UIDeviceOrientationLandscapeLeft:
            return [ARQuaternion quaternionWithDegrees:-180 axisX:0 y:0 z:1];
            break;
        case UIDeviceOrientationLandscapeRight:
            return [ARQuaternion quaternionWithIdentity];
            break;
        default:
            return [ARQuaternion quaternionWithDegrees:-90 axisX:0 y:0 z:1];
            break;
    }
}

- (NSMutableArray *)videoNodeAry{
    if (!_videoNodeAry) {
        _videoNodeAry = [NSMutableArray array];
    }
    return _videoNodeAry;
}




@end
