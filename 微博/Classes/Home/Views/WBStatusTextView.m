//
//  WBStatusTextView.m
//  微博
//
//  Created by 朱占龙 on 2016/11/24.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBStatusTextView.h"
#import "WBSpecial.h"

#define WBStatusTextViewCoverTag 999

@implementation WBStatusTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        self.scrollEnabled = NO;
        self.editable = NO;
    }
    return self;
}

- (void)setupSpecialRects{
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    for (WBSpecial *special in specials) {
        self.selectedRange = special.range;
        //获得选中范围的矩形框
        NSArray *selectionRects = [self selectionRectsForRange:self.selectedTextRange];
        //清空选中范围
        self.selectedRange = NSMakeRange(0, 0);
        
        NSMutableArray *rects = [NSMutableArray array];
        for (UITextSelectionRect *selectionRect in selectionRects) {
            CGRect rect = selectionRect.rect;
            if (rect.size.width == 0 || rect.size.height == 0) continue;
            
            //添加rects
            [rects addObject:[NSValue valueWithCGRect:rect]];
        }
        special.rects = rects;
    }
}

- (WBSpecial *)touchingSpecialWithPoint:(CGPoint)point{
    NSArray *specials = [self.attributedText attribute:@"specials" atIndex:0 effectiveRange:NULL];
    for (WBSpecial *special in specials) {
        for (NSValue *rectValue in special.rects) {
            if (CGRectContainsPoint(rectValue.CGRectValue, point)) {
                return special;
            }
        }
    }
    return nil;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //找出触摸点在哪个特殊字符串上面
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //初始化矩形框
    [self setupSpecialRects];
    
    //根据触摸点获得被触摸的特殊字符串
    WBSpecial *special = [self touchingSpecialWithPoint:point];
    
    //在被触摸的特殊字符串上显示一段高亮的背景
    for (NSValue *rectValue in special.rects) {
        
        UIView *cover = [[UIView alloc] init];
        cover.backgroundColor = [UIColor greenColor];
        cover.frame = rectValue.CGRectValue;
        cover.layer.cornerRadius = 5;
        cover.tag = WBStatusTextViewCoverTag;
        [self insertSubview:cover atIndex:0];
            break;
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
    
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //去掉特殊字符串后面的高亮背景
    for (UIView *child in self.subviews) {
        if (child.tag == WBStatusTextViewCoverTag) {
            [child removeFromSuperview];
        }
    }
}
/*
 1.首先判断点在谁身上，调用- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
 2.由触摸点所在的UI控件选出处理事件的UI控件：调用- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
 */
/**
 *去掉选择复制,告诉系统触摸点point是否在这个UI控件身上
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    //初始化矩形框
    [self setupSpecialRects];
    
    //根据触摸点获得被触摸的特殊字符串
    WBSpecial *special = [self touchingSpecialWithPoint:point];
    return special ? YES : NO;
}
/**
 *  选出处理这个点的view
 */
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    
//}
@end
