//
// NAAnnotationView.h
// NAMapKit
//
// Created by Neil Ang on 21/07/10.
// Copyright 2010 neilang.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAAnnotation.h"
#import "NACallOutView.h"
#import "NAMapView.h"



@interface NAAnnotationView : UIButton {
	@private
	NAAnnotation *_annotation;
    NAAnnotationType _annotationType;
}

- (CGRect)frameForNav:(CGPoint)point;
- (CGRect)frameForPin:(CGPoint)point;
- (CGRect)frameForLoc:(NSString *)locName point:(CGPoint)point;

- (id)initWithAnnotation:(NAAnnotation *)annotation onView:(NAMapView *)mapView animated:(BOOL)animate;
- (id)initWithNavAnnotation:(NAAnnotation *)annotation imageName:(NSString*)imageName onView:(NAMapView *)mapView animated:(BOOL)animate;
- (id)initWithPinAnnotation:(NAAnnotation *)annotation imageName:(NSString*)imageName onView:(NAMapView *)mapView animated:(BOOL)animate;
- (id)initWithLocAnnotation:(NAAnnotation *)annotation locName:(NSString*)locName onView:(NAMapView *)mapView animated:(BOOL)animate;

@property (nonatomic, strong) NAAnnotation *annotation;
@property (nonatomic, assign) NAAnnotationType annotationType;

@end
