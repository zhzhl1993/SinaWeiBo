//
//  PlaceHolderTextView.h
//  微博
//
//  Created by 朱占龙 on 2016/10/30.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHolderTextView : UITextView

/** 占位文字 */
@property(nonatomic, copy) NSString *placeHolder;
/** 占位文字颜色 */
@property(nonatomic, strong) UIColor *placeHolderColor;
@end
