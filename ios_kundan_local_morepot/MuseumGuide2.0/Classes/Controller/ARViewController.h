//
//  ARViewController.h
//  MesumeGuide
//
//  Created by lintao on 15/5/13.
//  Copyright (c) 2015年 heinqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MetaioSDK/MetaioSDKViewController.h>

struct model{
    metaio::IGeometry* geometry;
    metaio::Vector3d translation;
    metaio::Vector3d scale;
    metaio::Rotation rotation;
    
};
@interface ARViewController : MetaioSDKViewController
@property (nonatomic,strong)NSMutableArray *models;
@property (nonatomic,strong)NSMutableDictionary *testModels;
@property metaio::IGeometry *touchGeometry;
@property metaio::IGeometry* m_moviePlane;
@property (nonatomic,copy)void(^gotoExhibitDetail)(NSString*);
@property (nonatomic,assign)BOOL hiddenLB;
@property (nonatomic,copy)void(^showItem)();
@property (nonatomic,copy)void(^firstScan)();
@property (nonatomic,copy)void(^noshowFirst)();

- (void)configMetaio;

- (void)showLabel;
-(void)hideLabel;

- (void)stopTracking;
- (void)startTracking;


@end
