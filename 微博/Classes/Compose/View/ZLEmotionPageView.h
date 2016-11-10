//
//  ZLEmotionPageView.h
//  微博
//
//  Created by 朱占龙 on 2016/11/6.
//  Copyright © 2016年 cuit. All rights reserved.
//  每一页的表情

#import <UIKit/UIKit.h>

/** 每一页最大列数 */
#define ZLEmotionMaxCols 7
/** 每一页最大行数 */
#define ZLEmotionMaxRows 3
/** 每一页显示的最多个数 */
#define ZLEmotionPerPageNum ((ZLEmotionMaxCols * ZLEmotionMaxRows) - 1)

@interface ZLEmotionPageView : UIView

/** 存放emotions模型 */
@property(nonatomic, strong) NSArray *emotions;
@end
