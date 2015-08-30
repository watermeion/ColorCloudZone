//
//  RequestSMSViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by RAY on 15/8/30.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestSMSViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *SMSCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
- (IBAction)nextStepAction:(id)sender;

- (IBAction)requestFailedAction:(id)sender;
@end
