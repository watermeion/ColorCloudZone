//
//  RegisterAfterViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by RAY on 15/8/30.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCUser.h"

@interface RegisterAfterViewController : UIViewController
- (IBAction)selectSupplierAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *supplierBtn;
@property (strong, nonatomic) IBOutlet UIButton *sellerBtn;
- (IBAction)selectedSellerAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *nextStepBtn;
- (IBAction)nextStepAction:(id)sender;
@property (strong, nonatomic) CCUser * registingUser;

@end
