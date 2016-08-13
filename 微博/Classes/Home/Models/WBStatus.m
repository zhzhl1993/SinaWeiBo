//
//  WBStatus.m
//  微博
//
//  Created by 朱占龙 on 16/8/13.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBStatus.h"
#import "WBUser.h"

@implementation WBStatus

+ (instancetype)statusWithDict:(NSDictionary *)dict{

    WBStatus *status = [[self alloc] init];
    status.idstr = dict[@"idstr"];
    status.text = dict[@"text"];
    status.user = [WBUser userWithDict:dict[@"user"]];
    return status;
}
@end
