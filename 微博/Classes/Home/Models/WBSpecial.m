//
//  WBSpecial.m
//  微博
//
//  Created by 朱占龙 on 2016/11/24.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBSpecial.h"

@implementation WBSpecial

- (NSString *)description{
    return [NSString stringWithFormat:@"%@---%@",self.text, NSStringFromRange(self.range)];
}
@end
