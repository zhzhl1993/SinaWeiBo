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
    
    //加载最新的微博数据
    [self loadNewStatus];
}

/**
 *  加载最新的微博数据
 */
- (void)loadNewStatus{
    //https://api.weibo.com/2/statuses/friends_timeline.json
    //1.创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //2.拼接参数
    WBAccountModel *account = [WBAccountTool account];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = account.access_token;
    
    //3.获取信息
    [manager GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        NSArray *dictArray = responseObject[@"statuses"];

        //将数组转换成模型
        for (NSDictionary *dict in dictArray) {
            WBStatus *status = [WBStatus statusWithDict:dict];
            [self.statuses addObject:status];
        }
        
        //刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
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
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //设置主页标题
        WBTitleButton *titleBtn = (WBTitleButton *)self.navigationItem.titleView;
        WBUser *user = [WBUser userWithDict:responseObject];
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
