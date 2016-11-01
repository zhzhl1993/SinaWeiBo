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
#import "WBComposeToolBar.h"

@interface ComposeViewController ()<UITextViewDelegate,WBComposeToolBarDelegate>
/** 文字输入框 */
@property(nonatomic, strong) UITextView *textView;
/** 工具条 */
@property(nonatomic, strong)  WBComposeToolBar *toolBar;
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
    
    //添加工具条
    [self setupToolBar];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化方法
/*
 * 添加工具条
 */
- (void)setupToolBar{
    WBComposeToolBar *toolBar = [[WBComposeToolBar alloc] init];
    toolBar.width = self.view.width;
    toolBar.delegate = self;
    toolBar.height = 44;
//    self.textView.inputAccessoryView = toolBar;
    toolBar.y = self.view.height - toolBar.height;
    self.toolBar = toolBar;
    [self.view addSubview:toolBar];
}
/*
 *添加输入控件
 */
- (void)setupTextView{
    PlaceHolderTextView *textView = [[PlaceHolderTextView alloc] initWithFrame:self.view.bounds];
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeHolder = @"分享你的新鲜事...";
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    self.textView = textView;
    [self.view addSubview:textView];
    
    //能输入文本的控件一旦成为第一相应者，就会呼出相应的键盘
    [textView becomeFirstResponder];
    //文字改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    //键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
//    UIKeyboardCenterEndUserInfoKey = NSPoint: {187.5, 538},
//    UIKeyboardAnimationDurationUserInfoKey = 0.25
//    UIKeyboardAnimationCurveUserInfoKey = 7,
    NSDictionary *userInfo = notification.userInfo;
    //键盘弹出的动画时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘弹出后的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        //工具条的frame
        self.toolBar.y = keyboardF.origin.y - self.toolBar.height;
    }];
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
    [self.view endEditing:YES];
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

#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - WBComposeToolBarDelegate
- (void)composeToolBar:(WBComposeToolBar *)toolbar didClickButton:(WBComposeToolBarButtonType)buttonType{
    switch (buttonType) {
        case WBComposeToolBarButtonCamera://拍照
            NSLog(@"拍照");
            break;
        case WBComposeToolBarButtonPicture://相册
            NSLog(@"相册");
            break;
        case WBComposeToolBarButtonMention://@
           NSLog(@"@");
            break;
        case WBComposeToolBarButtonTrend://#
            NSLog(@"#");
            break;
        case WBComposeToolBarButtonEmotion: //表情
            
            break;
        default:
            break;
    }
}
@end
