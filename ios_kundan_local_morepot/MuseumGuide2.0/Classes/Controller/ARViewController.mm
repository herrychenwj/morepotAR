//
//  ARViewController.m
//  MesumeGuide
//
//  Created by lintao on 15/5/13.
//  Copyright (c) 2015年 heinqi. All rights reserved.
//

#import "ARViewController.h"
#import "Communtil.h"
#import <GLKit/GLKView.h>
#import "CurrentMuseum.h"
#import "FileUtil.h"
#import "MBProgressHUD+Add.h"

@interface ARViewController ()
@property (nonatomic,strong)NSArray *videoAry;

@end

@implementation ARViewController





- (void)viewDidLoad{
    [super viewDidLoad];
    
}



- (void)stopTracking{
    m_pMetaioSDK->pauseTracking();
}
- (void)startTracking{
    m_pMetaioSDK->resumeTracking();
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    m_pMetaioSDK->startCamera();

}


- (void)configMetaio{
    for(int i = 0;i < [self.models count];i++){
        struct model m;
        [[self.models objectAtIndex:i] getValue:&m];
        m.geometry->setVisible(false);
    }
    self.models = nil;
    self.testModels = nil;
    _touchGeometry = nullptr;
    NSDictionary *json = [Communtil readlocalJsonFile:[[CurrentMuseum ARSettingDir]stringByAppendingPathComponent:@"Node.json"]];
    self.models = [NSMutableArray arrayWithCapacity:[json[@"objects"] count]];
    self.testModels = [NSMutableDictionary dictionaryWithCapacity:[json[@"objects"] count]];
    NSString *trackingDataFile = [[CurrentMuseum ARSettingDir]stringByAppendingPathComponent:@"TrackingConfig.zip"];
    const bool success = m_pMetaioSDK->setTrackingConfiguration(metaio::Path::fromUTF8([trackingDataFile UTF8String]));
    if (!success){
        NSLog(@"Failed to load tracking configuration");
        return;
    }
    for (int i = 0; i<[json[@"object"] count]; i++) {
        NSString *path = [[CurrentMuseum ARSettingDir] stringByAppendingPathComponent:json[@"object"][i][@"assets3d"][@"model"]];
        model m;
        m.geometry = m_pMetaioSDK->createGeometry(metaio::Path::fromUTF8([path UTF8String]));
        NSString *name = json[@"object"][i][@"title"];
        m.translation.x = [json[@"object"][i][@"assets3d"][@"transform"][@"translation"][@"x"] floatValue];
        m.translation.y = [json[@"object"][i][@"assets3d"][@"transform"][@"translation"][@"y"] floatValue];
        m.translation.z = [json[@"object"][i][@"assets3d"][@"transform"][@"translation"][@"z"] floatValue];
        
        m.scale.x = [json[@"object"][i][@"assets3d"][@"transform"][@"scale"][@"x"] floatValue];
        m.scale.y = [json[@"object"][i][@"assets3d"][@"transform"][@"scale"][@"y"] floatValue];
        m.scale.z = [json[@"object"][i][@"assets3d"][@"transform"][@"scale"][@"z"] floatValue];
        m.geometry->setTranslation(m.translation);
        m.geometry->setScale(m.scale);
        metaio::Rotation rotation = metaio::Rotation(metaio::Vector3d([json[@"object"][i][@"assets3d"][@"transform"][@"rotation"][@"x"] floatValue]/180.0f*M_PI,[json[@"object"][i][@"assets3d"][@"transform"][@"rotation"][@"y"] floatValue]/180.0f*M_PI,[json[@"object"][i][@"assets3d"][@"transform"][@"rotation"][@"z"] floatValue]/180.0f*M_PI));
        m.geometry->setRotation(rotation);
        m.geometry->setCoordinateSystemID([json[@"object"][i][@"assets3d"][@"properties"][@"coordinatesystemid"] intValue]);
        m.geometry->setName([name UTF8String]);
        m.geometry->setBillboardModeEnabled(true);
        self.models[i] = [NSValue value:&m withObjCType:@encode(struct model)];
        [self putMyObject:[NSValue value:&m.geometry withObjCType:@encode(struct metaio::IGeometry)] index:[NSNumber numberWithInt:m.geometry->getCoordinateSystemID()]];
    }
}

