//
//  TypeViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/4/8.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCItem.h"


@interface TypeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CCItem * parentItem;
@end
