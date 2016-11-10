//
//  WBEmotionTool.m
//  微博
//
//  Created by 朱占龙 on 2016/11/10.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBEmotionTool.h"

//最近使用表情的存储路径
#define WBRecentEmotionPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotion.archive"]

@implementation WBEmotionTool

+(void)addEmotion:(WBEmotionModel *)emotion{
    NSMutableArray *emotions = (NSMutableArray *)[self recentEmotions];
    if (emotions == nil) {
        emotions = [NSMutableArray array];
    }
    [emotions insertObject:emotion atIndex:0];
    
    [NSKeyedArchiver archiveRootObject:emotions toFile:WBRecentEmotionPath];
}

/*
 *  返回装着emotion模型的数组
 */
+ (NSArray *)recentEmotions{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:WBRecentEmotionPath];
}
@end
