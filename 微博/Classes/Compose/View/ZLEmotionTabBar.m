//
//  ZLEmotionTabBar.m
//  微博
//
//  Created by 朱占龙 on 2016/11/4.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "ZLEmotionTabBar.h"
#import "WBEmotionTabBarButton.h"

@interface ZLEmotionTabBar()
/** 选中的按钮 */
@property(nonatomic, strong) UIButton *selectedBtn;
@end
@implementation ZLEmotionTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setupBtn:@"最近" withButtonType:ZLEmotionTabBarButtonTypeRecent];
        [self setupBtn:@"默认" withButtonType:ZLEmotionTabBarButtonTypeDefault];
        [self setupBtn:@"Emoji" withButtonType:ZLEmotionTabBarButtonTypeEmoji];
        [self setupBtn:@"浪小花" withButtonType:ZLEmotionTabBarButtonTypeLxh];
    }
    return self;
}

/*
 *  创建一个按钮
 */
- (UIButton *)setupBtn:(NSString *)title withButtonType:(ZLEmotionTabBarButtonType)type{
    WBEmotionTabBarButton *btn = [[WBEmotionTabBarButton alloc] init];
    [btn addTarget:self action:@selector(clcikTabBar:) forControlEvents:UIControlEventTouchDown];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = type;
    
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectedImage = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 0) {
        image = @"compose_emotion_table_left_normal";
        selectedImage = @"compose_emotion_table_left_selected";
    }else if (self.subviews.count == 4){
        image = @"compose_emotion_table_right_normal";
        selectedImage = @"compose_emotion_table_right_selected";
    }
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateDisabled];
    [self addSubview:btn];
    
    return btn;
}

- (void)setDelegate:(id<ZLEmotionTabBarDelegate>)delegate{
    _delegate = delegate;
    
    [self clcikTabBar:[self viewWithTag:ZLEmotionTabBarButtonTypeDefault]];
}
- (void)clcikTabBar:(UIButton *)btn{
    
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)]) {
        [self.delegate emotionTabBar:self didSelectButton:btn.tag];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        btn.x = i * btnW;
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
    }
}
@end
