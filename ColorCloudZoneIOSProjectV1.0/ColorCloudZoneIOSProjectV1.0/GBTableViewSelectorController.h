//
//  GBTableViewSelectorController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/31.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GBTableViewSelectorResultDelegate <NSObject>

- (void)tableViewSelectorSelectedResults:(NSArray*) results;

@end

@interface GBTableViewSelectorController : UITableViewController

@property (nonatomic,strong) NSArray<NSString*> *datasource;
@property (nonatomic, strong) NSArray *selectedDatasource;

@property (nonatomic,strong) NSArray *results;
@property (nonatomic, weak) id<GBTableViewSelectorResultDelegate> delegate;

- (void)setBackBtnWhilePresented;
@end