- (void)onTrackingEvent:(const metaio::stlcompat::Vector<metaio::TrackingValues>&)trackingValues
{
    metaio::IGeometry *g;
    std::string idName;
    for (int i = 0; i < trackingValues.size(); i++){
        metaio::TrackingValues tv = trackingValues[i];
        NSLog(@"CoordinateSystemID is %d",tv.coordinateSystemID);
        NSMutableArray *objArray = [_testModels objectForKey:[NSNumber numberWithInt:tv.coordinateSystemID]];
        for(int i = 0;i<[objArray count];i++){
            NSValue *obj = [objArray objectAtIndex:i];
            [obj getValue:&g];
            std::string tempName = g->getName();
            int isAR = tempName.find("AR");
            if(isAR == -1){
                idName = tempName;
            }else{
                continue;
            }
        }
        if (tv.isTrackingState()){
            if ([Communtil app_firstlunching] && self.firstScan) {
                self.firstScan();
            }
            [Communtil playExhitbitSound];
            self.hiddenLB = YES;
        }
    }
    if (trackingValues.empty() || !trackingValues[0].isTrackingState()){
        [self showLabel];
        self.hiddenLB = NO;
        if (_m_moviePlane) {
            _m_moviePlane->stopMovieTexture();
            _m_moviePlane->removeMovieTexture();
            _m_moviePlane->setVisible(false);
        }
    }
}

- (void)onMovieEnd:(metaio::IGeometry*)geometry andMoviePath:(const NSString*) moviePath{
    NSLog(@"movie ended: %@", moviePath);
    geometry->startMovieTexture();
    geometry->setVisible(false);
    geometry->stopMovieTexture();
    [self showLabel];
}


