//
//  AppDelegate.m
//  微博
//
//  Created by 朱占龙 on 16/6/21.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "AppDelegate.h"
#import "WBOAuthViewController.h"
#import "WBAccountTool.h"
#import "SDWebImageManager.h"

#define kDeviceVersion  [[UIDevice currentDevice] systemVersion].floatValue

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //2.创建根控制器
    WBAccountModel *account = [WBAccountTool account];
    if (account) {
        //之前已经登录成功过
        //切换控制器
        [self.window switchViewController];
        
    }else{
        self.window.rootViewController = [[WBOAuthViewController alloc] init];
    }
    //3.设置主窗口
    [self.window makeKeyAndVisible];
    
    /**
     *  注册通知
     */
    if (kDeviceVersion >= 8.0) {
        // 使用本地通知 (本例中只是badge，但是还有alert和sound都属于通知类型,其实如果只进行未读数在appIcon显示,只需要badge就可, 这里全写上为了方便以后的使用)
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        // 进行注册
        [application registerUserNotificationSettings:settings];
    }
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    //1.取消下载
    [mgr cancelAll];
    //2.清除内存中的所有图片
    [mgr.imageCache clearMemory];
}

/**
 *  当程序进入后台的时候调用
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    /**
     *  app的状态
     *  1.死亡状态
     *  2.前台运行状态
     *  3.后台暂停状态，停止一切动画、定时器、多媒体、联网操作
     *  4.后台运行状态
     */
    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        
        [application endBackgroundTask:task];
    }];
    
    //搞一个0KB的MP3文件，没有声音，
    //循环播放
    
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
