//
//  WBIconView.m
//  微博
//
//  Created by 朱占龙 on 16/9/25.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBIconView.h"
#import "WBUser.h"
#import "UIImageView+WebCache.h"

@interface WBIconView()
@property(nonatomic, weak) UIImageView *verifiedView;
@end
@implementation WBIconView
- (UIImageView *)verifiedView{
    if (!_verifiedView) {
        UIImageView *verifView = [[UIImageView alloc] init];
        self.verifiedView = verifView;
        [self addSubview:verifView];
    }
    return _verifiedView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setUser:(WBUser *)user{
    _user = user;
    
    //1.设置头像图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    //2.设置加V图片
    switch (user.verified_type) {
        case WBUserVerifiedPersonal: // 个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
        case WBUserVerifiedOrgEnterprice:// 企业官方：CSDN、EOE、搜狐新闻客户端
        case WBUserVerifiedOrgMedia:
        case WBUserVerifiedOrgWebsite:
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case WBUserVerifiedDaren:// 微博达人
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            self.verifiedView.hidden = YES;
            break;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.verifiedView.size = self.verifiedView.image.size;
    CGFloat scale = 0.6;
    self.verifiedView.x = self.width - self.verifiedView.width * scale;
    self.verifiedView.y = self.height - self.verifiedView.height * scale;
    
}
@end
