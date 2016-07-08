//
//  MarketViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/10/16.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import "MarketViewController.h"
#import "DCPicScrollView.h"
#import "DCWebImageManager.h"
#import "MLShopContainViewController.h"
#import "KxMenu.h"
#import "SVProgressHud.h"
#import "CCItem.h"
#import "CCUser.h"
#import "FSDropDownMenu.h"
#import "CCFile.h"
static NSString *const kMLMarketContainerPushSegue = @"MarketContainerPushSegue";


@interface MarketViewController ()<FSDropDownMenuDataSource,FSDropDownMenuDelegate>
@property (nonatomic, strong) NSArray * saleMarketList;
@property(nonatomic,strong) NSArray *sortList;
@property (nonatomic, strong) CCItemClass * selectedClass;
@property(nonatomic,strong) NSArray *classList;
@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setBannerView];
    UIButton *market = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    market.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [market setTitle:@"市场" forState:UIControlStateNormal];
    [market setImage:[UIImage imageNamed:@"arrowUpsideDown"] forState:UIControlStateNormal];
    market.imageEdgeInsets = UIEdgeInsetsMake(11, 52, 11, 0);
    [market setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [market setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [market addTarget:self action:@selector(marketPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *classBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    classBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [classBtn setTitle:@"分类" forState:UIControlStateNormal];
    [classBtn setImage:[UIImage imageNamed:@"arrowUpsideDown"] forState:UIControlStateNormal];
    classBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 52, 11, 0);
    [classBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [market setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [classBtn addTarget:self action:@selector(classPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:market], [[UIBarButtonItem alloc] initWithCustomView:classBtn]];
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithTitle:@"我的关注" style:UIBarButtonItemStyleBordered target:self action:@selector(myFollowClicked:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.title = @"";
    
    
    FSDropDownMenu *menu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:300];
    menu.transformView = classBtn.imageView;
    menu.tag = 1001;
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myFollowClicked:(id)sender
{
    UIViewController * vc= [self.storyboard instantiateViewControllerWithIdentifier:@"MyFolloweeViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)marketPressed:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在获取列表"];
    [CCUser getSaleMarketListWithBlock:^(NSArray *saleMarketList, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"获取失败"];
        } else {
            self.saleMarketList = saleMarketList;
            NSMutableArray * menuItems = [NSMutableArray array];
            for (CCSaleMarket * market in saleMarketList) {
                KxMenuItem * item = [KxMenuItem menuItem:market.saleMarketName image:nil target:self action:@selector(saleMarketClicked:)];
                item.tag = [saleMarketList indexOfObject:market];
                [menuItems addObject:item];
            }
            [KxMenu showMenuInView:self.navigationController.view
                          fromRect:CGRectMake(25, 0, 44, 54)
                         menuItems:[NSArray arrayWithArray:menuItems]];
        }
    }];
}

- (IBAction)saleMarketClicked:(id)sender
{
    FSDropDownMenu *menu = (FSDropDownMenu*)[self.view viewWithTag:1001];
    if (menu.isShowing) {
        [UIView animateWithDuration:0.1 animations:^{
            
        } completion:^(BOOL finished) {
            [menu menuTapped];
        }];
    }
    
    KxMenuItem * item = (KxMenuItem *)sender;
    NSInteger tag = item.tag;
    if (tag < self.saleMarketList.count) {
        CCSaleMarket * market = [self.saleMarketList objectAtIndex:tag];
        NSLog(@"marketName = %@", market.saleMarketName);
        if (self.delegate && [self.delegate respondsToSelector:@selector(marketViewController:didSelectSaleMarket:)]) {
            [self.delegate marketViewController:self didSelectSaleMarket:market];
        }
    }
}

- (IBAction)classPressed:(id)sender
{
    FSDropDownMenu *menu = (FSDropDownMenu*)[self.view viewWithTag:1001];
    if (menu.isShowing) {
        [UIView animateWithDuration:0.2 animations:^{
            
        } completion:^(BOOL finished) {
            [menu menuTapped];
        }];
    } else {
        [SVProgressHUD showWithStatus:@"正在获取列表"];
        [CCItem getClassListWithBlock:^(NSArray *classList, NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"获取失败"];
            } else {
                self.classList = classList;
                [menu menuTapped];
            }
        }];
    }
}


- (void)setBannerView
{
    [CCUser getBannerWithBlock:^(NSArray *banner, NSError *error) {
        if (!error) {
            
            NSMutableArray *UrlStringArray = [NSMutableArray array];
            for (NSString * url in banner) {
                [UrlStringArray addObject:[CCFile ccURLWithString:url].absoluteString];
            }
            
            //显示顺序和数组顺序一致
            //设置图片url数组,和滚动视图位置
            
            DCPicScrollView  *picView = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 166.f / 375.f) WithImageUrls:UrlStringArray];
            
            //显示顺序和数组顺序一致
            //设置标题显示文本数组
            
            picView.style = PageControlAtCenter;
            
//            picView.titleData = titleArray;
            
            //占位图片,你可以在下载图片失败处修改占位图片
            
            picView.placeImage = [UIImage imageNamed:@"uialq.jpg"];
            
            //图片被点击事件,当前第几张图片被点击了,和数组顺序一致
            
            [picView setImageViewDidTapAtIndex:^(NSInteger index) {
                printf("第%zd张图片\n",index);
            }];
            
            //default is 2.0f,如果小于0.5不自动播放
            picView.AutoScrollDelay = 5.0f;
            //    picView.textColor = [UIColor redColor];
            
            [self.view addSubview:picView];
            
            //下载失败重复下载次数,默认不重复,
            [[DCWebImageManager shareManager] setDownloadImageRepeatCount:1];
            //图片下载失败会调用该block(如果设置了重复下载次数,则会在重复下载完后,假如还没下载成功,就会调用该block)
            //error错误信息
            //url下载失败的imageurl
            [[DCWebImageManager shareManager] setDownLoadImageError:^(NSError *error, NSString *url) {
                NSLog(@"%@",error);
            }];

        }
    }];
}



#pragma mark - FSDropDown datasource & delegate

- (NSInteger)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == menu.rightTableView) {
        return _classList.count;
    }else{
        return _sortList.count;
    }
}
- (NSString *)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == menu.rightTableView) {
        CCItemClass * class = _classList[indexPath.row];
        return class.className;
    }else{
        CCItemSort * sort = _sortList[indexPath.row];
        return sort.sortName;
    }
}


- (void)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == menu.rightTableView){
        [SVProgressHUD showWithStatus:@"正在获取列表"];
        self.selectedClass = _classList[indexPath.row];
        [CCItem getSortListByClassId:self.selectedClass.classId withBlock:^(NSArray *sortList, NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"获取失败"];
            } else {
                self.sortList = sortList;
                [menu.leftTableView reloadData];
            }
        }];
    }else{
//        [self resetItemSizeBy:_currentAreaArr[indexPath.row]];
        CCItemSort * sort = _sortList[indexPath.row];
        if (self.delegate && [self.delegate respondsToSelector:@selector(marketViewController:didSelectClass:sort:)]) {
            [self.delegate marketViewController:self didSelectClass:self.selectedClass sort:sort];
        }
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kMLMarketContainerPushSegue]) {
        MLShopContainViewController * vc = (MLShopContainViewController*)segue.destinationViewController;
        vc.parentVC = self;
        self.delegate = vc;
        self.selectionBar.delegate = vc;
    }

}


@end
