//
//  WBEmotionTool.m
//  微博
//
//  Created by 朱占龙 on 2016/11/10.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBEmotionTool.h"
#import "WBEmotionModel.h"

//最近使用表情的存储路径
#define WBRecentEmotionPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotion.archive"]

static NSMutableArray *_recentEmotions;

@implementation WBEmotionTool

+ (void)initialize{
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:WBRecentEmotionPath];
    if (!_recentEmotions) {
        _recentEmotions = [NSMutableArray array];
    }
}

+(void)addEmotion:(WBEmotionModel *)emotion{

    //删除重复的表情
    [_recentEmotions removeObject:emotion];
    
    //将表情放到数组的最前面
    [_recentEmotions insertObject:emotion atIndex:0];
    
    //将所有的表情写入沙盒
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:WBRecentEmotionPath];
}

/*
 *  返回装着emotion模型的数组
 */
+ (NSArray *)recentEmotions{
    return _recentEmotions;
}
@end
