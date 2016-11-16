//
//  WBHttpTool.m
//  微博
//
//  Created by 朱占龙 on 2016/11/16.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBHttpTool.h"
#import "AFNetworking.h"

@implementation WBHttpTool

+ (void)get:(NSString *)url Params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    //1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.发送请求
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url Params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    //1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.发送请求
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failure(error);
        }
    }];
}
@end
