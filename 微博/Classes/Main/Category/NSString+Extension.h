//
//  NSString+Extension.h
//  微博
//
//  Created by 朱占龙 on 16/9/17.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
/**
 *  根据时间字体计算该文本的大小，限制最大宽度
 *  @param font     字体
 *  @param MaxWidth 最大宽度
 *
 *  @return 返回计算好的尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font MaxWidth:(CGFloat)MaxWidth;
/**
 *  根据时间字体计算该文本的大小，不限制最大宽度
 *
 *  @param font 字体
 *
 *  @return 返回计算好的尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font;
@end
