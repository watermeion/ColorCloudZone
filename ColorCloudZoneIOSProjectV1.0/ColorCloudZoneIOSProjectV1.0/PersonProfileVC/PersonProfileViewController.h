//
//  PersonProfileViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/3.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBCustomViewController.h"
#import "VPImageCropperViewController.h"

@interface PersonProfileViewController : GBCustomViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, VPImageCropperDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ownerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *shopNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) UIImage * avatar;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
- (IBAction)doneAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *uploadAvatarBtn;
- (IBAction)uploadAvatarAction:(id)sender;

@end
