//
//  WBUser.m
//  微博
//
//  Created by 朱占龙 on 16/8/13.
//  Copyright © 2016年 cuit. All rights reserved.
//  

#import "WBUser.h"

@implementation WBUser

- (void)setMbtype:(int)mbtype{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}
@end
