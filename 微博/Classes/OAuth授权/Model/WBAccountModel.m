//
//  WBAccountModel.m
//  微博
//
//  Created by 朱占龙 on 16/8/7.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBAccountModel.h"

@implementation WBAccountModel

+ (instancetype)accountWithDict: (NSDictionary *)dict{
    WBAccountModel *account = [[self alloc] init];
    account.access_token = dict[@"access_token"];
    account.expires_in = dict[@"expires_in"];
    account.uid = dict[@"uid"];
    return account;
}


/**
 *  当一个对象将要归档进沙盒时候回调用这个方法
 *
 *  目的：在这个方法中声明这个对象的哪些属性需要归档
 */
- (void)encodeWithCoder:(NSCoder *)encoder{
    
    [encoder encodeObject:self.access_token forKey:@"access_token"];
    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
    [encoder encodeObject:self.uid forKey:@"uid"];
    [encoder encodeObject:self.save_time forKey:@"save_time"];
}


/**
 *  当一个对象从沙盒解档时候调用这个方法
 *
 *  目的：在这个方法中声明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (instancetype)initWithCoder:(NSCoder *)decoder{
    
    if (self = [super init]) {
        self.access_token = [decoder decodeObjectForKey:@"access_token"];
        self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.save_time = [decoder decodeObjectForKey:@"save_time"];

    }
    return self;
}
@end
