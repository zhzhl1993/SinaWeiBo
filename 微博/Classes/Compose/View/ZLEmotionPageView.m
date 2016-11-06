//
//  ZLEmotionPageView.m
//  微博
//
//  Created by 朱占龙 on 2016/11/6.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "ZLEmotionPageView.h"
#import "WBEmotionModel.h"

@implementation ZLEmotionPageView

- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.font = [UIFont systemFontOfSize:32];
        WBEmotionModel *model = emotions[i];
        if (model.png) {
            [btn setImage:[UIImage imageNamed:model.png] forState:UIControlStateNormal];
        }else if (model.code){
            //设置emoji
            [btn setTitle:model.code.emoji forState:UIControlStateNormal];
        }
        [self addSubview:btn];
    }
    WBLog(@"%lu",(unsigned long)emotions.count);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat inset = 10;
    CGFloat btnW = (self.width - inset) / ZLEmotionMaxCols;
    CGFloat btnH = (self.height - inset) /ZLEmotionMaxRows;
    NSUInteger count = self.subviews.count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = (UIButton *)self.subviews[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i % 7) * btnW;
        btn.y = inset + (i / 7) * btnH;
    }
}
@end
