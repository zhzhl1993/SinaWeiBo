//
//  WBStatusPhotosView.m
//  微博
//
//  Created by 朱占龙 on 16/9/17.
//  Copyright © 2016年 cuit. All rights reserved.
//
/**
 *  微博相册的配图，里面可能会有多张图片
 */
#import "WBStatusPhotosView.h"
#import "WBStatusPhotoView.h"

#define WBStatusPhotoWH 70
#define WBStatusPhotoMargin 10
#define WBStatusPhotoMaxCol(count) ((count==4)?2:3)

@implementation WBStatusPhotosView // 9

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    int photosCount = photos.count;
    
    
    // 创建足够数量的图片控件
    // 这里的self.subviews.count不要单独赋值给其他变量
    while (self.subviews.count < photosCount) {
        WBStatusPhotoView *photoView = [[WBStatusPhotoView alloc] init];
        [self addSubview:photoView];
    }
    
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        WBStatusPhotoView *photoView = self.subviews[i];
        
        if (i < photosCount) { // 显示
            photoView.photo = photos[i];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    int photosCount = self.photos.count;
    int maxCol = WBStatusPhotoMaxCol(photosCount);
    for (int i = 0; i<photosCount; i++) {
        WBStatusPhotoView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (WBStatusPhotoWH + WBStatusPhotoMargin);
        
        int row = i / maxCol;
        photoView.y = row * (WBStatusPhotoWH + WBStatusPhotoMargin);
        photoView.width = WBStatusPhotoWH;
        photoView.height = WBStatusPhotoWH;
    }
}

+ (CGSize)sizeWithCount:(int)count
{
    // 最大列数（一行最多有多少列）
    int maxCols = WBStatusPhotoMaxCol(count);
    
    ///Users/apple/Desktop/课堂共享/05-iPhone项目/1018/代码/黑马微博2期35-相册/黑马微博2期/Classes/Home(首页)/View/HWStatusPhotosView.m 列数
    int cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * WBStatusPhotoWH + (cols - 1) * WBStatusPhotoMargin;
    
    // 行数
    int rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * WBStatusPhotoWH + (rows - 1) * WBStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}


@end
