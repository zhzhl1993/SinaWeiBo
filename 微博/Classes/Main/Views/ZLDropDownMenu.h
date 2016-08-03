//
//  ZLDropDownMenu.h
//  微博
//
//  Created by 朱占龙 on 16/7/13.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLDropDownMenu;

@protocol ZLDropDownMenuDelegate <NSObject>

@optional
- (void)dropDownMenuDidShow: (ZLDropDownMenu *)menu;
- (void)dropDownMenuDidDismiss: (ZLDropDownMenu *)menu;
@end

@interface ZLDropDownMenu : UIView

+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;
@property (nonatomic, assign) id<ZLDropDownMenuDelegate> delegate;
@end
