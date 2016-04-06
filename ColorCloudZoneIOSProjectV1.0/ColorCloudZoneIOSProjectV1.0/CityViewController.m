//
//  CityViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/3/31.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "CityViewController.h"
#import "AreaViewController.h"
#import "SVProgressHud.h"
@interface CityViewController ()
@property (nonatomic, strong) NSArray * cities;
@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SVProgressHUD showWithStatus:@"正在获取列表"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [CCUser getCityListByProvinceId:self.parentUser.provinceId withBlock:^(NSArray *cityList, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
        } else {
            _cities = cityList;
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
    return _cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell"];
    CCAddressItem * item = [_cities objectAtIndex:indexPath.row];
    cell.textLabel.text = item.itemValue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCAddressItem * item = [_cities objectAtIndex:indexPath.row];
    self.parentUser.cityId = item.itemId;
    self.parentUser.cityName = item.itemValue;
    AreaViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AreaViewController"];
    vc.parentUser = self.parentUser;
    vc.profileVC = self.profileVC;
    [self.navigationController pushViewController:vc animated:YES];
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
