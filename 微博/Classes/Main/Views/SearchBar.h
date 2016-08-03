//
//  searchBar.h
//  微博
//
//  Created by 朱占龙 on 16/7/10.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBar : UITextField

/**
 *  自定义搜索框，用UITextField加放大镜图片构成
 *  需要注意设置返回后的宽度和高度，还有更改图片
 *  @return 返回一个搜索框
 */
+ (instancetype)searchBar;
@end
