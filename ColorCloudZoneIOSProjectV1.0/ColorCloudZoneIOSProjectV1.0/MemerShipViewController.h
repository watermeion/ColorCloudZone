//
//  MemerShipViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/16.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBCustomViewController.h"

typedef  NS_ENUM(NSUInteger, MemerShipViewControllerState){
    MemerShipViewControllerStateUnknown = 0,
    MemerShipViewControllerStateDisplay,
    MemerShipViewControllerStateEdit
};


@interface MemerShipViewController : GBCustomViewController <UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) MemerShipViewControllerState state;
- (void)pullDown;

@end
