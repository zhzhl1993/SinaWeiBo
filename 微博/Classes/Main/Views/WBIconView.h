//
//  WBIconView.h
//  微博
//
//  Created by 朱占龙 on 16/9/25.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBUser;

@interface WBIconView : UIImageView

@property(nonatomic, strong) WBUser *user;
@end
