//
//  MLShopContainViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/21.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBCustomViewController.h"

@interface MLShopContainViewController : GBCustomViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL tag;
@end
