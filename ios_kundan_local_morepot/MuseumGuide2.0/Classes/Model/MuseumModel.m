//
//  MuseumModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/14.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MuseumModel.h"
#import "FileUtil+Museum.h"

@implementation MuseumModel

- (NSString *)cacheResourceDir{
    return [[FileUtil cache:AR_FILEPATH museum_id:self.museum_id fileURL:self.resourceurl] stringByDeletingPathExtension];
}

- (BOOL)isEqualToMuseum:(MuseumModel *)object{
    return [self.museum_id isEqualToString:object.museum_id];
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"payment":@"MuseumPayment"};
}

- (void)setGps:(NSString *)gps{
    NSArray *gpsAry = [gps componentsSeparatedByString:@","];
    if (gpsAry.count == 2) {
        self.latitude = [gpsAry[1] floatValue];
        self.longitude = [gpsAry[0] floatValue];
    }
}



@end


@implementation MuseumPayment

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"pay_id":@"id"};
}




@end
