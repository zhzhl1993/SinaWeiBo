//
//  ZLEmotionListView.m
//  微博
//
//  Created by 朱占龙 on 2016/11/4.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "ZLEmotionListView.h"

#define ZLEmotionNum 20

@interface ZLEmotionListView()<UIScrollViewDelegate>

@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, weak) UIPageControl *pageControl;
@end
@implementation ZLEmotionListView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
      //1.创建scrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        //2.pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.currentPageIndicatorTintColor = YYColor(225, 10, 10);
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.userInteractionEnabled = NO;
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    return self;
}

//根据emotions，显示表情
- (void)setEmotions:(NSArray *)emotions{
    _emotions = emotions;
    
    NSUInteger count = (emotions.count + ZLEmotionNum - 1) / ZLEmotionNum;
    //1.页数设置
    self.pageControl.numberOfPages = count;
    //2.scrollView
    for (int i = 0; i < self.pageControl.numberOfPages; i++) {
        UIView *pageView = [[UIView alloc] init];
        pageView.backgroundColor = YYRandomColor;
        [self.scrollView addSubview:pageView];
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //1.pageControl
    self.pageControl.width = self.width;
    self.pageControl.height = 35;
    self.pageControl.y = self.height - self.pageControl.height;
    self.pageControl.x = 0;
    
    //2.scrollView
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    self.scrollView.x = self.scrollView.y = 0;
    
    //3.scrollView
    NSUInteger count = self.scrollView.subviews.count;
    for (int i = 0; i < count; i++) {
        UIView *pageView = self.scrollView.subviews[i];
        pageView.height = self.scrollView.height;
        pageView.width = screenWidth;
        pageView.x = pageView.width * i;
        pageView.y = 0;
    }
    //4.
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 0);
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    double pageNum = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(pageNum + 0.5);
}
@end
