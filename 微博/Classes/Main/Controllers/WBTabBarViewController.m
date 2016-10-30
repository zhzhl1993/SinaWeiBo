//
//  WBTabBarViewController.m
//  微博
//
//  Created by 朱占龙 on 16/7/8.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBTabBarViewController.h"
#import "HomeViewController.h"
#import "MessagerCenterViewController.h"
#import "ProfileViewController.h"
#import "DiscoverViewController.h"
#import "WBNaigationController.h"
#import "WBTabBar.h"
#import "ComposeViewController.h"

#define titleColor [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1]
#define randomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]

@interface WBTabBarViewController ()<WBTabBarDelegate>

@end

@implementation WBTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.创建tabbar
    HomeViewController *homeVc = [[HomeViewController alloc] init];
    [self addChildVcWithChildVc:homeVc Title: @"首页" image: @"tabbar_home" seletedImage: @"tabbar_home_selected"];
   
    MessagerCenterViewController *messageVc = [[MessagerCenterViewController alloc] init];
    [self addChildVcWithChildVc: messageVc Title: @"消息" image: @"tabbar_message_center" seletedImage: @"tabbar_message_center_selected"];
    
    DiscoverViewController *discoverVc = [[DiscoverViewController alloc] init];
    [self addChildVcWithChildVc:discoverVc Title: @"发现" image: @"tabbar_discover" seletedImage: @"tabbar_discover_selected"];
   
    ProfileViewController *profileVc = [[ProfileViewController alloc] init];
    [self addChildVcWithChildVc:profileVc Title: @"我" image: @"tabbar_profile" seletedImage: @"tabbar_profile_selected"];
    
    //2.更改系统默认的tabBar
    
//    self.tabBar = [[WBTabBar alloc] init];//不能用此方法更改，因为属性为只读
    WBTabBar *tabBar = [[WBTabBar alloc] init];
    tabBar.delegate = self;
    [self setValue: tabBar forKey:@"tabBar"];
    
}

/**
 *  为根控制器添加子控制器
 *
 *  @param childVc      子控制器
 *  @param title        控制器标题
 *  @param image        控制器图片名称
 *  @param seletedImage 选中图片名称
 */
- (void) addChildVcWithChildVc: (UIViewController *)childVc Title: (NSString *)title image: (NSString *)image seletedImage: (NSString *)seletedImage{
    
    //添加标题
//    childVc.navigationItem.title = title;
//    childVc.tabBarItem.title = title;
    childVc.title = title;//等价于上面两句
    
    //设置图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    //默认会对图片渲染，需要自己设置
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:seletedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置文字颜色
    NSMutableDictionary *titleAttrs = [NSMutableDictionary dictionary];
    titleAttrs[NSForegroundColorAttributeName] = titleColor;
    [childVc.tabBarItem setTitleTextAttributes:titleAttrs forState:UIControlStateNormal];
    NSMutableDictionary *selectedTitleAttrs = [NSMutableDictionary dictionary];
    selectedTitleAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:selectedTitleAttrs forState:UIControlStateSelected];
    
    //首先为控制器添加一个导航栏
    WBNaigationController *nav = [[WBNaigationController alloc] initWithRootViewController: childVc];
    
    //将当前子控制器添加到父控制器
    [self addChildViewController: nav];
}

/**
 *  WBTabBarDelegate的实现
 */

- (void)tabBarDidClickPlusButton:(WBTabBar *)tabBar{
    
    ComposeViewController *composeVc = [[ComposeViewController alloc] init];
    WBNaigationController *navi = [[WBNaigationController alloc] initWithRootViewController:composeVc];
    [self presentViewController:navi animated:YES completion:nil];
}
@end
