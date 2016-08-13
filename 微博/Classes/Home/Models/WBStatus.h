//
//  WBStatus.h
//  微博
//
//  Created by 朱占龙 on 16/8/13.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WBUser;

@interface WBStatus : NSObject

/**string 字符串类型的微博UID*/
@property(nonatomic, copy) NSString *idstr;
/**string 微博信息内容*/
@property(nonatomic, copy) NSString *text;
/**object 微博作者的用户字段*/
@property(nonatomic, copy) WBUser *user;

+ (instancetype)statusWithDict:(NSDictionary *)dict;
@end
