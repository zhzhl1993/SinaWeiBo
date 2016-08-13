//
//  WBTitleButton.m
//  微博
//
//  Created by 朱占龙 on 16/8/13.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBTitleButton.h"

@implementation WBTitleButton

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState: UIControlStateSelected];
        self.imageView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/**
 *  如果仅仅调整按钮中titleLabel和imageView的位置，只要在layoutSubviews中设置即可
 */
- (void)layoutSubviews{
    
    [super layoutSubviews];
    //1.计算label
    self.titleLabel.x = self.imageView.x;
    //2.计算imageView
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 10;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    
    [super setTitle:title forState:state];
    [self sizeToFit];
    
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    
    [super setImage:image forState:state];
    [self sizeToFit];
}
@end
