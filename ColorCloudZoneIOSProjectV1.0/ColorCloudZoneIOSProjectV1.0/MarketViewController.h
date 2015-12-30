
//
//  MarketViewController.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/16.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GBCustomViewController.h"
#import "GBMarketVCViewModel.h"
#import "CustomSelectionBarView.h"
#import "GBViewControllerViewModelProtocol.h"

@interface MarketViewController : GBCustomViewController <GBViewControllerViewModelProtocol,CustomSelectionBarViewDelegate>
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;
@property (nonatomic, strong) GBMarketVCViewModel *viewModel;
@property (strong, nonatomic) IBOutlet CustomSelectionBarView *selectionBar;

@end
