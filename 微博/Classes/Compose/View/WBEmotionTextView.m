//
//  WBEmotionTextView.m
//  微博
//
//  Created by 朱占龙 on 2016/11/7.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBEmotionTextView.h"
#import "WBEmotionModel.h"
#import "WBEmotionAttachment.h"

@implementation WBEmotionTextView


- (void)insertEmotion:(WBEmotionModel *)emotion{
    if (emotion.code) {//emoji
        [self insertText:emotion.code.emoji];
    }else{//拼接图片
        WBEmotionAttachment *attach = [[WBEmotionAttachment alloc] init];
        attach.emotion = emotion;
        
        CGFloat attachWH = self.font.lineHeight;
        attach.bounds = CGRectMake(0, -4, attachWH, attachWH);
        //根据附件创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
        //插入文字
        [self insertAttributedText:imageStr settingBlock:^(NSMutableAttributedString *attributedText){
            //设置文字字体属性
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }];
    }
}

- (NSString *)fullText{
    //便利所有的属性文字
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        WBEmotionAttachment *attach = attrs[@"NSAttachment"];
        NSMutableString *fullText = [NSMutableString string];
        if (attach) {//图片表情
            [fullText appendString:attach.emotion.chs];
        }else{//普通文本或者emoji表情
            //取出范围里面的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    return @"123";
}
@end
