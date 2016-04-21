//
//  WantView.h
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/23.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCItem.h"
#import "CCUser.h"
@class WantView;
@protocol WantViewDelegate <NSObject>

- (void)wantViewOKButtonClicked:(WantView *)view;
- (void)wantViewDidDismiss:(WantView *)view;
@end
@interface WantView : UIView <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UITextField *userIdLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnail;
@property (nonatomic, strong) CCItem * parentItem;

@property (weak, nonatomic) id<WantViewDelegate> delegate;
@property (strong, nonatomic) UIView * maskView;

//@property (nonatomic, strong) NSMutableArray * selectedColor;
//@property (nonatomic, strong) NSMutableArray * selectedSize;
@property (nonatomic, strong) CCItemPropertyValue * selectedColor;
@property (nonatomic, strong) CCItemPropertyValue * selectedSize;


- (void)showInView:(UIView *)view;
@end
