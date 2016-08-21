//
//  WBStatusCell.h
//  微博
//
//  Created by 朱占龙 on 16/8/21.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBStatusFrame;

@interface WBStatusCell : UITableViewCell

@property(nonatomic, strong) WBStatusFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
