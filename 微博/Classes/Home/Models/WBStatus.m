//
//  WBStatus.m
//  微博
//
//  Created by 朱占龙 on 16/8/13.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBStatus.h"
#import "WBUser.h"
#import "WBPhotoModel.h"
#import "MJExtension.h"

@implementation WBStatus

- (NSDictionary *)objectClassInArray{
    return @{@"pic_urls": [WBPhotoModel class]};
}

@end
