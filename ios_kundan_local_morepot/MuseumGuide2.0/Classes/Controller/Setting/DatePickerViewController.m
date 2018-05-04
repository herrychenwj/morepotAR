//
//  DatePickerViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/2.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "DatePickerViewController.h"
#import "PickerToolBar.h"

@interface DatePickerViewController ()
@property (nonatomic,strong)UIDatePicker *datePicker;
@property (nonatomic,strong)PickerToolBar *toolBar;
@property (nonatomic,copy)void(^selectDate)(NSDate*);
@end

@implementation DatePickerViewController
+ (DatePickerViewController *)datePickerWithDoneAction:(void(^)(NSDate*))doneAction{
    DatePickerViewController *vc = [[DatePickerViewController alloc]init];
    vc.selectDate = doneAction;
    return vc;
}


- (void)initUI{
    _datePicker = ({
        UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectZero];
        picker.datePickerMode = UIDatePickerModeDate;
        NSLocale *locale;
        if ([[TXSakuraManager getSakuraCurrentName] isEqualToString:@"Localizable_en"]) {
            locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        }else{
            locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        }
        picker.locale = locale;
        picker.maximumDate = [NSDate date];
        picker.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:picker];
        picker;
    });
    _toolBar = ({
        PickerToolBar *toolBar = [[PickerToolBar alloc]initWithFrame:CGRectZero];
        [self.view addSubview:toolBar];
        toolBar;
    });
    UIControl *tmpControl = [[UIControl alloc]initWithFrame:CGRectZero];
    tmpControl.backgroundColor = HexRGBAlpha(0x000000, 0.4);
    [self.view addSubview:tmpControl];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@200);
    }];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.datePicker.mas_top).offset(-1);
    }];
    [tmpControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.toolBar.mas_top);
    }];
    @weakify(self);
    [[tmpControl rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [[self.toolBar.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [[self.toolBar.doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if (self.selectDate) {
            self.selectDate(self.datePicker.date);
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}



@end


