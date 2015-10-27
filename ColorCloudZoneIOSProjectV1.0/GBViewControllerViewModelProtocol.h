//
//  GBViewControllerViewModelProtocol.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/25.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBViewModel.h"

@protocol GBViewControllerViewModelProtocol <NSObject>

/**
 *  ViewController who wants to get Data from ViewModel,And set data to specific UI Items
 *
 *  @param viewModel GBViewModel
 */
- (void)mapViewWithViewModel:(GBViewModel *) viewModel;


@end
