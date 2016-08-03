//
//  WBTabBar.m
//  微博
//
//  Created by 朱占龙 on 16/7/13.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBTabBar.h"

@interface WBTabBar()

@property (nonatomic, weak) UIButton *plusButton;
@end

@implementation WBTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //添加中间的加号tabBar
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [plusButton setBackgroundImage: [UIImage imageNamed: @"tabbar_compose_button"] forState:UIControlStateNormal];
        [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [plusButton setImage: [UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        plusButton.size = plusButton.currentBackgroundImage.size;
        [plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusButton];
        self.plusButton = plusButton;
    }
    return self;
}

- (void)plusClick{
    
    if([self.delegate respondsToSelector:@selector(tabBarDidClickPlusButton:)])
    {
        [self.delegate tabBarDidClickPlusButton:self];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //1.设置加号按钮的位置
    self.plusButton.centerX = self.width * 0.5;
    self.plusButton.centerY = self.height * 0.5;
    
    //2.设置其他按钮的位置
    CGFloat tabBarButtonW = self.width / 5;
    CGFloat tabBarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            child.width = tabBarButtonW;
            child.x = tabBarButtonIndex * tabBarButtonW;
            tabBarButtonIndex ++;
            if (tabBarButtonIndex == 2) {
                tabBarButtonIndex++;
            }
        }
    }
}
@end
