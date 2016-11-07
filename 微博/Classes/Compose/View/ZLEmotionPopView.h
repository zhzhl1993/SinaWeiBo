//
//  ZLEmotionPopView.h
//  微博
//
//  Created by 朱占龙 on 2016/11/7.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBEmotionModel;

@interface ZLEmotionPopView : UIView
@property(nonatomic, strong) WBEmotionModel *emotion;

+ (instancetype)popView;
@end
