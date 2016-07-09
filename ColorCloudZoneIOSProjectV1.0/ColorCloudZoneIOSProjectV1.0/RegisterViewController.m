//
//  RegisterViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by RAY on 15/8/30.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "RegisterViewController.h"
#import <AVUser.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "CCUser.h"
#import "RequestSMSViewController.h"
static NSString * const kPushForSMSCodeSegueIdentifier = @"PushForSMSCodeSegue";
static NSString * const kPushSelectUserTypeVCSegueIdentifier = @"PushSelectUserTypeVCSegue";
typedef void(^GBCompletionBlock)(BOOL success, NSError *error);

@interface RegisterViewController ()<UITextFieldDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    // Do any additional setup after loading the view.
    
    self.passwordTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.navigationItem.title = @"注册新用户";
    
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


- (IBAction)requestSMSCode:(id)sender {
    
    
    
}



- (IBAction)regisBtnAction:(id)sender {
    
   
    NSString *phone = self.phoneTextField.text;
    NSString *pwd = self.passwordTextField.text;
    
    //做校验
    if (phone.length != 11) {
      
        [SVProgressHUD showErrorWithStatus:@"输入的手机号不正确"];
        return;
    }
    
    
    if (pwd.length <6) {
      
        [SVProgressHUD showErrorWithStatus:@"密码必须大于6位"];
        return;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [CCUser checkMobileRegistered:phone withBlock:^(BOOL registered, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        } else {
            if (registered) {
                [SVProgressHUD showErrorWithStatus:@"该手机号已注册过。"];
            } else {
                RequestSMSViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestSMSViewController"];
                CCUser * user = [[CCUser alloc] init];
                user.mobile = phone;
                user.password = pwd;
                vc.registingUser = user;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
}

@end
