//
//  UserInfoViewController.m
//  MuseumGuide2.0
//
//  Created by Mr.Huang on 2017/3/1.
//  Copyright © 2017年 Heyunguanbo. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoTableViewCell.h"
#import "DatePickerViewController.h"
#import "UserInfoViewModel.h"
#import "GenderSettingViewController.h"
#import "QRCodeViewController.h"
#import "LoginViewModel.h"



@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UserInfoViewModel *viewModel;

@end
static NSString *const cellID = @"UserInfoTableViewCell";
@implementation UserInfoViewController

#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:{
            cell.cellType = UserInfoCellTypeImage;
            cell.titleLB.sakura.text(@"changepicture");
            [cell.avatarImg sd_setImageWithURL:[NSURL URLWithString:[UserInfoModel shareInfo].avatarurl] placeholderImage:[UIImage imageNamed:@"userpicture"]];
        }
            break;
        case 1:{
            cell.cellType = UserInfoCellTypeText;
            cell.titleLB.sakura.text(@"changename");
            cell.textLB.text = [UserInfoModel shareInfo].nickname;
        }
            break;
        case 2:{
            cell.cellType = UserInfoCellTypeText;
            cell.titleLB.sakura.text(@"changesex");
            NSString *localizable = [[NSUserDefaults standardUserDefaults]objectForKey:kLOCALIZABLE];
            if ([localizable isEqualToString:@"en"]) {
                if ( [[UserInfoModel shareInfo].sex isEqualToString:@"男"]) {
                    cell.textLB.text = @"male";
                }else{
                    cell.textLB.text = @"female";
                }
            }else{
                cell.textLB.text = [UserInfoModel shareInfo].sex;
            }
            
        }
            break;
        case 3:{
            cell.cellType = UserInfoCellTypeText;
            cell.titleLB.sakura.text(@"birthday");
            cell.textLB.text = [UserInfoModel shareInfo].birth;        }
            break;
        case 4:{
            cell.cellType = UserInfoCellTypeText;
            cell.titleLB.sakura.text(@"signature");
            cell.textLB.text = [UserInfoModel shareInfo].personaltitle;
        }
            break;
        case 5:{
            cell.cellType = UserInfoCellTypeText;
            cell.titleLB.sakura.text(@"my_qrcode");
        }
            break;
            
        default:
            break;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self);
    [Communtil playClickSound];
    switch (indexPath.row) {
        case 0:{
            if (IPAD_DEVICE) {
                UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:[TXSakuraManager tx_stringWithPath:@"cancle"] destructiveButtonTitle:nil otherButtonTitles:[TXSakuraManager tx_stringWithPath:@"take_pictures"],[TXSakuraManager tx_stringWithPath:@"gallery"], nil];
                [sheet showInView:self.view];
            }else{
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[TXSakuraManager tx_stringWithPath:@"cancle"] style:UIAlertActionStyleCancel handler:nil];
                UIImagePickerController  *pickerController = [[UIImagePickerController alloc] init];
                pickerController.delegate = self;
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:[TXSakuraManager tx_stringWithPath:@"take_pictures"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                        [self presentViewController:pickerController animated:YES completion:nil];
                    }
                }];
                UIAlertAction *otherAction1 = [UIAlertAction actionWithTitle:[TXSakuraManager tx_stringWithPath:@"gallery"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        [self presentViewController:pickerController animated:YES completion:nil];
                    }
                }];
                [alertVc addAction:cancelAction];
                [alertVc addAction:otherAction];
                [alertVc addAction:otherAction1];
                [self presentViewController:alertVc animated:YES completion:nil];
            }
        }
            break;
        case 1:{
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:[TXSakuraManager tx_stringWithPath:@"changename"] preferredStyle:UIAlertControllerStyleAlert];
            [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                @strongify(self);
                textField.placeholder = [TXSakuraManager tx_stringWithPath:@"changename"];
                textField.font = [UIFont systemFontOfSize:15];
                RAC(self.viewModel,nickName) = textField.rac_textSignal;
            }];
            UIAlertAction *done = [UIAlertAction actionWithTitle:[TXSakuraManager tx_stringWithPath:@"commit"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.viewModel.modifNameCmd execute:nil];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:[TXSakuraManager tx_stringWithPath:@"cancle"] style:UIAlertActionStyleCancel handler:nil];
            [alertVc addAction:done];
            [alertVc addAction:cancel];
            [self presentViewController:alertVc animated:YES completion:nil];
        }
            break;
        case 2:{
            GenderSettingViewController *vc = [GenderSettingViewController genderControllerDoneAction:^(NSString *gender) {
                @strongify(self);
                [self.viewModel.modifGenderCmd execute:gender];
            }];
            [self presentTransparentController:vc];
        }
            break;
        case 3:{
            DatePickerViewController *vc = [DatePickerViewController datePickerWithDoneAction:^(NSDate *date) {
                @strongify(self);
                [self.viewModel.modifBirthCmd execute:[NSNumber numberWithInteger:[date timeIntervalSince1970]]];
            }];
            [self presentTransparentController:vc];
        }
            break;
        case 4:{
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:[TXSakuraManager tx_stringWithPath:@"signature"] preferredStyle:UIAlertControllerStyleAlert];
            [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                @strongify(self);
                textField.placeholder = [TXSakuraManager tx_stringWithPath:@"signature"];
                textField.font = [UIFont systemFontOfSize:15];
                RAC(self.viewModel,signature) = textField.rac_textSignal;
            }];
            UIAlertAction *done = [UIAlertAction actionWithTitle:[TXSakuraManager tx_stringWithPath:@"commit"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.viewModel.modifSignatureCmd execute:nil];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:[TXSakuraManager tx_stringWithPath:@"cancle"] style:UIAlertActionStyleCancel handler:nil];
            [alertVc addAction:done];
            [alertVc addAction:cancel];
            [self presentViewController:alertVc animated:YES completion:nil];
        }
            break;
        case 5:{
            [self.viewModel.userInfoCmd execute:nil];
        }
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    UIImagePickerController  *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    if(buttonIndex == 0){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pickerController animated:YES completion:nil];
        }
    }else if (buttonIndex == 1){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            if(IPAD_DEVICE){
                UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:pickerController];
                [popover presentPopoverFromRect:CGRectMake(0, 0, 200, 200) inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            }else{
                [self presentViewController:pickerController animated:YES completion:nil];
            }
            
        }
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 8_3) __TVOS_PROHIBITED{

}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;//点击蒙版popover不消失， 默认yes
}

