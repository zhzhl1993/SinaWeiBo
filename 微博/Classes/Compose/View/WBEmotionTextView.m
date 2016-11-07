//
//  WBEmotionTextView.m
//  微博
//
//  Created by 朱占龙 on 2016/11/7.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBEmotionTextView.h"
#import "WBEmotionModel.h"

@implementation WBEmotionTextView


- (void)insertEmotion:(WBEmotionModel *)emotion{
    if (emotion.code) {//emoji
        [self insertText:emotion.code.emoji];
    }else{
        //拼接图片
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:emotion.png];
        CGFloat attachWH = self.font.lineHeight;
        attach.bounds = CGRectMake(0, -4, attachWH, attachWH);
        //根据附件创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
        
        [self insertAttributeText:imageStr];
    }
}
@end
