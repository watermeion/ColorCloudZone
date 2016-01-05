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
@interface ComSettingsTableViewController () <UIActionSheetDelegate>

@end

@implementation ComSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [SVProgressHUD showWithStatus:@"正在获取信息" maskType:SVProgressHUDMaskTypeBlack];
    AVObject * manufacture = [[AVUser currentUser] objectForKey:@"manufacture"];
    if (!manufacture) {
        [SVProgressHUD showErrorWithStatus:@"获取失败"];
    }
    [manufacture fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
//    [manufacture fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            _nameLabel.text = manufacture[@"ownerName"];
            AVFile * avatar = manufacture[@"avatar"];
            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatar.url]];
            _factoryNameLabel.text = manufacture[@"name"];
            _addressLabel.text = manufacture[@"address"];
            _cardLabel.text = manufacture[@"card"];
            _zfbLabel.text = manufacture[@"zhifubao"];
            _phoneNumberLabel.text = [[AVUser currentUser]objectForKey:@"phoneNumber"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
        }
    }];
    
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
        [AVUser logOut];
    }
}

@end
