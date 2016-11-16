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
#import "WBEmotionModel.h"
#import "MJExtension.h"
#import "WBEmotionTool.h"

@interface ZLEmotionKeyboard()<ZLEmotionTabBarDelegate>
/** contentView */
@property(nonatomic, weak) UIView *contentView;
/** 最近表情按钮 */
@property(nonatomic, strong) ZLEmotionListView *recentListView;
/** 默认表情按钮 */
@property(nonatomic, strong) ZLEmotionListView *defaultListView;
/** emoji表情按钮 */
@property(nonatomic, strong) ZLEmotionListView *emojiListView;
/** 浪小花表情按钮 */
@property(nonatomic, strong) ZLEmotionListView *lxhListView;
/** tabBar */
@property(nonatomic, weak) ZLEmotionTabBar *tabBar;
@end
@implementation ZLEmotionKeyboard
#pragma mark - 懒加载
- (ZLEmotionListView *)recentListView{
    if (!_recentListView) {
        _recentListView = [[ZLEmotionListView alloc] init];
        _recentListView.emotions = [WBEmotionTool recentEmotions];
    }
    return _recentListView;
}
- (ZLEmotionListView *)defaultListView{
    if (!_defaultListView) {
        _defaultListView = [[ZLEmotionListView alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
    NSArray *defaultEmotion = [WBEmotionModel objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    _defaultListView.emotions = defaultEmotion;
    }
    return _defaultListView;
}
- (ZLEmotionListView *)emojiListView{
    if (!_emojiListView) {
        _emojiListView = [[ZLEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        NSArray *emojiEmotion = [WBEmotionModel objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        _emojiListView.emotions = emojiEmotion;
    }
    return _emojiListView;
}
- (ZLEmotionListView *)lxhListView{
    if (!_lxhListView) {
        _lxhListView = [[ZLEmotionListView alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        NSArray *lxhEmotion = [WBEmotionModel objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
        _lxhListView.emotions = lxhEmotion;
    }
    return _lxhListView;
}
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //1.表情视图
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor redColor];
        self.contentView = contentView;
        [self addSubview:contentView];
        
        //2.tabBar
        ZLEmotionTabBar *tabBar = [[ZLEmotionTabBar alloc] init];
        tabBar.delegate = self;
        self.tabBar = tabBar;
        [self addSubview:tabBar];
        
        //表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected) name:emotionSelectNotification object:nil];
    }
    return self;
}
- (void)emotionDidSelected{
    self.recentListView.emotions = [WBEmotionTool recentEmotions];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //1.tabBar
    self.tabBar.x = 0;
    self.tabBar.height = 44;
    self.tabBar.y = self.height - self.tabBar.height;
    self.tabBar.width = screenWidth;
    //2.表情视图
    self.contentView.height = self.tabBar.y;
    self.contentView.width = screenWidth;
    self.contentView.x = 0;
    self.contentView.y = 0;
    
    //设置frame
    UIView *childView = [self.contentView.subviews lastObject];
    childView.frame = self.contentView.bounds;
}

#pragma mark - ZLEmotionTabBarDelegate
- (void)emotionTabBar:(ZLEmotionTabBar *)tabBar didSelectButton:(ZLEmotionTabBarButtonType)btnType{
    
    /**  */
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    switch (btnType) {
        case ZLEmotionTabBarButtonTypeRecent:{//最近
            [self.contentView addSubview:self.recentListView];
            break;
        }
        case ZLEmotionTabBarButtonTypeDefault:{//默认
            [self.contentView addSubview:self.defaultListView];
            break;
        }
        case ZLEmotionTabBarButtonTypeEmoji:{//emoji
            [self.contentView addSubview:self.emojiListView];
            break;
        }
        case ZLEmotionTabBarButtonTypeLxh:{//浪小花
            [self.contentView addSubview:self.lxhListView];
            break;
        }
        default:
            break;
    }
    
    [self setNeedsLayout];
}
@end
