//
//  ComposeViewController.m
//  微博
//
//  Created by 朱占龙 on 2016/10/30.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "ComposeViewController.h"
#import "WBAccountTool.h"
#import "PlaceHolderTextView.h"
#import "AFNetworking.h"

@interface ComposeViewController ()
/** 文字输入框 */
@property(nonatomic, strong) UITextView *textView;
@end

@implementation ComposeViewController

#pragma mark - 系统的方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置导航栏
    [self setupNavi];
    
    //添加输入控件
    [self setupTextView];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化方法
/*
 *添加输入控件
 */
- (void)setupTextView{
    PlaceHolderTextView *textView = [[PlaceHolderTextView alloc] initWithFrame:self.view.bounds];
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeHolder = @"分享你的新鲜事...";
    self.textView = textView;
    [self.view addSubview:textView];
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
}
/*
 *设置导航栏
 */
- (void)setupNavi{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)
        ];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    
    WBAccountModel *account = [WBAccountTool account];
    NSString *name = account.name;
    NSString *prefix = @"发微博";
    if (name) {
        NSString *str = [NSString stringWithFormat:@"%@\n%@",prefix,name];
        NSMutableAttributedString *attrIStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attrIStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:prefix]];
        [attrIStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[str rangeOfString:name]];
        titleLabel.attributedText = attrIStr;
        
        self.navigationItem.titleView = titleLabel;
    }else{
        self.title = prefix;
    }
    
}

#pragma mark - 监听方法
//取消
- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//发送
- (void)send{
    [MBProgressHUD showMessage:@"正在发布微博..."];
    //1.创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.拼接请求参数
    NSMutableDictionary *paraM = [NSMutableDictionary dictionary];
    WBAccountModel *account = [WBAccountTool account];
    paraM[@"status"] = self.textView.text;
    paraM[@"access_token"] = account.access_token;
    
    //3.发送请求
    [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:paraM progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"发布成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"发布失败"];
        WBLog(@"请求失败%@",error);
    }];
}
/*
 * 监听文字改变
 */
- (void)textDidChange{
    
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}
@end
