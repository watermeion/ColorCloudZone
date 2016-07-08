//
//  ForgetPwdViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/22.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "SVProgressHud.h"
#import "CCUser.h"

@interface ForgetPwdViewController ()

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *moreFeaturesLeftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:)];
    moreFeaturesLeftBarItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = moreFeaturesLeftBarItem;
    self.navigationItem.title = @"重置密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneClicked:(id)sender
{
    if (self.passwordTextField.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"请输入6位以上密码"];
        return;
    }
    [CCUser findPwdWithMobile:self.mobile verifyCode:self.smsCode newPwd:self.passwordTextField.text block:^(BOOL succeed, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"重置失败"];
        } else {
            if (succeed) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"重置失败"];
            }
        }
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
