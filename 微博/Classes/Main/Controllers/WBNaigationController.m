//
//  WBNaigationController.m
//  微博
//
//  Created by 朱占龙 on 16/7/9.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBNaigationController.h"
#import "UIBarButtonItem+Extension.h"

@interface WBNaigationController ()

@end

@implementation WBNaigationController

+ (void)initialize{
    
    //取得所有的item
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    //普通状态下所有显示
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13.0];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    //禁止状态下
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9];
    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13.0];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count > 0) {
        
        //自动隐藏和现实导航栏上的tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        /*设置导航栏左边返回按钮*/
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action: @selector(back) image:@"navigationbar_back" highImage: @"navigationbar_back_highlighted"];
        
        /*设置导航栏右边更多按钮*/
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
    }
    
    [super pushViewController:viewController animated:YES];
}

- (void)back{
    
    [self popViewControllerAnimated:YES];
}

- (void)more{
    [self popToRootViewControllerAnimated:YES];
}
@end
