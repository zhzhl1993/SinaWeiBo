//
//  WBStatusPhotosView.h
//  微博
//
//  Created by 朱占龙 on 16/9/17.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBStatusPhotosView : UIView
@property (nonatomic, strong) NSArray *photos;

/**
 *  根据图片个数计算相册的尺寸
 */
+ (CGSize)sizeWithCount:(int)count;
@end
