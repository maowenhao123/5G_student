//
//  MainTabBarController.m
//  5G_student
//
//  Created by dahe on 2020/1/8.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "MainTabBarController.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "OnetooneViewController.h"
#import "ScheduleViewController.h"
#import "MineViewController.h"
#import "UIImage+Category.h"
#import "MUserDefaultTool.h"

@interface MainTabBarController ()<UITabBarControllerDelegate>

@end

@implementation MainTabBarController

+ (void)initialize
{
    UITabBar * tabBar = [UITabBar appearance];
    // 设置背景
    [tabBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, MScreenWidth, MTabBarH)]];
    tabBar.tintColor = MDefaultColor;
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [[UITabBarItem appearance] setTitleTextAttributes:textAttrs
                                             forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    [self setupTabbars];
    [self getCategoryData];
    //接收去首页的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoHomePage) name:@"gotoHomePage" object:nil];
    //接收个人中心的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMine) name:@"gotoMine" object:nil];
}

#pragma mark - 跳转
//去首页
- (void)gotoHomePage
{
    self.selectedIndex = 0;
}
- (void)gotoMine
{
    self.selectedIndex = 3;
}

#pragma mark - 添加控制器
- (void)setupTabbars
{
    // 1.上课
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    [self addChildViewController:homeVC title:@"上课" image:@"btn_home" selImage:@"btn_home_click" index:1];
   
    // 2.一对一
    OnetooneViewController *onetooneVC = [[OnetooneViewController alloc] init];
    [self addChildViewController:onetooneVC title:@"一对一" image:@"btn_wode" selImage:@"btn_wode_click" index:2];
    
    // 3.课表
    ScheduleViewController *scheduleVC = [[ScheduleViewController alloc] init];
    [self addChildViewController:scheduleVC title:@"课表" image:@"btn_wode" selImage:@"btn_wode_click" index:3];
    
    // 4.我的
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self addChildViewController:mineVC title:@"我的" image:@"btn_wode" selImage:@"btn_wode_click" index:4];
}

- (void)addChildViewController:(UIViewController *)childVc  title:(NSString *)title image:(NSString *)image selImage:(NSString *)selImage index:(NSInteger)index
{
    image = @"tabber_groupon_selected";
    selImage = @"tabber_groupon_selected";
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:childVc];
    nav.view.tag = index;
    [self addChildViewController:nav];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(viewController.view.tag == 2)
    {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        BaseNavigationController * loginNVC = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
        loginNVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:loginNVC animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)getCategoryData
{
    NSDictionary *parameters = @{
    };
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/api/course/category/list" success:^(id json) {
        if (SUCCESS) {
            [MUserDefaultTool saveCategoryList:json[@"data"][@"list"]];
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
    }];
}


@end
