//
//  UserCenterSettingViewController.m
//  PRO_TEST
//
//  Created by Mr.Huang on 2017/7/13.
//  Copyright © 2017年 Mr.Huang. All rights reserved.
//

#import "UserCenterSettingViewController.h"
#import "UserCenterListTableViewCell.h"
#import "SystemGuideViewController.h"
#import "UserInfoModel.h"
#import "LoginViewController.h"
#import "UserSettingViewModel.h"
#import "SystemAboutViewController.h"
#import "MBProgressHUD+Add.h"
#import "LanguageViewController.h"
#import "RootTarBarController.h"


@interface UserCenterSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong)UserSettingViewModel *viewModel;

@end

static NSString *const cellID = @"UserCenterListTableViewCell";

@implementation UserCenterSettingViewController


- (void)initUI{
    [self setBackTitle:[TXSakuraManager tx_stringWithPath:@"system_setting"]];
    self.backBtn.titleLB.sakura.text(@"system_setting");
    self.view.backgroundColor = HexRGB(0x202126);
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerClass:[UserCenterListTableViewCell class] forCellReuseIdentifier:cellID];
        tableView.rowHeight = 50;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(IPHONE_DEVICE?(IPHONEX_DEVICE?60:40):120, IPHONE_DEVICE?0:kPADSETTING_LEFTMARGIN, 0, IPHONE_DEVICE?0:90));
    }];
}

#pragma mark BindViewModel

- (void)bindViewModel{
    self.viewModel = [[UserSettingViewModel alloc]initWithHUDShowView:self.view];
    @weakify(self);
    [self.viewModel.cleanCacheCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        RootTarBarController *tab = (RootTarBarController *)self.tabBarController;
        tab.arVC.museum = nil;
        [MBProgressHUD showMessag:[TXSakuraManager tx_stringWithPath:@"clean_finish"] toView:self.view];
    }];
}


#pragma mark UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataAry[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCenterListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.cellType = ListCellTypeSwitch;
        cell.switchX.on = [[[NSUserDefaults standardUserDefaults]objectForKey:kUSERSETTING_SOUND] boolValue];
        [[[cell.switchX rac_signalForControlEvents:UIControlEventValueChanged]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(UISwitch *x) {
            [[NSUserDefaults standardUserDefaults]setObject:@(x.isOn) forKey:kUSERSETTING_SOUND];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [Communtil playClickSound];
        }];
    }else if (indexPath.section == 1){
        cell.cellType = ListCellTypeNone;
    }else{
        cell.cellType = ListCellTypeArrow;
    }
    NSDictionary *dic = self.dataAry[indexPath.section][indexPath.row];
    cell.iconView.image = [UIImage imageNamed:dic[@"icon"]];
    cell.titleLabel.sakura.text(dic[@"title"]);
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.titleLabel.sakura.text([Communtil isLogin]?@"exit_login":@"fastlogin");
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    if (!(indexPath.section == 0 && indexPath.row == 0)) {
        [Communtil playClickSound];
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        //退出登录
        if ([Communtil isLogin]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kACCESS_TOKEN];
            [UserInfoModel cleanInfo];
            [MBProgressHUD showMessag:[TXSakuraManager tx_stringWithPath:@"exit_login_su"] toView:self.view];
            [self.tableView reloadData];
        }else{
            LoginViewController *vc = [LoginViewController loginControllerWithLoginSuccess:^{
                @strongify(self);
                //登录成功
                [self.tableView reloadData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        switch (indexPath.row) {
                case 1:{
                    SystemAboutViewController *vc = [[SystemAboutViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                case 2:{
                    SystemGuideViewController *vc = [[SystemGuideViewController alloc]init];
                    vc.type = SystemAbout;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                break;
                case 3:{
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:[TXSakuraManager tx_stringWithPath:@"prompt_clean"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:[TXSakuraManager tx_stringWithPath:@"commit"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        @strongify(self);
                        [self.viewModel.cleanCacheCmd execute:nil];
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[TXSakuraManager tx_stringWithPath:@"cancle"] style:UIAlertActionStyleCancel handler:nil];
                    [alertVC addAction:cancelAction];
                    [alertVC addAction:doneAction];
                    [self presentViewController:alertVC animated:YES completion:nil];
                }
                break;
            case 4:{
//            https://itunes.apple.com/us/app/%E4%BA%91%E8%A7%82%E5%8D%9A/id1231337446
                NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/%E4%BA%91%E8%A7%82%E5%8D%9A/id1231337446?mt=8&action=write-review"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
                break;
            case 5:{
                LanguageViewController *vc = [[LanguageViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark Lazy load
- (NSMutableArray *)dataAry{
    if (!_dataAry) {
        _dataAry = [@[@[@{@"icon":@"user_sound",@"title":@"system_sounds"},@{@"icon":@"user_explain",@"title":@"system_instructions"},@{@"icon":@"user_about",@"title":@"about_us_button"},@{@"icon":@"user_cache",@"title":@"clear_cache"},@{@"icon":@"setting_knel",@"title":@"coment_market"},@{@"icon":@"language",@"title":@"language"}],@[@{@"icon":@"user_loginout",@"title":@""}]] mutableCopy];
    }
    return _dataAry;
}

@end
