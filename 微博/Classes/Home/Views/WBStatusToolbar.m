//
//  WBStatusToolbar.m
//  微博
//
//  Created by 朱占龙 on 16/9/5.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBStatusToolbar.h"
#import "WBStatus.h"

@interface WBStatusToolbar()
/** 评论按钮 */
@property(nonatomic, weak) UIButton *commentBtn;
/** 转发按钮 */
@property(nonatomic, weak) UIButton *retweetBtn;
/** 点赞按钮 */
@property(nonatomic, weak) UIButton *attitudeBtn;

@end
@implementation WBStatusToolbar


+ (instancetype)toolbar{
    
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.retweetBtn = [self setupBtnWith:@"转发" icon:@"timeline_icon_retweet"];
        self.commentBtn = [self setupBtnWith:@"评论" icon:@"timeline_icon_comment"];
        self.attitudeBtn = [self setupBtnWith:@"点赞" icon:@"timeline_icon_unlike"];
    }
    return self;
}
/**
 *  初始化一个按钮
 *
 *  @param title 标题
 *  @param icon  图片
 */
- (UIButton *)setupBtnWith:(NSString *)title icon:(NSString *)icon{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    
    return btn;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (int i = 0; i < self.subviews.count; i++) {
        UIButton *btn = self.subviews[i];
        btn.x = i * btnW;
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
        
    }
}

- (void)setStatus:(WBStatus *)status{
    _status = status;
    //转发
    [self setupBtnCount:status.reposts_count title:@"转发" button:self.retweetBtn];
    //评论
    [self setupBtnCount:status.comments_count title:@"评论" button:self.commentBtn];
    //赞
    [self setupBtnCount:status.attitudes_count title:@"赞" button:self.attitudeBtn];
}

/**
 *  根据传入的文字设置按钮标题
 */
- (void)setupBtnCount:(int)count title:(NSString *)title button:(UIButton *)btn{
    if (count) {//数字不为0
        /*
         1.不足10000，显示数字
         2.大于10000，显示万
         */
        if (count < 10000) {
            title = [NSString stringWithFormat:@"%ld",(long)count];
        }else{
            CGFloat wan = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万",wan];
            //去掉.0
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
    }
    [btn setTitle:title forState:UIControlStateNormal];
}
@end
