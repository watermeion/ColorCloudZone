//
//  GBTableViewSelectorBehavior.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/31.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import "GBTableViewSelectorBehavior.h"

#import "MLNavigationController.h"

@interface GBTableViewSelectorBehavior()
{
    id _sender;
}
@end
@implementation GBTableViewSelectorBehavior 
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)callSelectAction:(id)sender{
   //自定义
    _sender = sender;
    [self pushSelector:sender];
}

#pragma mark - Internal Helpers


- (void)pushSelector:(id)sender{
   
    [self showSelectorView:(id)sender];

}

- (void)showSelectorView:(id)sender{
    if (self.delegate && self.owner) {
    
        GBTableViewSelectorController *selectorVC = [[GBTableViewSelectorController alloc]init];
        selectorVC.delegate = self;
        if ([self.delegate respondsToSelector:@selector(arrayforGBTableViewSelectorBehaviorWith:)]) {
            
            NSArray *dataArray = [self.delegate arrayforGBTableViewSelectorBehaviorWith:sender];
            selectorVC.datasource = [dataArray copy];
            if ([self.owner isKindOfClass:[UIViewController class]]) {
                UIViewController *superViewController = self.owner;
                
                if(superViewController.navigationController){
                    [superViewController.navigationController pushViewController:selectorVC animated:YES];
                }else{
                 
                    MLNavigationController *navigation = [[MLNavigationController alloc]initWithRootViewController:selectorVC];
                    [superViewController presentViewController:navigation animated:YES completion:^{
                        [selectorVC setBackBtnWhilePresented];
                    }];
                }
            }
        }
    }
}

#pragma mark - Lifecycle




#pragma mark - View Lifecycle



#pragma mark - Layout



#pragma mark - Public Interface



#pragma mark - User Interaction





#pragma mark - Delegate

- (void)tableViewSelectorSelectedResults:(NSArray *)results{
    if ([self.delegate respondsToSelector:@selector(tableViewSelectorSelectedResults:fromSender:)]) {
        [self.delegate tableViewSelectorSelectedResults:results fromSender:_sender];
    }
}





@end
