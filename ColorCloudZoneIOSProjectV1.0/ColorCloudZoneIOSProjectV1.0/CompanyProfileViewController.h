//
//  CompanyProfileViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/16.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBCustomViewController.h"
#import "CCUser.h"
@interface CompanyProfileViewController : GBCustomViewController <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UIButton *uploadAction;
@property (weak, nonatomic) IBOutlet UITextField *comNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *comCity;
@property (weak, nonatomic) IBOutlet UITextField *ownerTextField;
@property (weak, nonatomic) IBOutlet UITextField *comAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *zfbNumTextField;
@property (strong, nonatomic) IBOutlet UITextField *remarkTextField;
@property (strong, nonatomic) IBOutlet UITextField *addressDetailTextField;
@property (strong, nonatomic) IBOutlet UILabel *saleMarketLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (nonatomic, strong) CCUser * registingUser;
- (IBAction)doneAction:(id)sender;
@end
