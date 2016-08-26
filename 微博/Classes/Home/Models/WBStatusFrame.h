//
//  WBStatusFrame.h
//  微博
//
//  Created by 朱占龙 on 16/8/21.
//  Copyright © 2016年 cuit. All rights reserved.
//  一个WBStatusFrame里面内容：
//  1.存放着一个cell里面所有子控件的frame
//  2.存放一个cell的高度
//  3.存放一个数据模型

#import <Foundation/Foundation.h>

// 昵称字体
#define WBStatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define WBStatusCellTimeFont [UIFont systemFontOfSize:13]
// 来源字体
#define WBStatusCellSourceFont WBStatusCellTimeFont
// 正文字体
#define WBStatusCellContentFont [UIFont systemFontOfSize:15]

@class WBStatus;

@interface WBStatusFrame : NSObject

/** 数据模型 */
@property(nonatomic, strong) WBStatus *status;
/** 原创微博整体视图 */
@property(nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property(nonatomic, assign) CGRect iconViewF;
/** 配图 */
@property(nonatomic, assign) CGRect photoViewF;
/** 会员图标 */
@property(nonatomic, assign) CGRect vipViewF;
/** 昵称 */
@property(nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property(nonatomic, assign) CGRect timeLabelF;
/** 来源 */
@property(nonatomic, assign) CGRect sourceLabelF;
/** 内容 */
@property(nonatomic, assign) CGRect contentLabelF;
/** cell的高度 */
@property(nonatomic, assign) CGFloat cellHeight;
@end
