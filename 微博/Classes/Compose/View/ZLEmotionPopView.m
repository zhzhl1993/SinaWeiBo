//
//  ZLEmotionPopView.m
//  微博
//
//  Created by 朱占龙 on 2016/11/7.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "ZLEmotionPopView.h"
#import "WBEmotionModel.h"
#import "ZLEmotionButton.h"

@interface ZLEmotionPopView()

@property (weak, nonatomic) IBOutlet ZLEmotionButton *emotionBtn;

@end
@implementation ZLEmotionPopView

+ (instancetype)popView{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZLEmotionPopView" owner:nil options:nil] lastObject];
}

- (void)setEmotion:(WBEmotionModel *)emotion{
    _emotion = emotion;
    
    self.emotionBtn.emotions = emotion;
}
@end
