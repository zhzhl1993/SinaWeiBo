//
//  ZLEmotionPageView.m
//  微博
//
//  Created by 朱占龙 on 2016/11/6.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "ZLEmotionPageView.h"
#import "WBEmotionModel.h"
#import "ZLEmotionPopView.h"
#import "ZLEmotionButton.h"

@interface ZLEmotionPageView()
/** 表情放大镜 */
@property(nonatomic, strong) ZLEmotionPopView *popView;
@end

@implementation ZLEmotionPageView
- (ZLEmotionPopView *)popView{
    if (!_popView) {
        _popView = [ZLEmotionPopView popView];
    }
    return _popView;
}

- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    for (int i = 0; i < count; i++) {
        ZLEmotionButton *btn = [[ZLEmotionButton alloc] init];
        [self addSubview:btn];
        btn.emotions = emotions[i];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat inset = 10;
    CGFloat btnW = (self.width - inset) / ZLEmotionMaxCols;
    CGFloat btnH = (self.height - inset) /ZLEmotionMaxRows;
    NSUInteger count = self.subviews.count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = (UIButton *)self.subviews[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i % 7) * btnW;
        btn.y = inset + (i / 7) * btnH;
    }
}

/** 表情按钮的点击 */
- (void)btnClick:(ZLEmotionButton *)btn{
    //给popView传数据
    self.popView.emotion = btn.emotions;
    
    //取出最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self.popView];
//    [btn.superview convertRect:btn.frame toView:window];
    //计算出被点击的按钮在window中的位置
    CGRect btnFrame = [btn convertRect:btn.bounds toView:nil];
    //设置位置
    self.popView.centerY = CGRectGetMidY(btnFrame) - self.popView.height;
    self.popView.centerX = CGRectGetMidX(btnFrame);
    
    //等待一段时间后自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.popView removeFromSuperview];
    });
    
    //发送通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[emotionSelectKey] = btn.emotions;
    [[NSNotificationCenter defaultCenter] postNotificationName:emotionSelectNotification object:nil userInfo:userInfo];
}
@end
