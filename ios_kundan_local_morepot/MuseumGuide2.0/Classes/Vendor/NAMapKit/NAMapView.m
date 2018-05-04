//
// NAMapView.m
// NAMapKit
//
// Created by Neil Ang on 21/07/10.
// Copyright 2010 neilang.com. All rights reserved.
//

#import "NAMapView.h"
#import "NAAnnotationView.h"
#import "SVGKFastImageView.h"
#define ZOOM_STEP       0.8


@interface NAMapView ()<UIScrollViewDelegate>

@property (nonatomic, strong) SVGKImageView    *customMap;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) NACallOutView  *callout;
@property (nonatomic, strong) NAAnnotationView *markView;

@property (nonatomic, assign) CGPoint *offsetPoint;
@property (nonatomic, assign) float scaleXY;

@end


@implementation NAMapView


#pragma mark NAMapView class


- (void)awakeFromNib {
	self.delegate                       = self;
	self.showsHorizontalScrollIndicator = NO;
	self.showsVerticalScrollIndicator   = NO;

	[self setUserInteractionEnabled:YES];

	UITapGestureRecognizer *doubleTap    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
	UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];

	[doubleTap setNumberOfTapsRequired:2];
	[twoFingerTap setNumberOfTouchesRequired:2];

	[self addGestureRecognizer:doubleTap];
	[self addGestureRecognizer:twoFingerTap];
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate                       = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        
        [self setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *doubleTap    = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
        
        [doubleTap setNumberOfTapsRequired:2];
        [twoFingerTap setNumberOfTouchesRequired:2];
        
        [self addGestureRecognizer:doubleTap];
        [self addGestureRecognizer:twoFingerTap];
    }
    return self;
}


#pragma mark Tap to Zoom

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
	// double tap zooms in, but returns to normal zoom level if it reaches max zoom
	float newScale = self.zoomScale >= self.maximumZoomScale ? self.minimumZoomScale : self.zoomScale * ZOOM_STEP;
	[self setZoomScale:newScale animated:YES];
}

- (void)handleTwoFingerTap:(UIGestureRecognizer *)gestureRecognizer {
	// two-finger tap zooms out, but returns to normal zoom level if it reaches min zoom
	float newScale = self.zoomScale <= self.minimumZoomScale ? self.maximumZoomScale : self.zoomScale / ZOOM_STEP;
	[self setZoomScale:newScale animated:YES];
   
}

- (void)displaySVGMap:(SVGKImage *)map {
    
    SVGKImageView *imageView;
    
    if (self.customMap) {
        self.customMap.image = nil;
        [self.customMap removeFromSuperview];
    }
    imageView = [[SVGKLayeredImageView alloc]initWithSVGKImage:map];
//    imageView = [[SVGKFastImageView alloc] initWithSVGKImage:map];
    imageView.contentMode = UIViewContentModeScaleAspectFit|UIViewContentModeCenter;
    imageView.userInteractionEnabled = YES;
    self.customMap = imageView;
    
    [self addSubview:self.customMap];
    
    [self layoutIfNeeded];
    
    // --删掉下面内容 暂时没有发现有什么异常
    // --（删除后加不了点）
    CGFloat widthMinimumZoomScale = [self frame].size.width / [self.customMap frame].size.width;// / (self.customMap.frame.size.width / self.frame.size.width);
    CGFloat heightMinimumZoomScale = [self frame].size.height / [self.customMap frame].size.height;// / (self.customMap.frame.size.height / self.frame.size.height);
    CGFloat minimumZoomScale = widthMinimumZoomScale > heightMinimumZoomScale ? heightMinimumZoomScale : widthMinimumZoomScale; //取出能使图片居中并全部显示的缩放比例
    
    self.layer.contentsScale = minimumZoomScale;
    self.scaleXY = minimumZoomScale ;

    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) && ([[UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPad)) {
        screenHeight = [UIScreen mainScreen].bounds.size.width;
    }
    
    [self setMinimumZoomScale:minimumZoomScale];
    
    NSLog(@"%@", NSStringFromCGRect(imageView.layer.bounds));
    
    self.orignalSize = CGSizeMake(self.customMap.frame.size.width, self.customMap.frame.size.height);
    self.contentSize = self.orignalSize;
}



