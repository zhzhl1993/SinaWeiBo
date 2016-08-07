//
//  WBOAuthViewController.m
//  微博
//
//  Created by 朱占龙 on 16/8/7.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBOAuthViewController.h"
#import "AFNetworking.h"

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
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    WBLog(@"webViewDidStartLoad");
//}

//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    WBLog(@"webViewDidFinishLoad");
//}

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
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WBLog(@"请求成功%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
    }];
}
@end
