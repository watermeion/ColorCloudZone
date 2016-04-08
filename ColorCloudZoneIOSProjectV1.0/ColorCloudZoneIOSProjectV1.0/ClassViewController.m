//
//  ClassViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by 张明川 on 16/4/8.
//  Copyright © 2016年 SHS. All rights reserved.
//

#import "ClassViewController.h"
#import "SVProgressHud.h"
#import "SortViewController.h"

@interface ClassViewController ()
@property (strong, nonatomic) NSArray * classList;
@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithStatus:@"正在获取列表"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [CCItem getClassListWithBlock:^(NSArray *classList, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
        } else {
            _classList = classList;
            [self.tableView reloadData];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _classList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ClassCell"];
    CCItemClass * item = [_classList objectAtIndex:indexPath.row];
    cell.textLabel.text = item.className;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCItemClass * item = [_classList objectAtIndex:indexPath.row];
    if (![self.parentItem.itemClass.classId isEqualToString:item.classId]) {
        self.parentItem.itemClass = item;
        self.parentItem.itemSort = nil;
    }
    SortViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SortViewController"];
    vc.parentItem = self.parentItem;
    vc.uploadViewController = self.uploadViewController;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