#pragma mark - Handling Touches
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    // Here's how to pick a geometry
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.glkView];
    NSLog(@"touch point %f %f",loc.x,loc.y);
    // get the scale factor (will be 2 for retina screens)
    const float scale = self.glkView.contentScaleFactor;
    metaio::IGeometry* geometry = m_pMetaioSDK->getGeometryFromViewportCoordinates(loc.x * scale, loc.y * scale, true);
    if(geometry){
        NSString* compareName = [NSString stringWithUTF8String:geometry->getName().c_str()];
        if ([compareName isEqualToString:@"MOVIE"]) { //视频正在播放 暂停播放
            if (_m_moviePlane) {
                _m_moviePlane->stopMovieTexture();
                _m_moviePlane->removeMovieTexture();
                _m_moviePlane->setVisible(false);
                [self showLabel];
            }
            return;
        }
        if (![compareName hasPrefix:@"AR_"]) {
            if (self.gotoExhibitDetail) {
                self.gotoExhibitDetail(compareName);
            }
            return;
        }
       [[[self.videoAry.rac_sequence filter:^BOOL(id value) {
            return [[value objectForKey:@"name"] isEqualToString:compareName];
        }] signal]subscribeNext:^(NSDictionary *x) {
                NSDictionary *tempDic = x;
                NSString *vedioname = (NSString*)tempDic[@"vedioname"];
                NSString *coorid = tempDic[@"coordid"];
                NSString *XStr =tempDic[@"x"];
                NSString *YStr =tempDic[@"y"];
                NSString *ZStr =tempDic[@"z"];
                NSString *scaleStr =tempDic[@"scale"];
                float X = [XStr floatValue];
                float Y = [YStr floatValue];
                float Z = [ZStr floatValue];
                float scale = [scaleStr floatValue];
                NSString *moviePath = [[CurrentMuseum ARSettingDir] stringByAppendingPathComponent:vedioname];
                const char *utf8Path = [moviePath UTF8String];
             dispatch_sync(dispatch_get_main_queue(), ^{
                if (moviePath) {
                    _m_moviePlane =  m_pMetaioSDK->createGeometryFromMovie(metaio::Path::fromUTF8(utf8Path), true); // true for transparent movie
                    if( _m_moviePlane){
                        _m_moviePlane->setVisible(false);
                        _m_moviePlane->setTranslation(metaio::Vector3d(X,Y,Z));
                        _m_moviePlane->setScale(scale);
                        _m_moviePlane->setBillboardModeEnabled(true);
                        _m_moviePlane->setCoordinateSystemID([coorid intValue]);
                      //_m_moviePlane->setName(geometry->getName());
                        _m_moviePlane->setName([@"MOVIE" UTF8String]);
                        [self hideLabel];
                        self.hiddenLB = YES;
                        _m_moviePlane->setVisible(true);
                        _m_moviePlane->startMovieTexture(true);
                        //停止追踪
//                        m_pMetaioSDK->pauseTracking();
                        if ([Communtil app_firstlunching] && self.noshowFirst){
                            self.noshowFirst();
                        }
                        return;
                    }
                }

            });
        }];
        
//        for (NSDictionary *tempDic in self.videoAry) {
//            NSString *vedioname = (NSString*)tempDic[@"vedioname"];
//            NSString *coorid = tempDic[@"coordid"];
//            NSString *playname = tempDic[@"name"];
//            NSString *XStr =tempDic[@"x"];
//            NSString *YStr =tempDic[@"y"];
//            NSString *ZStr =tempDic[@"z"];
//            NSString *scaleStr =tempDic[@"scale"];
//            float X = [XStr floatValue];
//            float Y = [YStr floatValue];
//            float Z = [ZStr floatValue];
//            float scale = [scaleStr floatValue];
//            if ([compareName isEqualToString:playname] ) { // 如果与当前的名称匹配 就加载对应的视频
//                NSString *moviePath = [[CurrentMuseum ARSettingDir] stringByAppendingPathComponent:vedioname];
//                const char *utf8Path = [moviePath UTF8String];
//                if (moviePath) {
//                    _m_moviePlane =  m_pMetaioSDK->createGeometryFromMovie(metaio::Path::fromUTF8(utf8Path), true); // true for transparent movie
//                    if( _m_moviePlane)
//                    {
//                        _m_moviePlane->setVisible(false);
//                        _m_moviePlane->setTranslation(metaio::Vector3d(X,Y,Z));
//                        _m_moviePlane->setScale(scale);
//                        _m_moviePlane->setBillboardModeEnabled(true);
//                        _m_moviePlane->setCoordinateSystemID([coorid intValue]);
//                        _m_moviePlane->setName(geometry->getName());
//                        //                            [self hideLabel];
//                        self.hiddenLB = YES;
//                        _m_moviePlane->setVisible(true);
//                        _m_moviePlane->startMovieTexture(true);
//                        return;
//                    }
//                }
//                
//            }
//        }
        
//        for (NSDictionary *tempDic in self.videoAry) {
//            NSString *vedioname = (NSString*)tempDic[@"vedioname"];
//            NSString *prename = [vedioname componentsSeparatedByString:@"."][0];
//            if ([vedioname hasPrefix:compareName]) {
//                //                    [self showLabel];
//                self.hiddenLB = NO;
//                _m_moviePlane->stopMovieTexture();
//                _m_moviePlane->removeMovieTexture();
//                _m_moviePlane->setVisible(false);
//                _m_moviePlane = nil;
//                return;
//            }
//        }
        
    }else{

        if (self.showItem) {
            self.showItem();
        }
        //        [((HomeViewController *)[self parentViewController]) showHomePageButtonAction:nil];
    }
}


-(void)hideLabel{
    if(_touchGeometry)
        _touchGeometry->setVisible(false);
    for(int i = 0;i < [self.models count];i++){
        struct model m;
        [[self.models objectAtIndex:i] getValue:&m];
        m.geometry->setVisible(false);
    }
}

-(void)showLabel
{
    if(_touchGeometry)
        _touchGeometry->setVisible(true);
    for(int i = 0;i < [self.models count];i++){
        struct model m;
        [[self.models objectAtIndex:i] getValue:&m];
        m.geometry->setVisible(true);
    }
}

#pragma mark lazy load
- (NSArray *)videoAry{
    if (!_videoAry) {
        NSDictionary *dic = [Communtil readlocalJsonFile:[[CurrentMuseum ARSettingDir] stringByAppendingPathComponent:@"video.json"]];
        _videoAry = [dic objectForKey:@"objects"];
    }
    return _videoAry;
}

- (void) putMyObject:(NSValue *)obj index:(NSNumber *)i
{
    NSMutableArray * myList = [self.testModels objectForKey:i];
    if(myList == NULL)
    {
        myList = [[NSMutableArray alloc] init];
        [_testModels setObject:myList forKey:i];
    }
    [myList addObject:obj];
}


@end
