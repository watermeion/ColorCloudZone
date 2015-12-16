//
//  GBMainEntranceViewController.m
//  ColorCloudZoneIOSProjectV1.0
//
//  Created by GYB on 15/11/10.
//  Copyright © 2015年 SHS. All rights reserved.
//

#import "GBMainEntranceViewController.h"
#import "MLTabBarViewController.h"
#import "MemberCenterManager.h"
#import "MLNavigationController.h"
@interface GBMainEntranceViewController ()

@property (nonatomic) BOOL isSeller;
@property (nonatomic, weak) UIViewController *loginNaviVC;
@end

@implementation GBMainEntranceViewController

static GBMainEntranceViewController * shareInstance = nil;




+ (instancetype)sharedInstance{
    return shareInstance;
}

- (instancetype)init{
    if (shareInstance) {
        return shareInstance;
    }
    self = [super init];
    if (self) {
        shareInstance = self;
    }
    return self;
}


- (void)setUpInitialView{
    if (self.isSeller) {
        [self loadSellerWorkFlow];
    }else{
        [self loadSupplierWorkFlow];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self switchWorkFlow];
}


- (void)switchWorkFlow{
    MemberCenterManager *memberManager = [MemberCenterManager singletonInstance];
    if ([memberManager currentUser]) {
        if ([memberManager currentUserType] == MemberCenterUserTypeSupplier) {
            self.isSeller = NO;
        }else if([memberManager currentUserType] == MemberCenterUserTypeSeller){
            self.isSeller = YES;
        }
        [self setUpInitialView];
    }
    else{
        [self presentLoginWorkFlow];
    }

}

- (void)loadSellerWorkFlow{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MLTabBarViewController *tabbar = [storyBoard instantiateViewControllerWithIdentifier:@"SellersTabViewController"];
    [self.view addSubview:tabbar.view];
    [self addChildViewController:tabbar];
    [tabbar didMoveToParentViewController:self];
}

- (void)loadSupplierWorkFlow{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MLTabBarViewController *tabbar = [storyBoard instantiateViewControllerWithIdentifier:@"SuppliersTabViewController"];
    [self.view addSubview:tabbar.view];
    [self addChildViewController:tabbar];
    [tabbar didMoveToParentViewController:self];

}


- (void)presentLoginWorkFlow{
   
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MLNavigationController *navi = [storyboard instantiateViewControllerWithIdentifier:@"LoginAndRegistNaviController"];
    [self.view addSubview:navi.view];
    [self addChildViewController:navi];
    [navi didMoveToParentViewController:self];
}


- (void)changeToMainWorkFlow{
    [self.loginNaviVC.view removeFromSuperview];
    [self.loginNaviVC removeFromParentViewController];
    
    
    [self switchWorkFlow];
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

@end
