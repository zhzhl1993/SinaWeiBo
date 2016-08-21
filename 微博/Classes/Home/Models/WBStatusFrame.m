//
//  WBStatusFrame.m
//  微博
//
//  Created by 朱占龙 on 16/8/21.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBStatusFrame.h"
#import "WBStatus.h"
#import "WBUser.h"

/** cell的边界宽度 */
#define WBStatusCellBorderW 10

@implementation WBStatusFrame

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    return [text sizeWithAttributes:attrs];
}

- (void)setStatus:(WBStatus *)status{
    
    _status = status;
    
    WBUser *user = status.user;

    /** 头像 */

    CGFloat iconX = WBStatusCellBorderW;
    CGFloat iconY = WBStatusCellBorderW;
    CGFloat iconWH = 50;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + WBStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [self sizeWithText:user.name font:WBStatusCellFont];
    self.nameLabelF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    /** 会员图标 */
    if (status.user.isvip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + WBStatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /** 配图 */
    
   
    
    
    /** 时间 */
    
    /** 来源 */
    
    /** 内容 */
    
    /** 原创微博整体视图 */
    
    /** cell的高度 */
    self.cellHeight = 80;
}
@end
