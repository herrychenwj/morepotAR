//
//  XMLHelper.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/9/20.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLHelper : NSObject<NSXMLParserDelegate> {
    
    //解析器
    NSXMLParser *xmlParser;
    //解析元素
    NSMutableArray *xmlElements;
    //解析结果
    NSMutableDictionary *dictionary;
    //临时串变量
    NSMutableString *contentString;
}
//输入参数为xml格式串，初始化解析器
-(void)startParse:(NSData *)data;
//获取解析后的字典
-(NSMutableDictionary*) getDict;

@end
