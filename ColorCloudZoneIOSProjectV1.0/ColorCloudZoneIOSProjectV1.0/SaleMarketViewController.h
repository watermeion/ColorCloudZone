//
//  SaleMarketViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/31.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCUser.h"

@interface SaleMarketViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) CCUser * parentUser;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
