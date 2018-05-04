//
// NAAnnotationView.m
// NAMapKit
//
// Created by Neil Ang on 21/07/10.
// Copyright 2010 neilang.com. All rights reserved.
//

#import "NAAnnotationView.h"
#import "NAMapView.h"
#import "NACallOutView.h"
#import <QuartzCore/QuartzCore.h>

#define RED_PIN             @"pinRed.png"
#define NAV_WIDTH           50
#define NAV_HEIGHT          50
#define PIN_WIDTH           34.0
#define PIN_HEIGHT          54.0
#define PIN_POINT_X         8.0
#define PIN_POINT_Y         35.0
#define CALLOUT_OFFSET_X    7.0
#define CALLOUT_OFFSET_Y    5.0

@implementation NAAnnotationView

@synthesize annotation = _annotation;
@synthesize annotationType = _annotationType;

- (id)initWithAnnotation:(NAAnnotation *)annotation onView:(NAMapView *)mapView animated:(BOOL)animate {

	if ((self = [super init])) {
		self.annotation = annotation;
		self.frame      = [self frameForPin:self.annotation.point];

		[self setImage:[UIImage imageNamed:RED_PIN] forState:UIControlStateNormal];

		[self addTarget:mapView action:@selector(showCallOut:) forControlEvents:UIControlEventTouchDown];

		// if no title is set, the pin can't be tapped
		if (!self.annotation.title) {
			[self setImage:[UIImage imageNamed:RED_PIN] forState:UIControlStateDisabled];
			self.enabled = self.annotation.title ? YES : NO;
		}

		[mapView addSubview:self];

		if (animate) {
			CABasicAnimation *pindrop = [CABasicAnimation animationWithKeyPath:@"position.y"];
			pindrop.duration       = 0.5f;
			pindrop.fromValue      = [NSNumber numberWithFloat:self.center.y - mapView.frame.size.height];
			pindrop.toValue        = [NSNumber numberWithFloat:self.center.y];
			pindrop.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
			[self.layer addAnimation:pindrop forKey:@"pindrop"];
		}
	}

	return self;
}


