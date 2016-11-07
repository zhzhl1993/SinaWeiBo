//
//  UITextView+Extension.m
//  微博
//
//  Created by 朱占龙 on 2016/11/7.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)

- (void)insertAttributeText:(NSAttributedString *)text{
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] init];
    [attrText appendAttributedString:self.attributedText];
    CGFloat loc = self.selectedRange.location;
    [attrText insertAttributedString:text atIndex:loc];
    
    //设置字体
    [attrText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attrText.length)];
    
    self.attributedText = attrText;
    
    //设置完文字移动光标到文字后面
    self.selectedRange = NSMakeRange(loc + 1, 0);
}
@end