- (void)displayMap:(UIImage *)map {
    
    UIImageView *imageView;
    if (self.customMap) {
        [self.customMap removeFromSuperview];
    }
    imageView = [[UIImageView alloc] initWithImage:map];
    imageView.contentMode = UIViewContentModeScaleAspectFit|UIViewContentModeCenter;
    imageView.userInteractionEnabled = YES;
    self.customMap = imageView;
    
    [self addSubview:self.customMap];

    CGFloat widthMinimumZoomScale = [self frame].size.width / [self.customMap frame].size.width;
    CGFloat heightMinimumZoomScale = [self frame].size.height / [self.customMap frame].size.height;
    CGFloat minimumZoomScale = widthMinimumZoomScale > heightMinimumZoomScale ? heightMinimumZoomScale : widthMinimumZoomScale; //取出能使图片居中并全部显示的缩放比例
    self.scaleXY = minimumZoomScale * 0.7;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) && ([[UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPad))
    {
        screenHeight = [UIScreen mainScreen].bounds.size.width;
    }
    
    [self setMinimumZoomScale:minimumZoomScale * 0.7];
    self.orignalSize = CGSizeMake(self.customMap.frame.size.width, self.customMap.frame.size.height);
    self.contentSize = self.orignalSize;
    
}

- (void)addAnnotation:(NAAnnotation *)annotation animated:(BOOL)animate {

    float height = self.contentSize.height / self.orignalSize.height;

    CGPoint annotationpoint = annotation.point;
    CGPoint newpoint = CGPointMake(annotationpoint.x*self.scaleXY, annotationpoint.y*self.scaleXY+height);
    annotation.point = newpoint;

	NAAnnotationView *pinAnnotation = [[NAAnnotationView alloc] initWithAnnotation:annotation onView:self animated:animate];

	if (!_annotations) {
		_annotations = [[NSMutableArray alloc] init]; // Why does this leak?
	}

	[self.annotations addObject:pinAnnotation];
	[self addObserver:pinAnnotation forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addNavAnnotation:(NAAnnotation *)annotation imageName:(NSString*)imageName animated:(BOOL)animate
{
    CGFloat height  = self.contentSize.height / self.orignalSize.height;
    CGFloat width  = self.contentSize.width / self.orignalSize.width;
    
    CGPoint annotationpoint = annotation.point;
    CGPoint newpoint = CGPointMake(annotationpoint.x + width, annotationpoint.y + height);
    annotation.point = newpoint;
    
    NAAnnotationView *pinAnnotation = [[NAAnnotationView alloc] initWithNavAnnotation:annotation imageName:imageName onView:self animated:animate];
    
    if (!self.annotations) {
        NSMutableArray *tempPins = [[NSMutableArray alloc] init];
        self.annotations = tempPins;
    }
    
    [self.annotations addObject:pinAnnotation];
    [self addObserver:pinAnnotation forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)addPinAnnotation:(NAAnnotation *)annotation imageName:(NSString*)imageName animated:(BOOL)animate
{
    
    CGFloat height  = self.contentSize.height / self.orignalSize.height;
    
    CGPoint annotationpoint = annotation.point;

    CGPoint newpoint = CGPointMake(self.orignalSize.width - annotationpoint.x, annotationpoint.y + height);
    annotation.point = newpoint;
    

    NAAnnotationView *pinAnnotation = [[NAAnnotationView alloc] initWithPinAnnotation:annotation imageName:imageName onView:self animated:animate];
    
    if (!self.annotations) {
        NSMutableArray *tempPins = [[NSMutableArray alloc] init];
        self.annotations = tempPins;
    }
    
    [self.annotations addObject:pinAnnotation];
    [self addObserver:pinAnnotation forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}


- (void)addLocAnnotation:(NAAnnotation *)annotation locName:(NSString*)locName animated:(BOOL)animate
{
    
    CGFloat height  = self.contentSize.height / self.orignalSize.height;
    
    CGPoint annotationpoint = annotation.point;
    CGPoint newpoint = CGPointMake(self.orignalSize.width - annotationpoint.x, annotationpoint.y + height);
    annotation.point = newpoint;
    
    NAAnnotationView *pinAnnotation = [[NAAnnotationView alloc] initWithLocAnnotation:annotation locName:locName onView:self animated:animate];

    if (!self.annotations) {
        NSMutableArray *tempPins = [[NSMutableArray alloc] init];
        self.annotations = tempPins;
    }

    [self.annotations addObject:pinAnnotation];
    [self addObserver:pinAnnotation forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addAnnotations:(NSArray *)annotations animated:(BOOL)animate {
	for (NAAnnotation *annotation in annotations) {
		[self addAnnotation:annotation animated:animate];
	}
}


- (void)removeAllAnnotations:(BOOL)animate
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if ([view isKindOfClass:[NAAnnotationView class]]) {
                [view removeFromSuperview];
            }
        }
    }
}

- (void)removeAnnotations:(NAAnnotationType )annotationType animate:(BOOL)animate;
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]])
        {
            if ([view isKindOfClass:[NAAnnotationView class]])
            {
                NAAnnotationView * temp = (NAAnnotationView *)view;
                if (temp.annotationType == annotationType) {
                    [view removeFromSuperview];
                }
            }
        }
    }
}

