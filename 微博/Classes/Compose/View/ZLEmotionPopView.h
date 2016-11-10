//
//  ZLEmotionPopView.h
//  微博
//
//  Created by 朱占龙 on 2016/11/7.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBEmotionModel,ZLEmotionButton;

@interface ZLEmotionPopView : UIView

+ (instancetype)popView;
- (void)showFrom:(ZLEmotionButton *)emotionBtn;
@end
