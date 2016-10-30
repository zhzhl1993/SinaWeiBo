//
//  PlaceHolderTextView.m
//  微博
//
//  Created by 朱占龙 on 2016/10/30.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "PlaceHolderTextView.h"

@implementation PlaceHolderTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textTextChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//文字改变
- (void)textTextChange{
    [self setNeedsDisplay];
}

- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    [self setNeedsDisplay];
}

- (void)intersectPlaceHolderColor:(NSSet *)objects{
    _placeHolderColor = _placeHolderColor;
    [self setNeedsDisplay];
}
- (void)setText:(NSString *)text{
    [super setText:text];
    [self setNeedsDisplay];
}
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    
    if (self.hasText) return;
    //文字属性
    NSMutableDictionary *dictAttr = [NSMutableDictionary dictionary];
    dictAttr[NSFontAttributeName] = self.font;
    dictAttr[NSForegroundColorAttributeName] = self.placeHolderColor ? self.placeHolderColor :[UIColor grayColor];
    
    CGFloat x = 5;
    CGFloat width = rect.size.width - 2 * x;
    CGFloat y = 8;
    CGFloat height = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, width, height);
    [self.placeHolder drawInRect:placeholderRect withAttributes:dictAttr];
}

@end
