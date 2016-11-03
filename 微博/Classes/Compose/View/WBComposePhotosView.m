//
//  WBComposePhotosView.m
//  微博
//
//  Created by 朱占龙 on 2016/11/2.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBComposePhotosView.h"

@implementation WBComposePhotosView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _photos = [NSMutableArray array];
    }
    return self;
}

- (void)addPhoto:(UIImage *)image{
    UIImageView *photo = [[UIImageView alloc] init];
    photo.image = image;
    [_photos addObject:photo.image];
    [self addSubview:photo];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger count = self.subviews.count;
    int maxCol = 4;
    CGFloat photoWH = 70;
    CGFloat photoMargin = (screenWidth - photoWH * maxCol) / (maxCol + 1);
    CGFloat verticalMargin = 5;
    for (int i = 0; i<count; i++){
        UIImageView  *photoView = self.subviews[i];
        int col = i % maxCol;
        photoView.x = photoMargin + col * (photoWH + photoMargin);
        int row = i / maxCol;
        photoView.y = verticalMargin + row * (photoWH + verticalMargin);
        photoView.width = photoWH;
        photoView.height = photoWH;
    }
}
@end
