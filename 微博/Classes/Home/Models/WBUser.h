//
//  WBUser.h
//  微博
//
//  Created by 朱占龙 on 16/8/13.
//  Copyright © 2016年 cuit. All rights reserved.
//  用户信息模型

#import <Foundation/Foundation.h>

@interface WBUser : NSObject

/**string 字符串类型的用户UID*/
@property(nonatomic, copy) NSString *idstr;
/**string 用户显示名称*/
@property(nonatomic, copy) NSString *name;
/**string 用户头像地址*/
@property(nonatomic, copy) NSString *profile_image_url;
/** 会员类型 值>2表示才是会员 */
@property(nonatomic, assign) int mbtype;
/** 会员等级 */
@property(nonatomic, assign) int mbrank;
/** 会员等级 */
@property(nonatomic, assign, getter = isvip) BOOL vip;
@end
