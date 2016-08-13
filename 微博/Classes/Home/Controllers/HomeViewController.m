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

@interface HomeViewController () <ZLDropDownMenuDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置导航栏上的内容
    [self setupNav];
    
    //获取用户信息
    [self setupUserInfo];
}


/**
 *  获取用户信息
 */
- (void)setupUserInfo{
    /**
     https://api.weibo.com/2/users/show.json
     access_token	true	string	采用OAuth授权方式为必填参数，OAuth授权后获得。
     uid	false	int64	需要查询的用户ID。
     */
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
        NSString *name = responseObject[@"name"];
        [titleBtn setTitle:name forState:UIControlStateNormal];
        
        account.name = name;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
@end
