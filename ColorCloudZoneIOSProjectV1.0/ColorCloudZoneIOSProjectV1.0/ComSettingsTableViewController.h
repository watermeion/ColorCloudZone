//
//  ComSettingsTableViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/23.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComSettingsTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UILabel *factoryNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *remarkLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardLabel;
@property (strong, nonatomic) IBOutlet UILabel *zfbLabel;
@property (strong, nonatomic) IBOutlet UILabel *saleMarket;
@property (strong, nonatomic) IBOutlet UILabel *saleMarketAddress;

@end
