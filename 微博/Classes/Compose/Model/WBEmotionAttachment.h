//
//  WBEmotionAttachment.h
//  微博
//
//  Created by 朱占龙 on 2016/11/10.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBEmotionModel;

@interface WBEmotionAttachment : NSTextAttachment
/** 模型 */
@property(nonatomic, strong) WBEmotionModel *emotion;
@end
