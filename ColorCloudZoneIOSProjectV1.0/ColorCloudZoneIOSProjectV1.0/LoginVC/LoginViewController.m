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
typedef NS_ENUM(NSUInteger, LoginViewTextFieldTag) {
    LoginViewTextFieldPhone = 9977,
    LoginViewTextFieldPassword,
};

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *pwd;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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


#pragma UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == LoginViewTextFieldPassword) {
        self.pwd = textField.text;
    }
    if (textField.tag == LoginViewTextFieldPhone) {
        self.phoneNum = textField.text;
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)isPhoneNumCorrect{
    return self.phoneNum.length == 11 ? YES : NO;
}


- (BOOL)isPwdSafe{
    return self.pwd.length >= 6 ? YES : NO;
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
        [SVProgressHUD showWithStatus:@"正在登陆"];
        [AVUser logInWithUsernameInBackground:self.phoneNum password:self.pwd block:^(AVUser *user, NSError *error) {
            [SVProgressHUD dismiss];
                if (user != nil) {
                    
                    MEMBERCENTERUSERTYPE userType = [[user objectForKey:@"userType"] integerValue];
                    
                    MLTabBarViewController *tabbar;
                    if (userType == MemberCenterUserTypeSupplier) {
                        //如果是供应商
                        tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"SuppliersTabViewController"];
                        AppDelegate *delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
                        delegate.window.rootViewController = tabbar;
                        
                    }else if (userType == MemberCenterUserTypeSeller){
                        //如果是店铺
                        tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"SellersTabViewController"];
                        
                        AppDelegate *delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
                        delegate.window.rootViewController = tabbar;
                        
                    } else {
                        RegisterAfterViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterAfterViewController"];
                        LoginAndRegistNaviController * nav = [[LoginAndRegistNaviController alloc]initWithRootViewController:vc];
                        
                        AppDelegate *delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
                        delegate.window.rootViewController = nav;
                    }
                } else {
                    [SVProgressHUD showErrorWithStatus:@"登陆失败，请重新尝试"];
                }
        }];
    }
}

- (IBAction)forgetPwdAction:(id)sender {
    
    
    
}
@end
