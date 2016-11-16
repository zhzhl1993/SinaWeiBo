//
//  WBEmotionModel.m
//  微博
//
//  Created by 朱占龙 on 2016/11/5.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBEmotionModel.h"
#import "MJExtension.h"

@interface WBEmotionModel()<NSCoding>


@end
@implementation WBEmotionModel
/*
 *   对模型中的属性归档和解档
 */
MJCodingImplementation

/**
 *  常用来比较两个WBEmotionModel对象是否一样
 */
- (BOOL)isEqual:(WBEmotionModel *)object{
    return ([self.chs isEqualToString:object.chs] || [self.code isEqual:object.code]);
}
@end
