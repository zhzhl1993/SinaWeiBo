//
//  UITextView+Extension.m
//  微博
//
//  Created by 朱占龙 on 2016/11/7.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)

- (void)insertAttributedText:(NSAttributedString *)text{
    [self insertAttributedText:text settingBlock:nil];
}

- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *))settingBlock{
    
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] init];
    [attrText appendAttributedString:self.attributedText];
    NSUInteger loc = self.selectedRange.location;
    [attrText replaceCharactersInRange:self.selectedRange withAttributedString:text];
    //调用外面传进来的代码
    if (settingBlock) {
        settingBlock(attrText);
    }
    self.attributedText = attrText;
    //设置完文字移动光标到文字后面
    self.selectedRange = NSMakeRange(loc + 1, 0);
}
@end
