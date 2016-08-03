//
//  UIBarButtonItem+Extension.h
//  微博
//
//  Created by 朱占龙 on 16/7/9.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTarget: (id)target action: (SEL)action image: (NSString *)image highImage: (NSString *) highImage;
@end
