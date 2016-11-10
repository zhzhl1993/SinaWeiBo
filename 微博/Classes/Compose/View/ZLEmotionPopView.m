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

- (void)showFrom:(ZLEmotionButton *)emotionBtn{
    
    if (emotionBtn == nil) return;
    //给popView传数据
    self.emotionBtn.emotion = emotionBtn.emotion;
    
    //取出最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    //    [btn.superview convertRect:btn.frame toView:window];
    //计算出被点击的按钮在window中的位置
    CGRect btnFrame = [emotionBtn convertRect:emotionBtn.bounds toView:nil];
    //设置位置
    self.centerY = CGRectGetMidY(btnFrame) - self.height;
    self.centerX = CGRectGetMidX(btnFrame);
}
@end
