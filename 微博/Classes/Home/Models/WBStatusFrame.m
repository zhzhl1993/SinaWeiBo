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
#import "WBStatusPhotosView.h"

@implementation WBStatusFrame

- (CGSize)photosSizeWithCount:(NSInteger)count{
    return CGSizeMake(100, 50);
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
    CGSize nameSize = [user.name sizeWithFont:WBStatusCellNameFont];
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
    CGSize timeSize = [status.created_at sizeWithFont:WBStatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + WBStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:WBStatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + WBStatusCellBorderW;
    CGFloat maxW = [UIScreen mainScreen].bounds.size.width - 2 * WBStatusCellBorderW;
    CGSize contentSize = [status.text sizeWithFont:WBStatusCellContentFont MaxWidth:maxW];
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    /** 配图 */
    CGFloat originH = 0;
    if (status.pic_urls.count) {//有配图
        CGFloat photosX = contentX;
        CGFloat photosY = CGRectGetMaxY(self.contentLabelF) + WBStatusCellBorderW;
        CGSize photosSize = [WBStatusPhotosView sizeWithCount:status.pic_urls.count];
        self.photosViewF = (CGRect){{photosX, photosY}, photosSize};
        originH = CGRectGetMaxY(self.photosViewF) + WBStatusCellBorderW;
    }else{//没有配图
      originH = CGRectGetMaxY(self.contentLabelF) + WBStatusCellBorderW;
    }
    //18394036039
    /** 原创微博整体视图 */
    CGFloat originX = 0;
    CGFloat originY = WBCellSpaceW;
    CGFloat originW = [UIScreen mainScreen].bounds.size.width;
    
    self.originalViewF = CGRectMake(originX, originY, originW, originH);
    
    /** 被转发微博 */
    WBStatus *retweeted_status = status.retweeted_status;
    WBUser *retweeted_status_user = status.user;
    CGFloat toolViewY = 0;
    if (status.retweeted_status) {
        /** 被转发微博内容 */
        NSString *retweetContent = [NSString stringWithFormat:@"@%@:%@", retweeted_status_user.name, retweeted_status.text];
        CGFloat retweetContentX = WBStatusCellBorderW;
        CGFloat retweetContentY = WBStatusCellBorderW;
        CGSize retweetContentSize = [retweetContent sizeWithFont:WBretweetContentFont MaxWidth:maxW];
        self.retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};
        
        /** 被转发微博配图 */
        CGFloat retweetViewH = 0;
        if (retweeted_status.pic_urls.count) {//被转发微博有配图
            CGFloat retweetPhotosX = retweetContentX;
            CGFloat retweetPhotosY = CGRectGetMaxY(self.retweetContentLabelF) + WBStatusCellBorderW;
            CGSize retweetSize = [WBStatusPhotosView sizeWithCount:retweeted_status.pic_urls.count];
            self.retweetPhotosViewF = (CGRect){{retweetPhotosX, retweetPhotosY}, retweetSize};
            retweetViewH = CGRectGetMaxY(self.retweetPhotosViewF) + WBStatusCellBorderW;
        }else{//被转发微博没有配图
        
            retweetViewH = CGRectGetMaxY(self.contentLabelF) + WBStatusCellBorderW;
        }
         /** 被转发微博整体 */
        CGFloat retweetViewX = 0;
        CGFloat retweetViewY = CGRectGetMaxY(self.originalViewF);
        CGFloat retweetViewW = screenWidth;
        self.retweetViewF = CGRectMake(retweetViewX, retweetViewY, retweetViewW, retweetViewH);
        toolViewY = CGRectGetMaxY(self.retweetViewF);
    }else{
        toolViewY = CGRectGetMaxY(self.originalViewF) + 1;
    }
    CGFloat toolViewX = 0;
    CGFloat toolViewW = screenWidth;
    CGFloat toolViewH = 35;
    self.toolViewF = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
    
    /** cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.toolViewF);
}
@end
