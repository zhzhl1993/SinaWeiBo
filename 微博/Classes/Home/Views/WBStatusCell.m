//
//  WBStatusCell.m
//  微博
//
//  Created by 朱占龙 on 16/8/21.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBStatusCell.h"
#import "WBStatusFrame.h"
#import "WBStatus.h"
#import "WBUser.h"
#import "UIImageView+WebCache.h"
#import "WBPhotoModel.h"
#import "WBStatusToolbar.h"

@interface WBStatusCell()

/** 原创微博*/
/** 原创微博整体视图 */
@property(nonatomic, weak) UIView *originalView;
/** 头像 */
@property(nonatomic, weak) UIImageView *iconView;
/** 配图 */
@property(nonatomic, weak) UIImageView *photoView;
/** 会员图标 */
@property(nonatomic, weak) UIImageView *vipView;
/** 昵称 */
@property(nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property(nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property(nonatomic, weak) UILabel *sourceLabel;
/** 内容 */
@property(nonatomic, weak) UILabel *contentLabel;

/** 转发微博 */
/** 转发微博整体 */
@property(nonatomic, weak) UIView *retweetView;
/** 转发微博正文 + 昵称 */
@property(nonatomic, weak) UILabel *retweetContentLabel;
/** 转发配图 */
@property(nonatomic, weak) UIImageView *retweetPhotoView;

/** 工具条 */
/** 工具条整体视图 */
@property(nonatomic, weak) WBStatusToolbar *toolView;
@end

@implementation WBStatusCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"cell";
    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WBStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

/**
 *  cell的初始化设置，一个cell只会调用一次
 *  一般在这里添加所有子控件，以及子控件的一次性设置
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //选中样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /** 原创微博 */
        [self initOriginView];
        
        /** 转发微博 */
        [self initRetweetView];
        
        /** 创建toolbar */
        [self setupToolBar];
    }
    return self;
}

/** 创建toolbar */
- (void)setupToolBar{
    
    /** 工具条 */
    WBStatusToolbar *toolView = [WBStatusToolbar toolbar];
    [self.contentView addSubview:toolView];
    self.toolView = toolView;
}
/**
 *  转发微博
 */
- (void)initRetweetView{
    /** 转发微博整体 */
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = YYColor(247, 247, 247);
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博正文 + 昵称 */
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    retweetContentLabel.numberOfLines = 0;
    retweetContentLabel.font = WBretweetContentFont;
    [retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    /** 转发配图 */
    UIImageView *retweetPhotoView = [[UIImageView alloc] init];
    [retweetView addSubview:retweetPhotoView];
    self.retweetPhotoView = retweetPhotoView;

}
/**
 *  原创微博
 */
- (void)initOriginView{
    /** 原创微博整体视图 */
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    /** 头像 */
    UIImageView *iconView = [[UIImageView alloc] init];
    [originalView addSubview:iconView];
    self.iconView = iconView;
    
    /** 配图 */
    UIImageView *photoView = [[UIImageView alloc] init];
    [originalView addSubview:photoView];
    self.photoView = photoView;
    
    /** 会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [originalView addSubview:vipView];
    self.vipView = vipView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    [originalView addSubview:nameLabel];
    nameLabel.font = WBStatusCellNameFont;
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = WBStatusCellTimeFont;
    [originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = WBStatusCellSourceFont;
    [originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 内容 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = WBStatusCellContentFont;
    contentLabel.numberOfLines  = 0;
    [originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

- (void)setStatusFrame:(WBStatusFrame *)statusFrame{
    
    _statusFrame = statusFrame;
    
    WBStatus *status = statusFrame.status;
    WBUser *user = status.user;
    
    /** 原创微博整体视图 */
    self.originalView.frame = statusFrame.originalViewF;
    
    /** 头像 */
    self.iconView.frame = statusFrame.iconViewF;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    
    /** 配图 */
    if (status.pic_urls.count) {//有配图
        self.photoView.frame = statusFrame.photoViewF;
        WBPhotoModel *photo = [status.pic_urls lastObject];
        [self.photoView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
        self.photoView.hidden = NO;
    }else{
        self.photoView.hidden = YES;
    }
    
    
    /** 会员图标 */
    if (user.isvip) {
        self.vipView.hidden = NO;
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        self.nameLabel.textColor = [UIColor orangeColor];
    }else{
        self.vipView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }

    /** 昵称 */
    self.nameLabel.frame = statusFrame.nameLabelF;
    self.nameLabel.text = user.name;
    
    /** 时间 */
    self.timeLabel.frame = statusFrame.timeLabelF;
    self.timeLabel.text = status.created_at;
    
    
    /** 来源 */
    self.sourceLabel.frame = statusFrame.sourceLabelF;
    self.sourceLabel.text = status.source;
    
    /** 内容 */
    self.contentLabel.frame = statusFrame.contentLabelF;
    self.contentLabel.text = status.text;
    
    /** 转发微博 */
    /** 转发微博整体 */
    if (status.retweeted_status) {
        
        WBStatus *retweeted_status = status.retweeted_status;
        WBUser *retweeted_status_user = status.user;
        
        self.retweetView.hidden = NO;
        /** 内容 */
        NSString *retweetContent = [NSString stringWithFormat:@"@%@:%@", retweeted_status_user.name, retweeted_status.text];
        self.retweetContentLabel.frame = statusFrame.retweetContentLabelF;
        self.retweetContentLabel.text = retweetContent;
        
        /** 配图 */
        if (retweeted_status.pic_urls.count) {//有配图
            self.retweetPhotoView.frame = statusFrame.retweetPhotoViewF;
            WBPhotoModel *photo = [retweeted_status.pic_urls lastObject];
            [self.retweetPhotoView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
            self.retweetPhotoView.hidden = NO;
        }else{//无配图
            self.retweetPhotoView.hidden = YES;
        }
        
        /** 被转发微博整体视图 */
        self.retweetView.frame = statusFrame.retweetViewF;
    }else{
        self.retweetView.hidden = YES;
    }
    
    /** 工具条 */
    self.toolView.frame = statusFrame.toolViewF;
    self.toolView.status = status;
}


////将cell下移
//- (void)setFrame:(CGRect)frame{
//    
//    frame.origin.y += WBCellSpaceW;
//    [super setFrame:frame];
//}
@end
