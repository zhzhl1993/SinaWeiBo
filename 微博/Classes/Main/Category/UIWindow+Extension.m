//
//  UIWindow+Extension.m
//  微博
//
//  Created by 朱占龙 on 16/8/9.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "WBTabBarViewController.h"
#import "NewFeatureController.h"

@implementation UIWindow (Extension)

- (void)switchViewController{
    
    //上一次使用的版本号（沙盒中）
    NSString *key = @"CFBundleVersion";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    //显示当前版本号（info.plist文件中读取）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    //判断是否显示版本新特性
    if ([currentVersion isEqualToString:lastVersion]){
        //和上一个版本相同，不需要显示新特性
        self.rootViewController = [[WBTabBarViewController alloc] init];
    }else{
        //和上一个版本不同，显示新特性
        self.rootViewController = [[NewFeatureController alloc] init];
        //将当前版本号存储到沙盒中
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
