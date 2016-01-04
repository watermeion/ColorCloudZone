//
//  MLShopViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/17.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBCustomViewController.h"
#import "CustomSelectionBarView.h"
#import "VPImageCropperViewController.h"

@interface MLShopViewController : GBCustomViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, VPImageCropperDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet CustomSelectionBarView *selectionBar;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;



@end
