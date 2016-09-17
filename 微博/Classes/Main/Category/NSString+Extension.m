//
//  NSString+Extension.m
//  微博
//
//  Created by 朱占龙 on 16/9/17.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

/**
 *  根据时间字体计算该文本的大小，限制最大宽度
 *  @param font     字体
 *  @param MaxWidth 最大宽度
 */
- (CGSize)sizeWithFont:(UIFont *)font MaxWidth:(CGFloat)MaxWidth{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    return [self boundingRectWithSize:CGSizeMake(MaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
/**
 *  根据时间字体计算该文本的大小，不限制最大宽度
 *  @param font     字体
 *  @param MaxWidth 最大宽度
 */

- (CGSize)sizeWithFont:(UIFont *)font{
    
    return [self sizeWithFont:font MaxWidth:MAXFLOAT];
}
@end
