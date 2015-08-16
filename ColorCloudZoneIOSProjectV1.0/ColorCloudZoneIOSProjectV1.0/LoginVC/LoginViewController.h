//
//  LoginViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/16.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *phoneNunTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registAsNewBtn;
- (IBAction)registAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
- (IBAction)forgetPwdAction:(id)sender;

@end
