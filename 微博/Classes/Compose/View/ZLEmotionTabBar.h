//
//  ZLEmotionTabBar.h
//  微博
//
//  Created by 朱占龙 on 2016/11/4.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ZLEmotionTabBarButtonTypeRecent,//最近
    ZLEmotionTabBarButtonTypeDefault,//默认
    ZLEmotionTabBarButtonTypeEmoji,//emoji
    ZLEmotionTabBarButtonTypeLxh,//浪小花
} ZLEmotionTabBarButtonType;

@class ZLEmotionTabBar;

@protocol ZLEmotionTabBarDelegate <NSObject>

- (void)emotionTabBar:(ZLEmotionTabBar *)tabBar didSelectButton:(ZLEmotionTabBarButtonType)btnType;

@end
@interface ZLEmotionTabBar : UIView

@property(nonatomic, weak) id<ZLEmotionTabBarDelegate> delegate;
@end
