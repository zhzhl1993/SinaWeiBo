//
//  WBAccountModel.h
//  微博
//
//  Created by 朱占龙 on 16/8/7.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBAccountModel : NSObject<NSCoding>

/**用户授权的唯一票据*/
@property (nonatomic, copy) NSString *access_token;
/**access_token的生命周期，单位是秒数。*/
@property (nonatomic, copy) NSString *expires_in;
/**授权用户的UID*/
@property (nonatomic, copy) NSString *uid;
/**获得accessToken的时间*/
@property (nonatomic, strong) NSDate *save_time;

/**保存用户登录后的信息*/
+ (instancetype)accountWithDict: (NSDictionary *)dict;
@end
