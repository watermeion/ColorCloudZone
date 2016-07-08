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

@end

@implementation ComSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editClicked:)];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    _idLabel.text = [NSString stringWithFormat:@"ID: %@",[CCUser currentUser].userId];
    _nameLabel.text = [CCUser currentUser].ownerName;
    [_avatarImageView sd_setImageWithURL:[CCFile ccURLWithString:[CCUser currentUser].headImgUrl]];
    _factoryNameLabel.text = [CCUser currentUser].factoryName;
    _addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[CCUser currentUser].provinceName, [CCUser currentUser].cityName, [CCUser currentUser].areaName, [CCUser currentUser].address];
    _remarkLabel.text = [CCUser currentUser].remark.length?[CCUser currentUser].remark:@"无";
    _saleMarket.text = [CCUser currentUser].saleMarketName;
    _saleMarketAddress.text = [CCUser currentUser].addrInMarket;
    _cardLabel.text = [CCUser currentUser].cardNum;
    _zfbLabel.text = [CCUser currentUser].alipayNum;
    _phoneNumberLabel.text = [CCUser currentUser].mobile;
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
