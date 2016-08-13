//
//  WBAccountTool.m
//  微博
//
//  Created by 朱占龙 on 16/8/8.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBAccountTool.h"
#import "WBAccountModel.h"


#define WBAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"accout.archive"]

@implementation WBAccountTool

/**
 *  存储账号信息
 *
 *  @param account 账号模型·
 */
+(void)saveAccountWithAccount:(WBAccountModel *)account{
    
    //自定义对象的存储必须用NSKeyedArchiver，writeToFile是字典和数组的方法
    [NSKeyedArchiver archiveRootObject:account toFile:WBAccountPath];
}

/**
 *  获得账号信息
 *
 *  @return 返回账号信息（如果账号过期，返回nil）
 */
+ (WBAccountModel *)account{
    
    WBAccountModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:WBAccountPath];
    
    //过期秒数
    long long expires_in = [account.expires_in longLongValue];
    
    //获得过期时间
    NSDate *expireTime = [account.save_time dateByAddingTimeInterval:expires_in];
    
    //当前时间
    NSDate *now = [NSDate date];
    
    NSComparisonResult result = [expireTime compare:now];
    /*NSOrderedAscending = -1L, 
     NSOrderedSame,
     NSOrderedDescending*/
    if (result != NSOrderedDescending) {
        //过期
        return nil;
    }
    return account;
}
@end
