//
//  MemberProfileViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/4/24.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCUser.h"
@interface MemberProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CCMember * parentMember;

@end
