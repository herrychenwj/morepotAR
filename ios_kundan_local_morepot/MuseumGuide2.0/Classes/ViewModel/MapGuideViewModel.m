//
//  MapGuideViewModel.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/15.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "MapGuideViewModel.h"
#import "TopExhibitionModel.h"
#import "MapModel.h"
#import "ApiFactory+Tour.h"

@interface MapGuideViewModel ()

@property (nonatomic,strong,readwrite)RACCommand *mapInfoCmd;
@property (nonatomic,strong,readwrite)RACCommand *topExhibitionCmd;

@end

@implementation MapGuideViewModel


- (RACCommand *)mapInfoCmd{
    if (!_mapInfoCmd) {
        @weakify(self);
        _mapInfoCmd =  [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[ApiFactory tour_mapinfo:self.basicInfo.museum_id] showErrorMsgTo:self.hudView] map:^id(id value) {
                return [MapModel mj_objectArrayWithKeyValuesArray:[value objectForKey:@"maps"]];
            }];
        }];
    }
    return _mapInfoCmd;
}

- (RACCommand *)topExhibitionCmd{
    if (!_topExhibitionCmd) {
        @weakify(self);
        _topExhibitionCmd =  [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [[[ApiFactory tour_topexhibition:self.basicInfo.museum_id] showErrorMsgTo:self.hudView]map:^id(id value) {
                return [TopExhibitionModel mj_objectArrayWithKeyValuesArray:[value objectForKey:@"exhibits"]];
            }];
        }];
    }
    return _topExhibitionCmd;
}










@end
