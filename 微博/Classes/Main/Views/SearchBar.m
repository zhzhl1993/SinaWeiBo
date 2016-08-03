//
//  searchBar.m
//  微博
//
//  Created by 朱占龙 on 16/7/10.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        self.placeholder = [NSString stringWithFormat:@"请输入要搜索内容"];
        
        // 设置搜索框左边视图
        UIImage *image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:image];
        searchIcon.width = 30;
        searchIcon.height = 30;
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

+ (instancetype)searchBar{
    return [[self alloc] init];
}

@end
