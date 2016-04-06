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
#import "CCUser.h"
@interface PersonProfileViewController : GBCustomViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, VPImageCropperDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *ownerNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *shopNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UILabel *saleMarketNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *saleMarketAddressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) UIImage * avatar;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (nonatomic, strong) CCUser * registingUser;
- (IBAction)doneAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *uploadAvatarBtn;
- (IBAction)uploadAvatarAction:(id)sender;

@end
