//
//  WBOAuthViewController.m
//  微博
//
//  Created by 朱占龙 on 16/8/7.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBOAuthViewController.h"
#import "AFNetworking.h"
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
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",WBAppKey,WBRedirectUrl];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    WBLog(@"webViewDidStartLoad");
    [MBProgressHUD showMessage:@"正在加载数据..."];
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
    //内部改了，在此可以注释
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //2.拼接请求参数
    NSMutableDictionary *paraM = [NSMutableDictionary dictionary];
    paraM[@"client_id"] = WBAppKey;
    paraM[@"client_secret"] = WBAppSecrert;
    paraM[@"grant_type"] = @"authorization_code";
    paraM[@"code"] = code;
    paraM[@"redirect_uri"] = WBRedirectUrl;
    //3.发送请求
    [manager POST:@"https://api.weibo.com/oauth2/access_token" parameters:paraM progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        [MBProgressHUD hideHUD];
        //将返回账号数据存储转换成模型然后存储
        WBAccountModel *account = [WBAccountModel accountWithDict:responseObject];
        
        //存储账号信息
        [WBAccountTool saveAccountWithAccount:account];
        
        //切换根控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchViewController];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [MBProgressHUD hideHUD];
        WBLog(@"请求失败%@",error);
    }];
}
@end
