//
//  ColorViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/4/8.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "ColorViewController.h"
#import "SVProgressHud.h"
#import "ItemPropertyCell.h"

@interface ColorViewController ()
@property (strong, nonatomic) NSArray * colorList;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SVProgressHUD showWithStatus:@"正在获取列表"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [CCItem getColorListByTypeId:self.parentItem.itemType.typeId withBlock:^(NSArray *colorList, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
        } else {
            _colorList = colorList;
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
    return _colorList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ItemPropertyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyCell"];
    CCItemPropertyValue * property = [_colorList objectAtIndex:indexPath.row];
    cell.textLabel.text = property.value;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (CCItemPropertyValue * prop in self.parentItem.colorProperty)
        if ([prop.valueId isEqualToString:property.valueId]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            break;
        }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCItemPropertyValue * property = [_colorList objectAtIndex:indexPath.row];
    for (CCItemPropertyValue * prop in self.parentItem.colorProperty)
        if ([prop.valueId isEqualToString:property.valueId]) return;
    [self.parentItem.colorProperty addObject:property];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCItemPropertyValue * property = [_colorList objectAtIndex:indexPath.row];
    CCItemPropertyValue * propToDelete;
    for (CCItemPropertyValue * prop in self.parentItem.colorProperty)
        if ([prop.valueId isEqualToString:property.valueId]) {
            propToDelete = prop;
            break;
        }
    if (propToDelete) [self.parentItem.colorProperty removeObject:propToDelete];
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
