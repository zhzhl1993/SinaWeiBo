//
//  HomeViewController.m
//  微博
//
//  Created by 朱占龙 on 16/7/8.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "HomeViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "ZLDropDownMenu.h"
#import "WBTitleMenuViewController.h"
#import "AFNetworking.h"
#import "WBAccountTool.h"
#import "WBTitleButton.h"
#import "UIImageView+WebCache.h"
#import "WBStatus.h"
#import "WBUser.h"
#import "MJExtension.h"
#import "WBLoadMoreFooter.h"
#import "WBStatusCell.h"
#import "WBStatusFrame.h"

@interface HomeViewController () <ZLDropDownMenuDelegate>
/**微博数组，里面存放都是WBStatus模型，每一个WBStatus模型都是一条微博*/
@property(nonatomic, strong) NSMutableArray *statuses;
@end

@implementation HomeViewController

- (NSMutableArray *)statuses{
    if (!_statuses) {
        _statuses = [NSMutableArray array];
    }
    return _statuses;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置导航栏上的内容
    [self setupNav];
    
    //获取用户信息
    [self setupUserInfo];
    
    //下拉刷新
    [self downRefreshStatus];
    
    //上拉刷新
    [self upRefreshStatus];
    
    // 获得未读数
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    //不管主线程是否在处理其他时间，都会抽取时间处理下timer
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/**
 *  获得未读数
 */
- (void)setupUnreadCount
{
    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接请求参数
    WBAccountModel *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3.发送请求
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *status = [responseObject[@"status"] description];
        NSLog(@"-----====-----%@", status);
        if ([status isEqualToString:@"0"]) { // 如果是0，得清空数字
            //在tabBar上显示未读信息条数
            self.tabBarItem.badgeValue = nil;
            //在应用程序的图标上显示未读信息条数
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else { // 非0情况
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WBLog(@"请求失败-%@", error);
    }];
}

/**
 *  上拉刷新
 */
- (void)upRefreshStatus{
    
    WBLoadMoreFooter *footer = [WBLoadMoreFooter footer];
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
}

/**
 *  下拉刷新
 */
- (void)downRefreshStatus{
    
    //1.创建刷新控件
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshNewStatus:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    
    //2.马上进入刷新状态，并不会触发UIControlEventValueChanged事件
    [refresh  beginRefreshing];
    
    //3.马上加载数据
    [self refreshNewStatus:refresh];
}

//开始刷新
- (void)refreshNewStatus:(UIRefreshControl *)control{
    //https://api.weibo.com/2/statuses/friends_timeline.json
    //1.创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //2.拼接参数
    WBAccountModel *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    //取出最前面的微博 （最新的微博，最大的ID）
    WBStatus *firstStatus = [self.statuses firstObject];
    if (firstStatus) {
        params[@"since_id"] = firstStatus.idstr;
    }
    
    //3.获取信息
    [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //将字典数组转换成模型数组
        NSArray *newStatus = [WBStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        NSRange range = NSMakeRange(0, newStatus.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statuses insertObjects:newStatus atIndexes:set];
        
        //刷新表格
        [self.tableView reloadData];
        [control endRefreshing];
        
        //动画提示更新条数
        [self showNewStatusCount: (unsigned long)newStatus.count];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
        [control endRefreshing];
    }];
}

/**
 *  动画提示更新条数
 */
- (void)showNewStatusCount:(unsigned long)count{
    
    //刷新成功
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSLog(@"更新了%lu条微博",count);
    //1.创建label
    CGFloat height = 35;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat y = 64 - height;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, width, height)];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    
    //2.设置其他属性
    if (!count) {
        label.text = @"没有最新的微博内容，请稍后再试！";
    }else{
        label.text = [NSString stringWithFormat:@"更新了%lu条微博",count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    //3.添加到视图
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    //4.动画
    /*
     如果某个动画完成后又要回到原来的状态，建议使用transform
     */
    CGFloat duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
        //        label.y += label.height;
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
    } completion:^(BOOL finished) {
        //延时执行
        CGFloat delay = 1.0;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            //            label.y -= label.height;
            label.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

/**
 *  获取用户信息
 */
- (void)setupUserInfo{
    
    //1.创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //2.拼接参数
    WBAccountModel *account = [WBAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    dict[@"uid"] = account.uid;
    
    //3.获取信息
    [manager GET:@"https://api.weibo.com/2/users/show.json" parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        //设置主页标题
        WBTitleButton *titleBtn = (WBTitleButton *)self.navigationItem.titleView;
        WBUser *user = [WBUser objectWithKeyValues:responseObject];
        [titleBtn setTitle:user.name forState:UIControlStateNormal];
        
        account.name = user.name;
        [WBAccountTool saveAccountWithAccount:account];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
    }];
}

/**
 *  设置导航栏上的内容
 */
- (void)setupNav{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendsearch) image: @"navigationbar_friendsearch" highImage: @"navigationbar_friendsearch_highlighted"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    //设置标题
    WBTitleButton *titleBtn = [[WBTitleButton alloc] init];
    NSString *name = [WBAccountTool account].name;
    [titleBtn setTitle: name ? name : @"首页" forState:UIControlStateNormal];
    
    [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
}


/**
 *  标题的点击
 */
- (void)titleClick: (UIButton *)titleButton{
    
    //创建下拉菜单
    ZLDropDownMenu *dropDown = [ZLDropDownMenu menu];
    
    WBTitleMenuViewController *titleVc = [[WBTitleMenuViewController alloc] init];
    titleVc.view.width = 150;
    titleVc.view.height = 100;
    dropDown.contentController = titleVc;
    
    //设置当前控制器为下拉菜单的代理
    dropDown.delegate = self;
    
    [dropDown showFrom: titleButton];
    
}

- (void)friendsearch{
    
    NSLog(@"friendsearch");
}

- (void)pop{
    
    NSLog(@"pop");
}

#pragma mark - ZLDropDownMenuDelegate方法的实现

- (void)dropDownMenuDidShow:(ZLDropDownMenu *)menu{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
}

- (void)dropDownMenuDidDismiss:(ZLDropDownMenu *)menu{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.statuses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WBStatusCell *cell = [WBStatusCell cellWithTableView:tableView];
    
    //传递模型
    cell.statusFrame = self.statuses[indexPath.row];
    
    return cell;
}
@end
