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
static NSString *const kMarketContainerPushSegue = @"MarketContainerPushSegue";


@interface MarketViewController ()

@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setBannerView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btn1Selected:(CustomSelectionBarView *)view
{
    
}

- (void)btn2Selected:(CustomSelectionBarView *)view
{
    
}

- (void)setBannerView
{
    AVQuery * query = [AVQuery queryWithClassName:@"HomeBanner"];
    [query whereKey:@"activity" notEqualTo:@(NO)];
    query.cachePolicy = kAVCachePolicyNetworkElseCache;
    [query orderByAscending:@"order"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSMutableArray *UrlStringArray = [NSMutableArray array];
            NSMutableArray *titleArray = [NSMutableArray array];
            for (AVObject * banner in objects) {
                AVFile * image = [banner objectForKey:@"homeBannerImage"];
                [UrlStringArray addObject:image.url];
                [titleArray addObject:[banner objectForKey:@"homeBannerContent"]];
            }
            
            
            //显示顺序和数组顺序一致
            //设置图片url数组,和滚动视图位置
            
            DCPicScrollView  *picView = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 166.f / 375.f) WithImageUrls:UrlStringArray];
            
            //显示顺序和数组顺序一致
            //设置标题显示文本数组
            
            
            
            picView.titleData = titleArray;
            
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
