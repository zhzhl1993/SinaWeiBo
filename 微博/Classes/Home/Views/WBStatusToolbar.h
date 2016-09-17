//
//  WBStatusToolbar.h
//  微博
//
//  Created by 朱占龙 on 16/9/5.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBStatus;

@interface WBStatusToolbar : UIView
@property(nonatomic, strong) WBStatus *status;

+ (instancetype)toolbar;
@end
