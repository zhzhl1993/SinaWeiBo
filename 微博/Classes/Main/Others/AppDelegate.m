//
//  AppDelegate.m
//  微博
//
//  Created by 朱占龙 on 16/6/21.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "AppDelegate.h"
#import "WBTabBarViewController.h"
#import "NewFeatureController.h"
#import "WBOAuthViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //2.创建根控制器
    
    self.window.rootViewController = [[WBOAuthViewController alloc] init];

//    //上一次使用的版本号（沙盒中）
//    NSString *key = @"CFBundleVersion";
//    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//
//    //显示当前版本号（info.plist文件中读取）
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
//
//    //判断是否显示版本新特性
//    if ([currentVersion isEqualToString:lastVersion]) {
//        //和上一个版本相同，不需要显示新特性
//        self.window.rootViewController = [[WBTabBarViewController alloc] init];
//    }else{
//        //和上一个版本不同，显示新特性
//        self.window.rootViewController = [[NewFeatureController alloc] init];
//        //将当前版本号存储到沙盒中
//        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
