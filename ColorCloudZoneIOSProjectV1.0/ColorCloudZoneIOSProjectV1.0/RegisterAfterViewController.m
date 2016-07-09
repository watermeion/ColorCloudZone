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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
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
    
    if (self.userType == MemberCenterUserTypeSupplier) {
        self.registingUser.role = UserRoleFactory;
        CompanyProfileViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CompanyProfileViewController"];
        vc.registingUser = self.registingUser;
        [self.navigationController pushViewController:vc animated:YES];

    }else if (self.userType == MemberCenterUserTypeSeller){
        self.registingUser.role = UserRoleMall;
        PersonProfileViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonProfileViewController"];
        vc.registingUser = self.registingUser;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:@"请选择你的身份"];
    }
}
@end
