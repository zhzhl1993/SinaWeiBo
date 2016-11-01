//
//  WBComposeToolBar.m
//  微博
//
//  Created by 朱占龙 on 2016/10/31.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBComposeToolBar.h"

@implementation WBComposeToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        [self setupBtnWithImage:@"compose_camerabutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:WBComposeToolBarButtonCamera];
        [self setupBtnWithImage:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted"type:WBComposeToolBarButtonPicture];
        [self setupBtnWithImage:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted"type:WBComposeToolBarButtonMention];
        [self setupBtnWithImage:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted"type:WBComposeToolBarButtonTrend];
        [self setupBtnWithImage:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted"type:WBComposeToolBarButtonEmotion];
    }
    return self;
}

- (void)setupBtnWithImage:(NSString *)image highImage:(NSString *)highImgae type:(WBComposeToolBarButtonType)type{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImgae] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = type;
    [self addSubview:button];
}
- (void)buttonClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(composeToolBar:didClickButton:)]) {
        [self.delegate composeToolBar:self didClickButton:btn.tag];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    NSUInteger count = self.subviews.count;
    CGFloat btnWidth = self.width / count;
    CGFloat btnHeight = self.height;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = self.subviews[i];
        button.y = 0;
        button.width = btnWidth;
        button.x = i * btnWidth;
        button.height = btnHeight;
    }
    
}
@end
