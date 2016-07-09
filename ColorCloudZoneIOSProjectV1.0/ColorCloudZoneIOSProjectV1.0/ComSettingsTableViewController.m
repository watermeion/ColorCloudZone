//
//  ComSettingsTableViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/23.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "ComSettingsTableViewController.h"
#import "SVProgressHud.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "LoginAndRegistNaviController.h"
#import "CCUser.h"
#import "CCFile.h"
#import "CompanyProfileViewController.h"
@interface ComSettingsTableViewController () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *logoutCell;

@end

@implementation ComSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    if (self.parentUser) {
        self.logoutCell.hidden = YES;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [CCUser getUserInfo:self.parentUser withBlock:^(CCUser *user, NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"获取信息失败"];
            }else {
                _idLabel.text = [NSString stringWithFormat:@"ID: %@",user.userId?user.userId:@""];
                _nameLabel.text = user.ownerName;
                [_avatarImageView sd_setImageWithURL:[CCFile ccURLWithString:user.headImgUrl]];
                _factoryNameLabel.text = user.factoryName;
                _addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",user.provinceName?user.provinceName:@"", user.cityName?user.cityName:@"", user.areaName?user.areaName:@"", user.address?user.address:@""];
                _remarkLabel.text = user.remark.length?user.remark:@"无";
                _saleMarket.text = user.saleMarketName;
                _saleMarketAddress.text = user.addrInMarket;
                _cardLabel.text = user.cardNum;
                _zfbLabel.text = user.alipayNum;
                _phoneNumberLabel.text = user.mobile;
            }
        }];
    } else {
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editClicked:)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CCUser * user = self.parentUser?self.parentUser:[CCUser currentUser];
    _idLabel.text = [NSString stringWithFormat:@"ID: %@",user.userId?user.userId:@""];
    _nameLabel.text = user.ownerName;
    [_avatarImageView sd_setImageWithURL:[CCFile ccURLWithString:user.headImgUrl]];
    _factoryNameLabel.text = user.factoryName;
    _addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",user.provinceName?user.provinceName:@"", user.cityName?user.cityName:@"", user.areaName?user.areaName:@"", user.address?user.address:@""];
    _remarkLabel.text = user.remark.length?user.remark:@"无";
    _saleMarket.text = user.saleMarketName;
    _saleMarketAddress.text = user.addrInMarket;
    _cardLabel.text = user.cardNum;
    _zfbLabel.text = user.alipayNum;
    _phoneNumberLabel.text = user.mobile;
}

- (IBAction)editClicked:(id)sender
{
    CompanyProfileViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyProfileViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ([tableView numberOfSections] - 1) && indexPath.row == ([tableView numberOfRowsInSection:indexPath.section] - 1)) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定要退出吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认退出" otherButtonTitles:nil];
        [actionSheet showInView:self.view];
        actionSheet.tag = 10;
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10 && buttonIndex == 0) {
        
        LoginAndRegistNaviController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginAndRegistNaviController"];
        AppDelegate *delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
        delegate.window.rootViewController = vc;
        [CCUser logout];
    }
}

@end
