//
//  WBEmotionTool.h
//  微博
//
//  Created by 朱占龙 on 2016/11/10.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WBEmotionModel;

@interface WBEmotionTool : NSObject

+ (void)addEmotion:(WBEmotionModel *)emotion;

+ (NSArray *)recentEmotions;
+ (NSArray *)defaultEmotions;
+ (NSArray *)emojiEmotions;
+ (NSArray *)lxhEmotions;

/**
 *  通过表情描述找到对应的表情
 */
+ (WBEmotionModel *)emotionWithChs:(NSString *)chs;

@end
