//
//  WBTitleButton.m
//  微博
//
//  Created by 朱占龙 on 16/8/13.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBTitleButton.h"

/**按钮文字和图片之间的距离*/
#define WBMargin 10

@implementation WBTitleButton

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState: UIControlStateSelected];
    }
    return self;
}


//想要在系统设置完后再设置完尺寸后，再设置下尺寸
/**
 *  设置setFrame方法的目的：拦截设置按钮尺寸的过程
 *  如果想在系统设置完控件的尺寸后，再修改尺寸，而且保证修改成功的话就要在setFrame中设置
 */
- (void)setFrame:(CGRect)frame{
    
    frame.size.width += WBMargin;
    [super setFrame:frame];
}

/**
 *  如果仅仅调整按钮中titleLabel和imageView的位置，只要在layoutSubviews中设置即可
 */
- (void)layoutSubviews{
    
    [super layoutSubviews];
    //1.计算label
    self.titleLabel.x = self.imageView.x;
    //2.计算imageView
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + WBMargin;
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
