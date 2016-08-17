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
    [self refreshStatus];
    
}

/**
 *  下拉刷新
 */
- (void)refreshStatus{
    
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
    
    NSLog(@"更新了%lu条微博",count);
    //1.创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    
    //2.设置文字
    if (!count) {
        
        label.text = @"没有最新的微博内容，请稍后再试！";
    }else{
        label.text = [NSString stringWithFormat:@"更新了%lu条微博",count];
    }
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
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    //取出这行对应的微博字典模型
    WBStatus *status = self.statuses[indexPath.row];
    //取出用户字典
    WBUser *user = status.user;
    //设置用户昵称
    cell.textLabel.text = user.name;
    //设置微博内容
    cell.detailTextLabel.text = status.text;
    NSString *imageUrl = user.profile_image_url;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    return cell;
}
@end
