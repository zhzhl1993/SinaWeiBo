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
#import "WBEmotionTool.h"

@interface ZLEmotionPageView()
/** 表情放大镜 */
@property(nonatomic, strong) ZLEmotionPopView *popView;
/** 删除按钮 */
@property(nonatomic, weak) UIButton *deleteBtn;
@end

@implementation ZLEmotionPageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteBtn setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
        
        //添加手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

/**
 *  处理长按手势
 */
- (void)longPress:(UILongPressGestureRecognizer *)longPress{
    
    CGPoint location = [longPress locationInView:longPress.view];
    ZLEmotionButton *btn = [self emotionBtnWithLocation:location];
    
    switch (longPress.state) {
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{//结束或者取消
            //移除浮动视图
            [self.popView removeFromSuperview];
            //如果手指还在按钮上，表情按钮发通知
            //发送通知
            if (btn) {
                [self selectedEmotion:btn.emotion];
            }
            break;
        }
        case UIGestureRecognizerStateBegan://开始
        case UIGestureRecognizerStateChanged:{//手势改变
            
            [self.popView showFrom:btn];
            break;
        }
        default:
            break;
    }
}
- (ZLEmotionButton *)emotionBtnWithLocation:(CGPoint)location{
    NSUInteger count = self.emotions.count;
    for (int i = 0; i < count; i++) {
        ZLEmotionButton *btn = self.subviews[i];
        if (CGRectContainsPoint(btn.frame, location)) {
            return btn;
        }
    }
    return nil;
}
/**
 *  表情按钮的删除
 */
- (void)deleteClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:emotionDeleteNotification object:nil];
}
/**
  *  表情按钮的点击
  */
- (void)btnClick:(ZLEmotionButton *)btn{
    
    //显示popView
    [self.popView showFrom:btn];
    
    //等待一段时间后自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.popView removeFromSuperview];
    });
    
    //发送通知
    [self selectedEmotion:btn.emotion];
}
/*
 *  发送通知
 */
- (void)selectedEmotion:(WBEmotionModel *)emotion{
    //将这个表情存进沙盒
    [WBEmotionTool addEmotion:emotion];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[emotionSelectKey] = emotion;
    [[NSNotificationCenter defaultCenter] postNotificationName:emotionSelectNotification object:nil userInfo:userInfo];
}
#pragma mark - 懒加载
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
        btn.emotion = emotions[i];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat inset = 10;
    CGFloat btnW = (self.width - inset) / ZLEmotionMaxCols;
    CGFloat btnH = (self.height - inset) /ZLEmotionMaxRows;
    NSUInteger count = self.emotions.count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i + 1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i % 7) * btnW;
        btn.y = inset + (i / 7) * btnH;
    }
    
    //删除按钮
    self.deleteBtn.width = btnW;
    self.deleteBtn.height = btnH;
    self.deleteBtn.y = self.height - self.deleteBtn.height;
    self.deleteBtn.x = self.width - inset - self.deleteBtn.width;
}


@end
