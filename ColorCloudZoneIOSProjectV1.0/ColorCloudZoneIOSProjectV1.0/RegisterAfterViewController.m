//
//  RegisterAfterViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by RAY on 15/8/30.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "RegisterAfterViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MemberCenterManager.h"
#import "SVProgressHUD.h"
#import "MLTabBarViewController.h"
#import "AppDelegate.h"
#import "PersonProfileViewController.h"
#import "CompanyProfileViewController.h"
@interface RegisterAfterViewController ()
@property (nonatomic) MEMBERCENTERUSERTYPE userType;

@end

static NSString *const kShowSupllierSegueIdentifier = @"ShowSupplierProfileEditSegue";
static NSString *const kShowShopProfileSegueIdentifier = @"ShowShopProfileSegue";
@implementation RegisterAfterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectedSellerAction:(id)sender {
    self.userType = MemberCenterUserTypeSeller;
    [self switchhighlightedBtn];
}
- (IBAction)selectSupplierAction:(id)sender {
    self.userType = MemberCenterUserTypeSupplier;
    [self switchhighlightedBtn];
}



- (void)switchhighlightedBtn{

    switch (self.userType) {
        case MemberCenterUserTypeSeller:
            self.sellerBtn.backgroundColor = [UIColor lightGrayColor];
            self.supplierBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
            break;
        case MemberCenterUserTypeSupplier:
            self.supplierBtn.backgroundColor = [UIColor lightGrayColor];
            self.sellerBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
            break;
        case MemberCenterUserTypeUnKnown:
            
            break;
    }
}


- (IBAction)nextStepAction:(id)sender {
    [SVProgressHUD showWithStatus:@"第一次登陆，请稍后！" maskType:SVProgressHUDMaskTypeBlack];
    if (self.userType == MemberCenterUserTypeSupplier) {
        AVObject * manufacture = [AVObject objectWithClassName:@"Manufacturers"];
        [manufacture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[AVUser currentUser] setObject:@(self.userType) forKey:@"userType"];
                [[AVUser currentUser] setObject:manufacture forKey:@"manufacture"];
                [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
                        CompanyProfileViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyProfileViewController"];
                        [self.navigationController pushViewController:vc animated:YES];
//                        UINavigationController * nav = [self.storyboard instantiateViewControllerWithIdentifier:@"SupplierNavigationController"];
//                        AppDelegate *delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
//                        delegate.window.rootViewController = nav;

                    } else {
                        [SVProgressHUD showErrorWithStatus:@"登陆失败"];
                    }
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:@"登陆失败"];
            }
        }];
    }else if (self.userType == MemberCenterUserTypeSeller){
        AVObject * shop = [AVObject objectWithClassName:@"Shop"];
        [shop setObject:[AVUser currentUser].objectId forKey:@"userId"];
        [shop saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[AVUser currentUser] setObject:@(self.userType) forKey:@"userType"];
                [[AVUser currentUser] setObject:shop forKey:@"shop"];
                [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
                        PersonProfileViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonProfileViewController"];
                        [self.navigationController pushViewController:vc animated:YES];
//                        MLTabBarViewController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"SellersTabViewController"];
//                        AppDelegate *delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
//                        delegate.window.rootViewController = tabbar;
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"登陆失败"];
                    }
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:@"登陆失败"];
            }
        }];
    }
}
@end
