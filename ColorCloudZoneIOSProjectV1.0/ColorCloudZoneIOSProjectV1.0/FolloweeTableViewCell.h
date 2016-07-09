//
//  FolloweeTableViewCell.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/23.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCUser.h"
@class FolloweeTableViewCell;
@protocol FolloweeTableViewCellDelegate <NSObject>

- (void)followeeTableViewCellPhoneCallClicked:(FolloweeTableViewCell *)cell;
- (void)followeeTableViewCellUnfollowClicked:(FolloweeTableViewCell *)cell;
- (void)followeeTableViewCellEnterClicked:(FolloweeTableViewCell *)cell;

@end

@interface FolloweeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
- (IBAction)phoneCallAction:(id)sender;
- (IBAction)enterAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastestNumLabel;
@property (nonatomic, strong) CCUser * parentFactory;
@property (weak, nonatomic) id<FolloweeTableViewCellDelegate> delegate;

- (IBAction)cancelFollowingActon:(id)sender;

@end
