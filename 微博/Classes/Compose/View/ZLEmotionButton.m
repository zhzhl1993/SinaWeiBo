//
//  ZLEmotionButton.m
//  微博
//
//  Created by 朱占龙 on 2016/11/7.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "ZLEmotionButton.h"
#import "WBEmotionModel.h"

@implementation ZLEmotionButton

/** 当控件不是从xib、storyBoard中创建时候就会调用这个方法 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       [self setup];
    }
    return self;
}

/** 当控件从xib、storyBoard中创建时候就会调用这个方法 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
/** 当控件执行完initWithCoder的时候就会调用这个方法 */
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

/** 初始化方法 */
- (void)setup{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    /** 按钮高亮的时候不调整图片（按钮变灰色） */
    self.adjustsImageWhenHighlighted = NO;
}

- (void)setEmotion:(WBEmotionModel *)emotion{
    _emotion = emotion;
    if (emotion.png) {
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    }else if (emotion.code){
        //设置emoji
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }
}
@end
