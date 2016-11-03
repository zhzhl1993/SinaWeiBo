//
//  WBComposePhotosView.h
//  微博
//
//  Created by 朱占龙 on 2016/11/2.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBComposePhotosView : UIView

@property(nonatomic, strong,readonly) NSMutableArray *photos;

- (void)addPhoto:(UIImage *)image;
@end
