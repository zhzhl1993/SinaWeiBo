//
//  WBSpecial.h
//  微博
//
//  Created by 朱占龙 on 2016/11/24.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBSpecial : NSObject

/** 这段特殊文字的内容 */
@property(nonatomic, copy) NSString *text;
/** 这段特殊文字的范围 */
@property(nonatomic, assign) NSRange range;
/** 这段特殊文字的矩形框 */
@property(nonatomic, strong) NSArray *rects;
@end
