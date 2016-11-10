//
//  WBEmotionAttachment.m
//  微博
//
//  Created by 朱占龙 on 2016/11/10.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBEmotionAttachment.h"
#import "WBEmotionModel.h"

@implementation WBEmotionAttachment

- (void)setEmotion:(WBEmotionModel *)emotion{
    _emotion = emotion;
    
    self.image = [UIImage imageNamed:emotion.png];
}
@end
