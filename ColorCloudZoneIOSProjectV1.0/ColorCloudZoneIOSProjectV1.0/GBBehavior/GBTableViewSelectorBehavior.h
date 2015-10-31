//
//  GBTableViewSelectorBehavior.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/31.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import "GBBehavior.h"
#import "GBTableViewSelectorController.h"


@protocol GBTableViewSelectorBehaviorDelegate <NSObject>

- (NSArray *)arrayforGBTableViewSelectorBehavior;

- (void)tableViewSelectorSelectedResults:(NSArray*) results;

@end

@interface GBTableViewSelectorBehavior : GBBehavior<GBTableViewSelectorResultDelegate>



@property (nonatomic, weak) IBOutlet id<GBTableViewSelectorBehaviorDelegate>  delegate;

- (IBAction)callSelectAction:(id) sender;



@end
