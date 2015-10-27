//
//  GBMarketVCViewModel.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/25.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import "GBViewModel.h"
@import UIKit;
/**
 *  ViewModel for MarketViewController 
 *  has common View Items Data
 *
 */
@interface GBMarketVCViewModel : GBViewModel

//Essential
@property (nonatomic, strong) NSArray<UIImage *> *topImages; ///Images Array for show at the top of this view

@property (nonatomic, strong) NSArray *collectionViewCellDataArray; ///Data Source for collectionView of this view

@property (nonatomic) BOOL isShowBottomBtn; /// flag for show bottom button or not. If YES ,default Hidden Tabbar.

@property (nonatomic, strong) NSString *textForBottomBtn; /// text for title of Bottom Btn


// check if this ViewModel is available 
- (BOOL)isAvailable;



@end
