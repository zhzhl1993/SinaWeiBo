//
//  WBTextPart.m
//  微博
//
//  Created by 朱占龙 on 2016/11/18.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBTextPart.h"

@implementation WBTextPart

- (NSString *)description{
    return [NSString stringWithFormat:@"%@---%@",self.text, NSStringFromRange(self.range)];
}
@end
