//
//  WBAccountTool.h
//  微博
//
//  Created by 朱占龙 on 16/8/8.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WBAccountModel;

@interface WBAccountTool : NSObject

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */
+ (void)saveAccountWithAccount:(WBAccountModel *)account;

/**
 *  账号信息
 *
 *  @return 返回账号信息
 */
+ (WBAccountModel *)account;
@end
