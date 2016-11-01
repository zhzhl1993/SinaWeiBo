//
//  WBComposeToolBar.h
//  微博
//
//  Created by 朱占龙 on 2016/10/31.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBComposeToolBar;

typedef enum{
    WBComposeToolBarButtonCamera,//拍照
    WBComposeToolBarButtonPicture,//相册
    WBComposeToolBarButtonMention,//@
    WBComposeToolBarButtonTrend,//#
    WBComposeToolBarButtonEmotion,//表情
}WBComposeToolBarButtonType;

@protocol WBComposeToolBarDelegate <NSObject>
@optional
- (void)composeToolBar:(WBComposeToolBar *)toolbar didClickButton:(WBComposeToolBarButtonType)buttonType;
@end

@interface WBComposeToolBar : UIView
@property(nonatomic, weak) id<WBComposeToolBarDelegate> delegate;
@end
