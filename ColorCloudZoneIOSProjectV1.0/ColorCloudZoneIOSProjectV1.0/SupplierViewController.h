//
//  SupplierViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/1/3.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "GBCustomViewController.h"
#import "CustomSelectionBarView.h"
#import "VPImageCropperViewController.h"
#import "CCUser.h"

@interface SupplierViewController : GBCustomViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, VPImageCropperDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (strong, nonatomic) IBOutlet CustomSelectionBarView *selectionBar;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) CCUser * parentUser;
@end
