//
//  ForgetPwdViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/22.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ForgetPwdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * smsCode;
@end
