//
//  DetailImageCollectionViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/9/27.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailImageCollectionViewController : UICollectionViewController
@property (weak, nonatomic) IBOutlet UICollectionView *CustomCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CustomCollectionHeightConstraint;

@end
