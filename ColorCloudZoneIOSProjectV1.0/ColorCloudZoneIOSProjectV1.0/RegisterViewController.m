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
static NSString * const kPushForSMSCodeSegueIdentifier = @"PushForSMSCodeSegue";
static NSString * const kPushSelectUserTypeVCSegueIdentifier = @"PushSelectUserTypeVCSegue";
typedef void(^GBCompletionBlock)(BOOL success, NSError *error);

@interface RegisterViewController ()<UITextFieldDelegate>

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
      
        [SVProgressHUD showErrorWithStatus:@"密码必须大于6为"];
        return;
    }
     [SVProgressHUD showWithStatus:@"正在注册..."];
    [self DoRegistBusinessWithUserName:phone Pwd:pwd
                        withCompletion:^(BOOL success, NSError *error) {
                            
                            if (success) {
                                //注册成功
//                                [self dismissViewControllerAnimated:YES completion:^{
//                                     [SVProgressHUD showInfoWithStatus:@"注册成功"];
//                                }];
                                  [SVProgressHUD showInfoWithStatus:@"注册成功"];
                                [self performSegueWithIdentifier:kPushSelectUserTypeVCSegueIdentifier sender:self];
                            }else {
                            //注册失败
                                [SVProgressHUD showErrorWithStatus:@"注册失败，请重新尝试"];
                            }
    }];
}


#pragma --mark 注册逻辑
- (void)DoRegistBusinessWithUserName:(NSString *)username
                                 Pwd:(NSString *)password
                                withCompletion:(GBCompletionBlock)callback
{
    static BOOL isSuccess=NO;
    NSError  *error;
    AVUser * user = [AVUser user];
    user.username = username;
    user.password = password;
    [user setObject:username forKey:@"mobilePhoneNumber"];
    isSuccess=[user signUp:&error];
    if (callback) {
        callback(isSuccess,error);
    }
}
@end
