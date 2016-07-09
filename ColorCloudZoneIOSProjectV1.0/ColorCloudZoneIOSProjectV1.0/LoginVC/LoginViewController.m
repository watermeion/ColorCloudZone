//
//  LoginViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/16.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "LoginViewController.h"
#import "AVCloud.h"
#import "SVProgressHUD.h"
#import "AVUser.h"
#import "MemberCenterManager.h"
#import "MLTabBarViewController.h"
#import "RegisterAfterViewController.h"
#import "LoginAndRegistNaviController.h"
#import "AppDelegate.h"
#import "GBMainEntranceViewController.h"
#import "RequestSMSViewController.h"
typedef NS_ENUM(NSUInteger, LoginViewTextFieldTag) {
    LoginViewTextFieldPhone = 9977,
    LoginViewTextFieldPassword,
};

@interface LoginViewController ()<UITextFieldDelegate>
//@property (nonatomic, strong) NSString *phoneNum;
//@property (nonatomic, strong) NSString *pwd;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    // Do any additional setup after loading the view.
    self.phoneNunTextField.delegate = self;
    self.phoneNunTextField.tag = LoginViewTextFieldPhone;
    self.passwordTextField.delegate = self;
    self.passwordTextField.tag = LoginViewTextFieldPassword;
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


//#pragma UITextFieldDelegate
//
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.tag == LoginViewTextFieldPassword) {
//        self.pwd = textField.text;
//    }
//    if (textField.tag == LoginViewTextFieldPhone) {
//        self.phoneNum = textField.text;
//    }
//}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)isPhoneNumCorrect{
    return self.phoneNunTextField.text.length == 11 ? YES : NO;
}


- (BOOL)isPwdSafe{
    return self.passwordTextField.text.length >= 6 ? YES : NO;
}


- (BOOL)checkInputValiable{

    if (![self isPhoneNumCorrect] ) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确手机号"];
        return NO;
    }
    if (![self isPwdSafe]) {
        [SVProgressHUD showErrorWithStatus:@"请输入6位以上密码"];
        return NO;
    }
    return YES;
}



- (IBAction)loginAction:(id)sender {
    if ([self checkInputValiable]) {
        [SVProgressHUD showWithStatus:@"正在登陆" maskType:SVProgressHUDMaskTypeBlack];
        [CCUser loginWithMobile:self.phoneNunTextField.text password:self.passwordTextField.text withBlock:^(CCUser *user, NSError *error) {
            [SVProgressHUD dismiss];
            if (user != nil && !error) {
                if (user.role == UserRoleFactory) {
                    //如果是供应商
                    UINavigationController * nav = [self.storyboard instantiateViewControllerWithIdentifier:@"SupplierNavigationController"];
                    AppDelegate *delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
                    delegate.window.rootViewController = nav;
                } else {
                    
                    //如果是店铺
                    MLTabBarViewController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"SellersTabViewController"];
                    
                    AppDelegate *delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
                    delegate.window.rootViewController = tabbar;
                }
            } else {
                [SVProgressHUD showErrorWithStatus:@"登陆失败，请重新尝试"];
            }
        }];
    }
}

- (IBAction)forgetPwdAction:(id)sender {
    if (![self isPhoneNumCorrect] ) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确手机号"];
        return;
    }
    
    RequestSMSViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RequestSMSViewController"];
    CCUser * user = [[CCUser alloc] init];
    user.mobile = self.phoneNunTextField.text;
    vc.registingUser = user;
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
