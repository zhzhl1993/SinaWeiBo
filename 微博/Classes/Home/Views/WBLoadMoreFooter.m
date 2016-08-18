//
//  WBLoadMoreFooter.m
//  微博
//
//  Created by 朱占龙 on 16/8/18.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBLoadMoreFooter.h"

@implementation WBLoadMoreFooter

+ (instancetype)footer{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WBLoadMoreFooter" owner:nil options:nil] lastObject];
}
@end
