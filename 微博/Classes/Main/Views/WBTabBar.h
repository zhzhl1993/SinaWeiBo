//
//  WBTabBar.h
//  微博
//
//  Created by 朱占龙 on 16/7/13.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBTabBar;

@protocol WBTabBarDelegate <UITabBarDelegate>

@optional

- (void)tabBarDidClickPlusButton: (WBTabBar *)tabBar;
@end

@interface WBTabBar : UITabBar

@property (nonatomic, weak) id <WBTabBarDelegate> delegate;
@end
