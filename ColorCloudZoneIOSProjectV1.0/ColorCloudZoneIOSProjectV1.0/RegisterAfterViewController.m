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
@interface RegisterAfterViewController ()
@property (nonatomic) MEMBERCENTERUSERTYPE userType;

@end

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
    [SVProgressHUD showWithStatus:@"第一次登陆，请稍后！"];
    [[MemberCenterManager singletonInstance] setCurrentUserType:self.userType withCompletion:^(BOOL success, NSError *error) {
        if(success && !error ){
           [self dismissViewControllerAnimated:YES completion:^{
               [SVProgressHUD showSuccessWithStatus:@"欢迎进入彩云间"];
           }];
        }
    }];
}
@end
