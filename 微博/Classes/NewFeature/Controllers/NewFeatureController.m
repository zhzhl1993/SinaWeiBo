//
//  NewFeatureController.m
//  微博
//
//  Created by 朱占龙 on 16/7/16.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "NewFeatureController.h"
#import "WBTabBarViewController.h"

#define WBNewFeatureImageCount 4

@interface NewFeatureController ()<UIScrollViewDelegate>
@property (nonatomic, strong)  UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControlView;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *startBtn;
@end

@implementation NewFeatureController

//scrollerView懒加载
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.view.bounds;
        //内容大小
        _scrollView.contentSize = CGSizeMake(WBNewFeatureImageCount * screenWidth, 0);
        //取消弹簧效果
        _scrollView.bounces = NO;
        //设置分页显示
        _scrollView.pagingEnabled = YES;
        //隐藏水平滚动指示条
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

//页码视图懒加载
-(UIPageControl *)pageControlView{
    if (!_pageControlView) {
        _pageControlView = [[UIPageControl alloc] init];
        //总页数，这个属性没有设置的话pageControl不会显示
        _pageControlView.numberOfPages = WBNewFeatureImageCount;
        //其它页指示颜色
        _pageControlView.pageIndicatorTintColor = RGBColor(189, 189, 189);
        //当前页颜色
        _pageControlView.currentPageIndicatorTintColor = RGBColor(253, 98, 42);
        //位置
        _pageControlView.centerX = screenWidth * 0.5;
        _pageControlView.centerY = screenHeight - 50;
    }
    return _pageControlView;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        //添加按钮
        _shareBtn = [[UIButton alloc] init];
        _shareBtn.frame = CGRectMake(0, 0, 200, 30);
        [_shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
        [_shareBtn addTarget:self action:@selector(clickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.centerX = screenWidth * 0.5;
        _shareBtn.centerY = screenHeight * 0.65;
        
        //设置图片和文字各缩进5，实现拉大button中图片和文字间距
        _shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    }
    return _shareBtn;
}
- (UIButton *)startBtn{
    if (!_startBtn) {
        //添加按钮
        _startBtn = [[UIButton alloc] init];
        [_startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
        _startBtn.size = _startBtn.currentBackgroundImage.size;
        [_startBtn addTarget:self action:@selector(clickStartBtn) forControlEvents:UIControlEventTouchUpInside];
        _startBtn.centerX = self.shareBtn.centerX;
        _startBtn.centerY = screenHeight * 0.75;
    }
    return _startBtn;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor redColor];
    [super viewDidLoad];
    
    //添加页码显示
    [self.view addSubview:self.pageControlView];
    
    //添加scrollerView
    [self addScrolView];
}

- (void)addScrolView{
    
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < WBNewFeatureImageCount; i++) {
        
        UIImageView *newFeatureImage = [[UIImageView alloc] init];
        CGFloat newImageViewWidth = screenWidth;
        CGFloat newImageViewX = i * self.scrollView.width;
        CGFloat NewImageViewHeight = screenHeight;
        newFeatureImage.frame = CGRectMake(newImageViewX, 0, newImageViewWidth, NewImageViewHeight);
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d", i + 1];
        newFeatureImage.image = [UIImage imageNamed: imageName];
        [self.scrollView addSubview:newFeatureImage];
        
        //如果是最后一页添加控件
        if (i == WBNewFeatureImageCount - 1) {
            
            [self setUpLastImageView:newFeatureImage];
        }
    }
}
- (void)setUpLastImageView:(UIImageView *)imageView{
    
    //开启imageView的交互
    imageView.userInteractionEnabled = YES;
    
    //添加按钮
    [imageView addSubview:self.shareBtn];
    
    //开始按钮
    [imageView addSubview:self.startBtn];
    
}


//点击分享
- (void)clickShareBtn:(UIButton *)button{
    
    button.selected = !button.isSelected;
}

//点击开始微博后跳转控制器
- (void)clickStartBtn{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[WBTabBarViewController alloc] init];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int currentPage = scrollView.contentOffset.x / self.scrollView.width + 0.5;
    self.pageControlView.currentPage = currentPage;
}
@end
