//
//  NAMapView+Cache.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/15.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "NAMapView+Cache.h"


#import "SVGKImage.h"

@implementation NAMapView (Cache)

- (void)displaySVGMapWithURL:(NSString *)url museum_id:(NSString *)museum_id{
    NSData *data = [NSData dataWithContentsOfFile:url];
    if (data) {
        SVGKImage *svgImg = [SVGKImage imageWithData:data];
        [self displaySVGMap:svgImg];
    }
}
@end
