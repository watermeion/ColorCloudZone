//
//  AddMemberShipViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/16.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBCustomViewController.h"
#import "MemerShipViewController.h"

@interface AddMemberShipViewController : GBCustomViewController
@property (weak, nonatomic) IBOutlet UIButton *uploadAvatarBtn;
- (IBAction)uploadAvatarAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (nonatomic, strong) MemerShipViewController * membershipVC;

- (IBAction)doneAction:(id)sender;

@end
