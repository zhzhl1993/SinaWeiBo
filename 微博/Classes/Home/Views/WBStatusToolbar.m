//
//  WBStatusToolbar.m
//  微博
//
//  Created by 朱占龙 on 16/9/5.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBStatusToolbar.h"

@implementation WBStatusToolbar


+ (instancetype)toolbar{
    
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupBtnWith:@"转发" icon:@"timeline_icon_retweet"];
        [self setupBtnWith:@"评论" icon:@"timeline_icon_comment"];
        [self setupBtnWith:@"点赞" icon:@"timeline_icon_unlike"];
    }
    return self;
}
/**
 *  初始化一个按钮
 *
 *  @param title 标题
 *  @param icon  图片
 */
- (void)setupBtnWith:(NSString *)title icon:(NSString *)icon{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    int count = self.subviews.count;
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
