//
//  MLShopContainViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/7/21.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBCustomViewController.h"
#import "CustomSelectionBarView.h"
#import "MarketViewController.h"

@interface MLShopContainViewController : GBCustomViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, CustomSelectionBarViewDelegate, MarketViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIViewController * parentVC;
@end
