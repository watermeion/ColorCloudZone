//
//  GBTableViewSelectorBehavior.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/31.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import "GBTableViewSelectorBehavior.h"

#import "MLNavigationController.h"
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
    [self pushSelector:sender];
}

#pragma mark - Internal Helpers


- (void)pushSelector:(id)sender{
   
    

}

- (void)showSelectorView{
    if (self.delegate && self.owner) {
    
        GBTableViewSelectorController *selector = [[GBTableViewSelectorController alloc]init];
        selector.delegate = self;
        if ([self.delegate respondsToSelector:@selector(arrayforGBTableViewSelectorBehavior)]) {
            
            NSArray *dataArray = [self.delegate arrayforGBTableViewSelectorBehavior];
            selector.datasource = [dataArray copy];
            if ([self.owner isKindOfClass:[UIViewController class]]) {
                UIViewController *superViewController = self.owner;
                
                if(superViewController.navigationController){
                    [superViewController.navigationController pushViewController:selector animated:YES];
                }else{
                 
                    MLNavigationController *navigation = [[MLNavigationController alloc]initWithRootViewController:selector];
                    [superViewController presentViewController:selector animated:YES completion:^{

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
    if ([self.delegate respondsToSelector:@selector(tableViewSelectorSelectedResults:)]) {
        [self.delegate tableViewSelectorSelectedResults:results];
    }
}





@end
