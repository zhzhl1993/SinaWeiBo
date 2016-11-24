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
#import "RegexKitLite.h"
#import "WBTextPart.h"
#import "WBEmotionTool.h"
#import "WBEmotionModel.h"

@implementation WBStatus

- (NSDictionary *)objectClassInArray{
    return @{@"pic_urls": [WBPhotoModel class]};
}

- (NSAttributedString *)attributeTextWithText:(NSString *)text{
    //利用text生成attributeText
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] init];
    //表情规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    //@规则
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
    //话题规则
    NSString *topicPattern = @"#[0-9a-zA-Z]+#";
    //链接规则
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@",emotionPattern, atPattern, topicPattern,urlPattern];
    //便利所有的特殊字符串
    NSMutableArray *parts = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if ((*capturedRanges).length == 0) return ;
        
        WBTextPart *part = [[WBTextPart alloc] init];
        part.special = YES;
        part.text = *capturedStrings;
        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    //便利所有的非特殊字符串
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if ((*capturedRanges).length == 0) return ;
        
        WBTextPart *part = [[WBTextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    //排序
    //系统默认是按照从小到大的顺序排列的
    [parts sortedArrayUsingComparator:^NSComparisonResult(WBTextPart *part1, WBTextPart *part2) {
        //如果位置1大于位置2
        if (part1.range.location > part2.range.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];

    UIFont *font = [UIFont systemFontOfSize:15];
    //拼接文字
    for (WBTextPart *part in parts) {
        NSAttributedString *subStr = nil;
        if (part.isEmotion) {//表情
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            NSString *name = [WBEmotionTool emotionWithChs:part.text].png;
            attach.image = [UIImage imageNamed:name];
            attach.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight) ;
            subStr = [NSAttributedString attributedStringWithAttachment:attach];
        }else if(part.special){//特殊文字
            subStr = [[NSAttributedString alloc] initWithString:part.text attributes:@{
                NSForegroundColorAttributeName:[UIColor redColor]
                                                                        }];
        }else{//普通文字
            subStr = [[NSAttributedString alloc] initWithString:part.text];
        }
        [attributeText appendAttributedString:subStr];
    }
    //一定要设置字体，保证计算出来的尺寸是正确的
    [attributeText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributeText.length)];
    return attributeText;
}
- (void)setText:(NSString *)text{
    _text = text;
    
    self.attributeText = [self attributeTextWithText:text];
}

- (void)setRetweeted_status:(WBStatus *)retweeted_status{
    _retweeted_status = retweeted_status;
    NSString *retweetContent = [NSString stringWithFormat:@"@%@:%@",retweeted_status.user.name, retweeted_status.text];
    self.retweeted_statusAttributeText = [self attributeTextWithText:retweetContent];
}
/**
 1.今年
 1> 今天
 * 1分内： 刚刚
 * 1分~59分内：xx分钟前
 * 大于60分钟：xx小时前
 
 2> 昨天
 * 昨天 xx:xx
 
 3> 其他
 * xx-xx xx:xx
 
 2.非今年
 1> xxxx-xx-xx xx:xx
 */
- (NSString *)created_at
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    // 设置日期格式（声明字符串里面每个数字和单词的含义）
    // E:星期几
    // M:月份
    // d:几号(这个月的第几天)
    // H:24小时制的小时
    // m:分钟
    // s:秒
    // y:年
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    //    _created_at = @"Tue Sep 30 17:06:25 +0800 2014";
    
    // 微博的创建日期
    NSDate *createDate = [fmt dateFromString:_created_at];
    // 当前时间
    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if ([createDate isThisYear]) { // 今年
        if ([createDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else if ([createDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年的其他日子
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}

/**
 *  只要重写一次即可，不需要实时更新，故用set方法
 */
- (void)setSource:(NSString *)source{
    if (source.length) {
        NSRange range;
        range.location = [source rangeOfString:@">"].location + 1;
        range.length = [source rangeOfString:@"</"].location - range.location;
        _source = [NSString stringWithFormat:@"来自%@",[source substringWithRange:range]];
    }else{
        _source = source;
    }
}
@end
