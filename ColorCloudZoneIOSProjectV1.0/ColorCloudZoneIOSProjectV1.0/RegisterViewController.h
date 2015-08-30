//
//  RegisterViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by RAY on 15/8/30.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

- (IBAction)regisBtnAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *registBtn;


- (IBAction)requestSMSCode:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *codeSMSTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UIButton *requestSMSCodeBtn;
@end
