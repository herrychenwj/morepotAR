//
//  LoginField.h
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthCodeButtom.h"

typedef NS_ENUM(NSInteger,FieldType){
    FieldTypeUserName,
    FieldTypeCode
};
@interface LoginField : UIView

- (instancetype)initWithFrame:(CGRect)frame FieldType:(FieldType)type;
@property (nonatomic,strong)AuthCodeButtom *codeBtn;
@property (nonatomic,strong)UITextField *textFD;
@property (nonatomic,assign)FieldType fdType;

@end
