//
//  WBTextPart.h
//  微博
//
//  Created by 朱占龙 on 2016/11/18.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBTextPart : NSObject

/** 文字 */
@property(nonatomic, copy) NSString *text;
/** 范围 */
@property(nonatomic, assign) NSRange range;
/** 是否为特殊文字 */
@property(nonatomic, assign,getter = isSpecial) BOOL special;
/** 是否为表情 */
@property(nonatomic, assign,getter = isEmotion) BOOL emotion;
@end
