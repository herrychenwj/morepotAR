//
//  GenderSettingViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/4/5.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "GenderSettingViewController.h"
#import "PickerToolBar.h"


@interface GenderSettingViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)UIPickerView *genderPicker;
@property (nonatomic,strong)PickerToolBar *toolBar;
@property (nonatomic,copy)void(^selectGender)(NSString*);
@end

@implementation GenderSettingViewController


+ (GenderSettingViewController *)genderControllerDoneAction:(void(^)(NSString*))doneAction{
    GenderSettingViewController *vc = [[GenderSettingViewController alloc]init];
    vc.selectGender = doneAction;
    return vc;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    return row == 0 ? [TXSakuraManager tx_stringWithPath:@"boy"]:[TXSakuraManager tx_stringWithPath:@"girl"];
}

- (void)initUI{
    _genderPicker = ({
        UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectZero];
        picker.delegate = self;
        picker.dataSource = self;
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
    [self.genderPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@200);
    }];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.genderPicker.mas_top).offset(-1);
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
        [Communtil playClickSound];
        @strongify(self);
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [[self.toolBar.doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        [Communtil playClickSound];
        if (self.selectGender) {
            self.selectGender(([self.genderPicker selectedRowInComponent:0]== 0)? @"男":@"女");
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}


@end
