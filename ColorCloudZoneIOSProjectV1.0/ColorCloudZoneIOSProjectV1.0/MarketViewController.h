
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
#import "CCUser.h"
#import "CCItem.h"
@class MarketViewController;
@protocol MarketViewControllerDelegate <NSObject>
- (void)marketViewController:(MarketViewController *)viewController didSelectSaleMarket:(CCSaleMarket *)saleMarket;
- (void)marketViewController:(MarketViewController *)viewController didSelectClass:(CCItemClass *)itemClass sort:(CCItemSort *)sort;
@end

@interface MarketViewController : GBCustomViewController
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;
@property (nonatomic, strong) GBMarketVCViewModel *viewModel;
@property (strong, nonatomic) IBOutlet CustomSelectionBarView *selectionBar;
@property (weak, nonatomic) id<MarketViewControllerDelegate> delegate;

@end
