//
//  WBEmotionTextView.h
//  微博
//
//  Created by 朱占龙 on 2016/11/7.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "PlaceHolderTextView.h"
@class WBEmotionModel;

@interface WBEmotionTextView : PlaceHolderTextView

- (void)insertEmotion:(WBEmotionModel *)emotion;
@end
