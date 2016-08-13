//
//  WBUser.m
//  微博
//
//  Created by 朱占龙 on 16/8/13.
//  Copyright © 2016年 cuit. All rights reserved.
//  用户模型

#import "WBUser.h"

@implementation WBUser

+ (instancetype)userWithDict:(NSDictionary *)dict{
    
    WBUser *user = [[self alloc] init];
    
    user.idstr = dict[@"idstr"];
    user.name = dict[@"name"];
    user.profile_image_url = dict[@"profile_image_url"];
    
    return user;
}
@end