- (id)initWithNavAnnotation:(NAAnnotation *)annotation imageName:(NSString*)imageName onView:(NAMapView *)mapView animated:(BOOL)animate{
    
    if ((self = [super init]))
    {
        self.annotation = annotation;
        self.frame = [self frameForNav:self.annotation.point];
        
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        [self addTarget:mapView action:@selector(showCallOut:) forControlEvents:UIControlEventTouchDown];
        
        // if no title is set, the pin can't be tapped
        if (!self.annotation.title) {
            [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
            self.enabled = self.annotation.title ? YES : NO;
        }
        
        self.annotationType = NAAnnotationTypeNav;
        
        [mapView removeAnnotations:NAAnnotationTypeNav animate:YES];
        [mapView addSubview:self];
        
        if (animate) {
            CABasicAnimation *pindrop = [CABasicAnimation animationWithKeyPath:@"position.y"];
            pindrop.duration       = 0.5f;
            pindrop.fromValue      = [NSNumber numberWithFloat:self.center.y - mapView.frame.size.height];
            pindrop.toValue        = [NSNumber numberWithFloat:self.center.y];
            pindrop.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [self.layer addAnimation:pindrop forKey:@"pindrop"];
        }
    }
    
    return self;
}


- (id)initWithPinAnnotation:(NAAnnotation *)annotation imageName:(NSString*)imageName onView:(NAMapView *)mapView animated:(BOOL)animate{
    
    if ((self = [super init])) {
        self.annotation = annotation;
        self.frame = [self frameForPin:self.annotation.point];
        
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        [self addTarget:mapView action:@selector(showCallOut:) forControlEvents:UIControlEventTouchDown];
        
        // if no title is set, the pin can't be tapped
        if (!self.annotation.title) {
            [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
            self.enabled = self.annotation.title ? YES : NO;
        }
        
        self.annotationType = NAAnnotationTypePin;
        
        [mapView removeAnnotations:NAAnnotationTypePin animate:YES];
        [mapView addSubview:self];
        
        if (animate) {
            CABasicAnimation *pindrop = [CABasicAnimation animationWithKeyPath:@"position.y"];
            pindrop.duration       = 0.5f;
            pindrop.fromValue      = [NSNumber numberWithFloat:self.center.y - mapView.frame.size.height];
            pindrop.toValue        = [NSNumber numberWithFloat:self.center.y];
            pindrop.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [self.layer addAnimation:pindrop forKey:@"pindrop"];
        }
    }
    
    return self;
}


- (id)initWithLocAnnotation:(NAAnnotation *)annotation locName:(NSString*)locName onView:(NAMapView *)mapView animated:(BOOL)animate
{
    
    if ((self = [super init])) {
        self.annotation = annotation;
        
        self.frame = [self frameForLoc:locName point:self.annotation.point];
        
        [self setTitle:locName forState:UIControlStateNormal];
        
        if([[UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPad){
            self.titleLabel.font = [UIFont systemFontOfSize:22];
        }
        else
        {
            self.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        [self addTarget:mapView action:@selector(showCallOut:) forControlEvents:UIControlEventTouchDown];
        
        // if no title is set, the pin can't be tapped
        if (!self.annotation.title) {
            [self setTitle:locName forState:UIControlStateDisabled];
            self.enabled = self.annotation.title ? YES : NO;
        }
        self.annotationType = NAAnnotationTypeLoc;

        [mapView addSubview:self];
        
        if (animate) {
            CABasicAnimation *pindrop = [CABasicAnimation animationWithKeyPath:@"position.y"];
            pindrop.duration       = 0.5f;
            pindrop.fromValue      = [NSNumber numberWithFloat:self.center.y - mapView.frame.size.height];
            pindrop.toValue        = [NSNumber numberWithFloat:self.center.y];
            pindrop.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [self.layer addAnimation:pindrop forKey:@"pindrop"];
        }
    }
    
    return self;
}


- (CGRect)frameForNav:(CGPoint)point
{
    
    float x = point.x - NAV_WIDTH/2;
    float y = point.y - NAV_HEIGHT/2;
    return CGRectMake(round(x), round(y), NAV_WIDTH, NAV_HEIGHT);
}

- (CGRect)frameForPin:(CGPoint)point
{
    // Calculate the offset for the pin point
    //	float x = point.x - PIN_POINT_X; orginal like this
    //	float y = point.y - PIN_POINT_Y;
    float x = point.x - PIN_WIDTH/2;
    float y = point.y - PIN_HEIGHT;
    return CGRectMake(round(x), round(y), PIN_WIDTH, PIN_HEIGHT);
}

- (CGRect)frameForLoc:(NSString *)locName point:(CGPoint)point {
    // Calculate the offset for the pin point
    UIFont *font = [UIFont systemFontOfSize:27];
    CGSize size = [(locName ? locName : @"") sizeWithFont:font constrainedToSize:CGSizeMake(9999, 30) lineBreakMode:NSLineBreakByWordWrapping];
    float x = point.x - size.width/2;
    float y = point.y - size.height;
    return CGRectMake(round(x), round(y), size.width, size.height);
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqual:@"contentSize"])
    {
		NAMapView *mapView = (NAMapView *)object;
        
        CGFloat offsetX = (mapView.bounds.size.width > mapView.contentSize.width)?(mapView.bounds.size.width - mapView.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (mapView.bounds.size.height > mapView.contentSize.height)?(mapView.bounds.size.height - mapView.contentSize.height) * 0.5 : 0.0;
        
		float      width   = (mapView.contentSize.width / mapView.orignalSize.width) * self.annotation.point.x + offsetX;
        float      height  = (mapView.contentSize.height / mapView.orignalSize.height) * self.annotation.point.y + offsetY;
        
        if (self.annotationType == NAAnnotationTypePin)
        {
            self.frame = [self frameForPin:CGPointMake(width, height)];
        }
        else if (self.annotationType == NAAnnotationTypeNav) {
            self.frame = [self frameForNav:CGPointMake(width, height)];
        }
        else if (self.annotationType == NAAnnotationTypeLoc)
        {
            self.frame = [self frameForLoc:self.titleLabel.text point:CGPointMake(width, height)];
        }
	}
}


@end