- (void)bindViewModel{
    self.viewModel = [[UserInfoViewModel alloc]initWithHUDShowView:self.view];
    @weakify(self);
    [self.viewModel.modifNameCmd.executionSignals.switchToLatest subscribeNext:^(NSString *x) {
        @strongify(self);
        [UserInfoModel shareInfo].nickname = x;
        [self.tableView reloadData];
        if (self.modification) {
            self.modification();
        }
    }];
    [self.viewModel.modifBirthCmd.executionSignals.switchToLatest subscribeNext:^(NSString *x) {
        @strongify(self);
        [UserInfoModel shareInfo].birth = x;
        [self.tableView reloadData];

    }];
    [self.viewModel.modifGenderCmd.executionSignals.switchToLatest subscribeNext:^(NSString *x) {
        @strongify(self);
        [UserInfoModel shareInfo].sex = x;
        [self.tableView reloadData];
    }];
    [self.viewModel.modifSignatureCmd.executionSignals.switchToLatest subscribeNext:^(NSString *x) {
        @strongify(self);
        [UserInfoModel shareInfo].personaltitle = x;
        [self.tableView reloadData];
        if (self.modification) {
            self.modification();
        }
    }];
    [self.viewModel.modifAvatarCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        NSString *avatar = [x objectForKey:@"avatarurl"];
        if (avatar && avatar.length > 0) {
           [UserInfoModel shareInfo].avatarurl = avatar;
            [self.tableView reloadData];
            if (self.modification) {
                self.modification();
            }
        }
    }];
    [[self rac_signalForSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:) fromProtocol:@protocol(UIImagePickerControllerDelegate)]subscribeNext:^(RACTuple *x) {
         @strongify(self);
        [x[0] dismissViewControllerAnimated:YES completion:nil];
        UIImage *img = [x[1] objectForKey:UIImagePickerControllerOriginalImage];
        NSData *avatarData = UIImageJPEGRepresentation(img, 0.1);
        if (avatarData) {
            [self.viewModel.modifAvatarCmd execute:avatarData];
        }
    }];
    [self.viewModel.userInfoCmd.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self);
        QRCodeViewController *vc = [[QRCodeViewController alloc]init];
        vc.encodeMsg = [UserInfoModel shareInfo].token;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}


#pragma mark initUI
- (void)initUI{
    [self setBackTitle:[TXSakuraManager tx_stringWithPath:@"mine"]];
    self.view.backgroundColor = HexRGB(0x202126);
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = IPHONE_DEVICE?58.f:76.f;
        tableView.backgroundColor = [UIColor clearColor];
        [tableView registerClass:[UserInfoTableViewCell class] forCellReuseIdentifier:cellID];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(86, IPHONE_DEVICE?0:kPADSETTING_LEFTMARGIN, 0, IPHONE_DEVICE?0:90));
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return UIInterfaceOrientationLandscapeRight;
}

 //支持旋转
-(BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return   IPAD_DEVICE?UIInterfaceOrientationMaskLandscapeRight:UIInterfaceOrientationMaskPortrait;
}



@end
