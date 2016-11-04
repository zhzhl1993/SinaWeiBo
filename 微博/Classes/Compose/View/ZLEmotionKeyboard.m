//
//  ZLEmotionKeyboard.m
//  微博
//
//  Created by 朱占龙 on 2016/11/4.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "ZLEmotionKeyboard.h"
#import "ZLEmotionListView.h"
#import "ZLEmotionTabBar.h"

@interface ZLEmotionKeyboard()<ZLEmotionTabBarDelegate>
/** 表情按钮 */
@property(nonatomic, strong) ZLEmotionListView *listView;
/** tabBar */
@property(nonatomic, strong) ZLEmotionTabBar *tabBar;
@end
@implementation ZLEmotionKeyboard

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //1.表情视图
        ZLEmotionListView *listView = [[ZLEmotionListView alloc] init];
        listView.backgroundColor = YYRandomColor;
        self.listView = listView;
        [self addSubview:listView];
        
        //2.tabBar
        ZLEmotionTabBar *tabBar = [[ZLEmotionTabBar alloc] init];
        tabBar.delegate = self;
        self.tabBar = tabBar;
        [self addSubview:tabBar];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //1.tabBar
    self.tabBar.x = 0;
    self.tabBar.height = 44;
    self.tabBar.y = self.height - self.tabBar.height;
    self.tabBar.width = screenWidth;
    //2.表情视图
    self.listView.height = self.height - self.tabBar.y;
    self.listView.width = screenWidth;
    self.listView.x = 0;
    self.listView.y = 0;
    
}

#pragma mark - ZLEmotionTabBarDelegate
- (void)emotionTabBar:(ZLEmotionTabBar *)tabBar didSelectButton:(ZLEmotionTabBarButtonType)btnType{
    
    switch (btnType) {
        case ZLEmotionTabBarButtonTypeRecent://最近
            
            break;
        case ZLEmotionTabBarButtonTypeDefault://默认
            
            break;
        case ZLEmotionTabBarButtonTypeEmoji://emoji
            
            break;
        case ZLEmotionTabBarButtonTypeLxh://浪小花
            
            break;
        default:
            break;
    }
}
@end
