//
//  WBStatus.h
//  微博
//
//  Created by 朱占龙 on 16/8/13.
//  Copyright © 2016年 cuit. All rights reserved.
//  最新微博模型

#import <Foundation/Foundation.h>
@class WBUser;

@interface WBStatus : NSObject

/** string 字符串类型的微博UID */
@property(nonatomic, copy) NSString *idstr;
/** string 微博信息内容 */
@property(nonatomic, copy) NSString *text;
/** object 微博作者的用户字段 */
@property(nonatomic, strong) WBUser *user;
/** string 创建时间 */
@property(nonatomic, copy) NSString *created_at;
/** string 来源 */
@property(nonatomic, copy) NSString *source;
/** NSArray 图片 */
@property(nonatomic, copy) NSArray *pic_urls;
/** 转发微博 */
@property(nonatomic, strong) WBStatus *retweeted_status;

@end
