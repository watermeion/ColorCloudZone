//
//  MemerShipViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by hzguoyubao on 15/8/16.
//  Copyright (c) 2015年 SHS. All rights reserved.
//

#import "MemerShipViewController.h"
#import "MemberCommonCollectionViewCell.h"
#import "AddMemberCollectionViewCell.h"
static NSString *const kAddMemberCollectonCellIdentifier = @"AddMemberCollectionViewCell";
static NSString *const kMemberCollectonCellIdentifier = @"MemberCommonCollectionViewCell";


@interface MemerShipViewController ()

@end

@implementation MemerShipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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






#pragma mark - UICOllectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 2;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.item == 0) {
        AddMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kAddMemberCollectonCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    MemberCommonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMemberCollectonCellIdentifier forIndexPath:indexPath];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}






@end
