//
//  RequestSMSViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by RAY on 15/8/30.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "RequestSMSViewController.h"
#import "RegisterAfterViewController.h"

#import "SVProgressHUD.h"
#import "CCAppDotNetClient.h"
#import "ForgetPwdViewController.h"
@interface RequestSMSViewController ()

@end

@implementation RequestSMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    self.phoneNumLabel.text = [@"+86" stringByAppendingString:self.registingUser.mobile];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    }
- (void)viewDidAppear:(BOOL)animated
{
    if ([CCAppDotNetClient isTesting]) {
        [SVProgressHUD showWithStatus:@"正在请求"];
        NSURL * url = [NSURL URLWithString:[@"http://wearcloud.beyondin.com/global/test_send_vc/" stringByAppendingString:self.registingUser.mobile]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        // 设置URL
        [request setURL:url];
        // 设置HTTP方法
        [request setHTTPMethod:@"GET"];
        // 发 送同步请求, 这里得returnData就是返回得数据了
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                                   returningResponse:nil error:nil];
        NSString * str = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        self.phoneNumLabel.text = [str substringFromIndex:str.length - 10];
        [SVProgressHUD dismiss];
        
    } else {
        [CCUser sendVerifyCodeToMobile:self.registingUser.mobile withBlock:^(BOOL succeed, NSError *error) {
            
        }];
    }

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

- (IBAction)nextStepAction:(id)sender {
    [SVProgressHUD showWithStatus:@"正在验证"];
    [CCUser checkVerifyCode:self.SMSCodeTextField.text mobile:self.registingUser.mobile withBlock:^(BOOL succeed, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"验证失败"];
            
        } else {
            if (succeed) {
                if (self.registingUser.password) {
                    RegisterAfterViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterAfterViewController"];
                    self.registingUser.verifyCode = self.SMSCodeTextField.text;
                    vc.registingUser = self.registingUser;
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    ForgetPwdViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPwdViewController"];
                    vc.smsCode = self.SMSCodeTextField.text;
                    vc.mobile = self.registingUser.mobile;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                [SVProgressHUD showErrorWithStatus:@"验证码错误"];
            }
        }
    }];
}

- (IBAction)requestFailedAction:(id)sender {
}
@end
