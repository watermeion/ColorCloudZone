//
//  FactoryItemStatisticsViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/6/23.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "FactoryItemStatisticsViewController.h"
#import "CCFile.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHud.h"

#define TagsPadding 15
#define HeightOfLine 23
#define Space 10
#define TagHorizontalPadding 4
#define TagVerticalPadding 2
@interface FactoryItemStatisticsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray * skuInfos;
@end

@implementation FactoryItemStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.avatar sd_setImageWithURL:[CCFile ccURLWithString:self.parentItem.cover]];
    self.titleLabel.text = self.parentItem.name;
    self.SNLabel.text = [@"货号: " stringByAppendingString:self.parentItem.SN?self.parentItem.SN:@""];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [SVProgressHUD showWithStatus:@"正在获取信息" maskType:SVProgressHUDMaskTypeBlack];
    [CCItem getFactoryItemStatistics:self.parentItem withBlock:^(NSArray *skuInfos, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
        } else {
            self.skuInfos = skuInfos;
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.skuInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    CCItemFactoryStatisticsProp * prop = [self.skuInfos objectAtIndex:indexPath.row];
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 15)];
    title.text = prop.name;
    title.font = [UIFont systemFontOfSize:14.f];
    title.textColor = [UIColor blackColor];
    [cell.contentView addSubview:title];
    
    UIImageView * heart = [[UIImageView alloc] initWithFrame:CGRectMake(TagsPadding, 30, HeightOfLine, HeightOfLine)];
    heart.contentMode = UIViewContentModeCenter;
    heart.image = [UIImage imageNamed:@"heart"];
    [cell.contentView addSubview:heart];
    
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width - TagsPadding;
    NSInteger line = 0;
    CGFloat curX = width;
    CGFloat orginY = heart.frame.origin.y;
    for (CCItemFactoryStatisticsProp * property in prop.sku) {
//        for (NSInteger index = 0; index < 8; index ++) {
        NSString * name = [property.name stringByAppendingFormat:@": %ld件", (long)property.count];
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]};
        CGRect rect = [name boundingRectWithSize:CGSizeMake(width, HeightOfLine) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        CGRect frame;
        if (curX + Space + rect.size.width <= width) {
            frame = CGRectMake(curX + Space, orginY + (line - 1) * HeightOfLine + (HeightOfLine - rect.size.height) / 2.0, rect.size.width , rect.size.height);
            curX += (Space + TagHorizontalPadding * 2 + rect.size.width);
        } else {
            line ++;
            frame = CGRectMake(TagsPadding + HeightOfLine + Space, orginY + (line - 1) * HeightOfLine + (HeightOfLine - rect.size.height ) / 2.0, rect.size.width, rect.size.height);
            curX = TagsPadding + HeightOfLine + Space + rect.size.width;
        }
        UILabel * label = [[UILabel alloc] initWithFrame:frame];
        label.text = name;
        label.font = [UIFont systemFontOfSize:14.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:label];
//        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCItemFactoryStatisticsProp * prop = [self.skuInfos objectAtIndex:indexPath.row];
    CGFloat width = [[UIScreen mainScreen] bounds].size.width - TagsPadding;
    NSInteger line = 0;
    CGFloat curX = width;
    CGFloat orginY = 30;
    for (CCItemFactoryStatisticsProp * property in prop.sku) {
//        for (NSInteger index = 0; index < 8; index ++) {
            NSString * name = [property.name stringByAppendingFormat:@": %ld件", (long)property.count];
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]};
            CGRect rect = [name boundingRectWithSize:CGSizeMake(width, HeightOfLine) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            CGRect frame;
            if (curX + Space + rect.size.width <= width) {
                frame = CGRectMake(curX + Space, orginY + (line - 1) * HeightOfLine + (HeightOfLine - rect.size.height) / 2.0, rect.size.width , rect.size.height);
                curX += (Space + TagHorizontalPadding * 2 + rect.size.width);
            } else {
                line ++;
                frame = CGRectMake(TagsPadding + HeightOfLine + Space, orginY + (line - 1) * HeightOfLine + (HeightOfLine - rect.size.height ) / 2.0, rect.size.width, rect.size.height);
                curX = TagsPadding + HeightOfLine + Space + rect.size.width;
            }
//        }
    }
    return orginY + line * HeightOfLine + 10;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
