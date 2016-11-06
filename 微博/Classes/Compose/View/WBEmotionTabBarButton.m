//
//  WBEmotionTabBarButton.m
//  微博
//
//  Created by 朱占龙 on 2016/11/4.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBEmotionTabBarButton.h"

@implementation WBEmotionTabBarButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        //字体
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        
        //设置文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    }
    return self;
}
//取消高粱状态
- (void)setHighlighted:(BOOL)highlighted{
    
}

@end