// The callout should belong to this class...
- (IBAction)showCallOut:(id)sender
{
	for (NAAnnotationView *pin in self.annotations)
    {
		if (pin == sender)
        {
			if (!self.callout)
            {
				// create the callout
                NACallOutView * calloutView = [[NACallOutView alloc] initWithAnnotation:pin.annotation onMap:self];
                self.callout = calloutView;
        
                [self addObserver:self.callout forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
                [self addSubview:self.callout];
			}
            else
            {
				[self hideCallOut];
				[self.callout displayAnnotation:pin.annotation];
			}
			// centre the map
			[self centreOnPoint:pin.annotation.point animated:YES];
			break;
		}
	}
}

- (void)hideCallOut {
	self.callout.hidden = YES;
}

- (void)centreOnPoint:(CGPoint)point animated:(BOOL)animate {
	float x = (point.x * self.zoomScale) - (self.frame.size.width / 2.0f);
	float y = (point.y * self.zoomScale) - (self.frame.size.height / 2.0f);

	[self setContentOffset:CGPointMake(x, y) animated:animate];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!self.dragging) {
		[self hideCallOut];
	}

	[super touchesEnded:touches withEvent:event];
}

- (void)dealloc {
	// Remove observers
	if (self.callout) {
		[self removeObserver:self.callout forKeyPath:@"contentSize"];
	}

	if (self.annotations) {
		for (NAAnnotation *annotation in self.annotations) {
			[self removeObserver:annotation forKeyPath:@"contentSize"];
		}
	}
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.customMap;
}

#pragma scrollview delegate----图片放大到一定大小，加载坐标
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    NSLog(@"ddd");
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (self.bounds.size.width > self.contentSize.width)?(self.bounds.size.width - self.contentSize.width) * 0.5 : 0.0;  // 当待显示图片大小小鱼scrollview 大小时，可据此计算出一个居中的偏移量
    CGFloat offsetY = (self.bounds.size.height > self.contentSize.height)?(self.bounds.size.height - self.contentSize.height) * 0.5 : 0.0;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) && ([[UIDevice currentDevice ] userInterfaceIdiom ] == UIUserInterfaceIdiomPad))
    {
        screenHeight = [UIScreen mainScreen].bounds.size.width;
    }

    self.customMap.center = CGPointMake(self.contentSize.width * 0.5 + offsetX,self.contentSize.height * 0.5 + offsetY);

//    if (scrollView.zoomScale > scrollView.minimumZoomScale) {
//        self.customMap.center = CGPointMake(self.contentSize.width * 0.5 + offsetX, self.contentSize.height * 0.5 + offsetY);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMapSize" object:@"zoomout"];
//    } else {
//        self.customMap.center = CGPointMake(self.contentSize.width * 0.5 + offsetX,self.contentSize.height * 0.5 + offsetY + 50);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateMapSize" object:@"zoomin"];
//    }

    
    if (scrollView.zoomScale >= 1.2) {
        for (UIView *view in self.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                if ([view isKindOfClass:[NAAnnotationView class]])
                {
                    NAAnnotationView * temp = (NAAnnotationView *)view;
                    if (temp.annotationType == NAAnnotationTypeLoc) {
                        view.hidden = NO;
                    }
                }
            }
        }
        
        [self showTextLayer:YES];
        
    } else {
        for (UIView *view in self.subviews)
        {
            if ([view isKindOfClass:[UIButton class]])
            {
                if ([view isKindOfClass:[NAAnnotationView class]])
                {
                    NAAnnotationView * temp = (NAAnnotationView *)view;
                    if (temp.annotationType == NAAnnotationTypeLoc) {
                        view.hidden = YES;
                    }
                }
            }
        }
        
        [self showTextLayer:NO];
    }
}

- (void)showTextLayer:(BOOL)show {
    
    if (self.customMap) {
        
        SVGKImage *svgImage = self.customMap.image;
        
        CALayer *textLayer;
        
        for (CALayer *layer in svgImage.CALayerTree.sublayers) {
            if ([layer.name isEqualToString:@"文字层"]) {
                textLayer = layer;
                break;
            }
        }
        
        if (textLayer) {
            textLayer.opacity = show ? 1 : 0;
        }
    }
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view  // called before the scroll view begins zooming its content
{


}



@end
