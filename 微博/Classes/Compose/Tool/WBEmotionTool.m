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

/**
 *  为了保证只加载一次
 */
static NSArray *_emojiEmotions, *_defaultEmotions, *_lxhEmotions;
+ (NSArray *)defaultEmotions{
    if (!_defaultEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        _defaultEmotions = [WBEmotionModel objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultEmotions;
}
+ (NSArray *)emojiEmotions{
    if (!_emojiEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        _emojiEmotions = [WBEmotionModel objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiEmotions;
}
+ (NSArray *)lxhEmotions{
    if (!_lxhEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        _lxhEmotions = [WBEmotionModel objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhEmotions;
}

+ (WBEmotionModel *)emotionWithChs:(NSString *)chs{
    
    NSArray * defaults = [self defaultEmotions];
    for (WBEmotionModel *emotion in defaults) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    
    NSArray *lxhs = [self lxhEmotions];
    for (WBEmotionModel *emotion in lxhs) {
        if ([emotion.chs isEqualToString:chs]) {
            return emotion;
        }
    }
    return nil;
}
@end
