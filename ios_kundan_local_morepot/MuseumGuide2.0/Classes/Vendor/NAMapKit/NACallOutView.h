//
// NACallOutView.h
// NAMapKit
//
// Created by Neil Ang on 23/07/10.
// Copyright 2010 neilang.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAAnnotation.h"


@class NAMapView;

@interface NACallOutView : UIView

- (id)initWithAnnotation:(NAAnnotation *)annotation onMap:(NAMapView *)mapView;
- (void)displayAnnotation:(NAAnnotation *)annotation;




@end
