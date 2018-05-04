//
// NAMapView.h
// NAMapKit
//
// Created by Neil Ang on 21/07/10.
// Copyright 2010 neilang.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAAnnotation.h"
#import "NACallOutView.h"
@class SVGKImage;

typedef NS_ENUM(NSInteger, NAAnnotationType) {
    NAAnnotationTypePin,//大头针，用于展示展品
    NAAnnotationTypeNav,//定位，用于导航定位
    NAAnnotationTypeLoc,//地点，用于暂时公共设施等
};


@interface NAMapView : UIScrollView

@property (nonatomic, assign) CGSize          orignalSize;

- (void)displayMap:(UIImage *)map;
- (void)displaySVGMap:(SVGKImage *)map;
- (void)addAnnotation:(NAAnnotation *)annotation animated:(BOOL)animate;
- (void)addNavAnnotation:(NAAnnotation *)annotation imageName:(NSString*)imageName animated:(BOOL)animate;
- (void)addPinAnnotation:(NAAnnotation *)annotation imageName:(NSString*)imageName animated:(BOOL)animate;
- (void)addLocAnnotation:(NAAnnotation *)annotation locName:(NSString*)locName animated:(BOOL)animate;

- (void)removeAllAnnotations:(BOOL)animate;
- (void)removeAnnotations:(NAAnnotationType )annotationType animate:(BOOL)animate;

- (void)hideCallOut;
- (IBAction)showCallOut:(id)sender;
- (void)centreOnPoint:(CGPoint)point animated:(BOOL)animate;



@end
