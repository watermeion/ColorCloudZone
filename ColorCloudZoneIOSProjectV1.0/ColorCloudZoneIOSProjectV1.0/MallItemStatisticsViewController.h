//
//  MallItemStatisticsViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/6/23.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCItem.h"

@interface MallItemStatisticsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *SNLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (nonatomic, strong) CCItem * parentItem;
@end
