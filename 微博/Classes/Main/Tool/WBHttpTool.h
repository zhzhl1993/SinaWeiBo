//
//  WBHttpTool.h
//  微博
//
//  Created by 朱占龙 on 2016/11/16.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface WBHttpTool : NSObject

+ (void)get:(NSString *)url Params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
+ (void)post:(NSString *)url Params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end
