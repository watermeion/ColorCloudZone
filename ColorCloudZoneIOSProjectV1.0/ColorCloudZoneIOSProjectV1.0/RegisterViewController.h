//
//  RegisterViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by RAY on 15/8/30.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCUser.h"

@interface RegisterViewController : UIViewController

- (IBAction)regisBtnAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *registBtn;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;

@end
