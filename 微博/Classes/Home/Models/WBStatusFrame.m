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

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font MaxWidth:(CGFloat)MaxWidth{
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    return [text boundingRectWithSize:CGSizeMake(MaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font{
    
    return [self sizeWithText:text font:font MaxWidth:MAXFLOAT];
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
    CGSize nameSize = [self sizeWithText:user.name font:WBStatusCellNameFont];
    self.nameLabelF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    /** 会员图标 */
    if (user.isvip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + WBStatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /** 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + WBStatusCellBorderW;
    CGSize timeSize = [self sizeWithText:status.created_at font:WBStatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + WBStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [self sizeWithText:status.source font:WBStatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + WBStatusCellBorderW;
    CGFloat maxW = [UIScreen mainScreen].bounds.size.width - 2 * WBStatusCellBorderW;
    CGSize contentSize = [self sizeWithText:status.text font:WBStatusCellContentFont MaxWidth:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    /** 配图 */
    CGFloat originH = 0;
    if (status.pic_urls.count) {//有配图
        CGFloat photoWH = 100;
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelF) + WBStatusCellBorderW;
        self.photoViewF = CGRectMake(photoX, photoY, photoWH, photoWH);
        originH = CGRectGetMaxY(self.photoViewF) + WBStatusCellBorderW;
    }else{//没有配图
      originH = CGRectGetMaxY(self.contentLabelF) + WBStatusCellBorderW;
    }
    
    /** 原创微博整体视图 */
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat originW = [UIScreen mainScreen].bounds.size.width;
    
    self.originalViewF = CGRectMake(originX, originY, originW, originH);
    
    /** cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.originalViewF);
}
@end
