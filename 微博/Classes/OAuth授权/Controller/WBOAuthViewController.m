//
//  WBOAuthViewController.m
//  微博
//
//  Created by 朱占龙 on 16/8/7.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBOAuthViewController.h"
#import "AFNetworking.h"
#import "WBTabBarViewController.h"
#import "NewFeatureController.h"
#import "WBAccountModel.h"
#import "MBProgressHUD+MJ.h"
#import "WBAccountTool.h"

@interface WBOAuthViewController ()<UIWebViewDelegate>

@end

@implementation WBOAuthViewController

//隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.创建webView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    //2.用webViews加载登陆页面（新浪提供的）
    //AppKey：4118810800
    //AppSecret：6c65ee0dcbc0e9883f531d717103f4b3
    //RedirectUrl:http://www.baidu.com
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=4118810800&redirect_uri=http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    WBLog(@"webViewDidStartLoad");
    [MBProgressHUD showMessage:@"正在加载数据......"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    WBLog(@"webViewDidFinishLoad");
    [MBProgressHUD hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUD];
}

//拦截URL请求用此方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) {//是回调地址截取
        
        //截取code=后面的值
        int fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
        
        //利用code获取accessToken
        [self accessTokenWithCode:code];
        
        //禁止加载回调地址
        return NO;
    }
    return YES;
}

/**
 *  利用code换取一个accessToken
 *
 *  @param code 授权成功后的request Token
 */
- (void)accessTokenWithCode:(NSString *)code{
    
    //1.创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /*因为新浪数据格式虽然是json，但是它申明成字符串类型，故在响应序列化器self.acceptableContentTypes里面添加了@"text/plain"
     self.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/json", @"text/javascript", nil];
     */
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //2.拼接请求参数
    NSMutableDictionary *paraM = [NSMutableDictionary dictionary];
    paraM[@"client_id"] = @"4118810800";
    paraM[@"client_secret"] = @"6c65ee0dcbc0e9883f531d717103f4b3";
    paraM[@"grant_type"] = @"authorization_code";
    paraM[@"code"] = code;
    paraM[@"redirect_uri"] = @"http://www.baidu.com";
    //3.发送请求
    [manager POST:@"https://api.weibo.com/oauth2/access_token" parameters:paraM progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        [MBProgressHUD hideHUD];
        //将返回账号数据存储转换成模型然后存储
        WBAccountModel *account = [WBAccountModel accountWithDict:responseObject];
        
        [WBAccountTool saveAccountWithAccount:account];
        //上一次使用的版本号（沙盒中）
        NSString *key = @"CFBundleVersion";
        NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        //显示当前版本号（info.plist文件中读取）
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //判断是否显示版本新特性
        if ([currentVersion isEqualToString:lastVersion]) {
            //和上一个版本相同，不需要显示新特性
            window.rootViewController = [[WBTabBarViewController alloc] init];
        }else{
            //和上一个版本不同，显示新特性
            window.rootViewController = [[NewFeatureController alloc] init];
            //将当前版本号存储到沙盒中
            [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [MBProgressHUD hideHUD];
        WBLog(@"请求失败%@",error);
    }];
}
@end
