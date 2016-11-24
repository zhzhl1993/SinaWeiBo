//
//  WBStatusTextView.h
//  微博
//
//  Created by 朱占龙 on 2016/11/24.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBStatusTextView : UITextView

/** 所有特殊字符串（存放WBSpecial字符串） */
@property(nonatomic, strong) NSArray *spcials;
@end
