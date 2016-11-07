//
//  ComposeViewController.m
//  微博
//
//  Created by 朱占龙 on 2016/10/30.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "ComposeViewController.h"
#import "WBAccountTool.h"
#import "WBEmotionTextView.h"
#import "AFNetworking.h"
#import "WBComposeToolBar.h"
#import "WBComposePhotosView.h"
#import "ZLEmotionKeyboard.h"
#import "WBEmotionModel.h"

@interface ComposeViewController ()<UITextViewDelegate,WBComposeToolBarDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/** 文字输入框 */
@property(nonatomic, weak) WBEmotionTextView *textView;
/** 键盘上工具条 */
@property(nonatomic, weak)  WBComposeToolBar *toolBar;
/** 相册 */
@property(nonatomic, weak)  WBComposePhotosView *photosView;
/** 表情键盘 */
@property(nonatomic, strong) ZLEmotionKeyboard *emotionKeyBoard;
/** 切换键盘 */
@property(nonatomic, assign) BOOL switchingKeyBoard;
@end

@implementation ComposeViewController

#pragma mark - 懒加载
- (ZLEmotionKeyboard *)emotionKeyBoard{
    if (!_emotionKeyBoard) {
        _emotionKeyBoard = [[ZLEmotionKeyboard alloc] init];
        _emotionKeyBoard.width = self.view.width;
        _emotionKeyBoard.height = 216;
    }
    return _emotionKeyBoard;
}
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
    
    //添加相册
    [self setupPhotoView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //能输入文本的控件一旦成为第一相应者，就会呼出相应的键盘
    [self.textView becomeFirstResponder];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化方法
/*
 * 添加相册
 */
- (void)setupPhotoView{
    WBComposePhotosView *photosView = [[WBComposePhotosView alloc] init];
    photosView.y = 200;
    photosView.width = screenWidth;
    photosView.height = 100;
    self.photosView = photosView;
    [self.view addSubview:photosView];
}
/*
 * 添加工具条
 */
- (void)setupToolBar{
    WBComposeToolBar *toolBar = [[WBComposeToolBar alloc] init];
    toolBar.width = self.view.width;
    toolBar.delegate = self;
    toolBar.height = 37;
//    self.textView.inputAccessoryView = toolBar;
    toolBar.y = self.view.height - toolBar.height;
    self.toolBar = toolBar;
    [self.view addSubview:toolBar];
}
/*
 *添加输入控件
 */
- (void)setupTextView{
    WBEmotionTextView *textView = [[WBEmotionTextView alloc] initWithFrame:self.view.bounds];
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeHolder = @"分享你的新鲜事...";
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    self.textView = textView;
    [self.view addSubview:textView];
    
    //文字改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    //键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:emotionSelectNotification object:nil];
}

/*
 *  表情选中
 */
- (void)emotionDidSelected:(NSNotification *)notification{
    WBEmotionModel *emotion = notification.userInfo[emotionSelectKey];
    
    [self.textView insertEmotion:emotion];
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
//    UIKeyboardCenterEndUserInfoKey = NSPoint: {187.5, 538},
//    UIKeyboardAnimationDurationUserInfoKey = 0.25
//    UIKeyboardAnimationCurveUserInfoKey = 7,
    
    //表情正在切换键盘则返回
    if (self.switchingKeyBoard) return;
    
    NSDictionary *userInfo = notification.userInfo;
    //键盘弹出的动画时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //键盘弹出后的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        if (keyboardF.origin.y > screenHeight) {
            self.toolBar.y = screenHeight - self.toolBar.height;
        }else{
            //工具条的frame
            self.toolBar.y = keyboardF.origin.y - self.toolBar.height;
        }
    }];
}
/*
 *设置导航栏
 */
- (void)setupNavi{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendWeibo)];
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
- (void)sendWeibo{
    
    if (self.photosView.photos.count) {
        [self sendWithImage];
    }else{
        [self sendWithoutImage];
    }
}

/*
 * 发布有图片的微博
 */
- (void)sendWithImage{
    /*
     *  https://upload.api.weibo.com/2/statuses/upload.json
     * status	true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
     * pic	true	binary	要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。
     * access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
     */
    [MBProgressHUD showMessage:@"正在发布微博..."];
    //1.创建管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.拼接请求参数
    NSMutableDictionary *paraM = [NSMutableDictionary dictionary];
    WBAccountModel *account = [WBAccountTool account];
    paraM[@"status"] = self.textView.text;
    paraM[@"access_token"] = account.access_token;
    
    //3.发送请求
    [manager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:paraM constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //拼接文件数据
        UIImage *image = [self.photosView.photos firstObject];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
 * 发布没有图片的微博
 */
- (void)sendWithoutImage{
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
            [self openCamera];
            NSLog(@"拍照");
            break;
        case WBComposeToolBarButtonPicture://相册
            [self openAlbum];
            NSLog(@"相册");
            break;
        case WBComposeToolBarButtonMention://@
           NSLog(@"@");
            break;
        case WBComposeToolBarButtonTrend://#
            NSLog(@"#");
            break;
        case WBComposeToolBarButtonEmotion: //表情
            [self switchKeyboard];
            break;
        default:
            break;
    }
}
- (void)switchKeyboard{
    //self.textView.inputView == nil 判断系统自带的键盘
    if (self.textView.inputView == nil) {//切换为表情键盘
        self.textView.inputView = self.emotionKeyBoard;
        //切换表情按钮的显示图标
        self.toolBar.showKeyBoardButton = YES;
    }else{//切换为系统自带的键盘
        self.textView.inputView = nil;
        //切换表情按钮的显示图标
        self.toolBar.showKeyBoardButton = NO;
    }
    //切换键盘
    self.switchingKeyBoard = YES;
    //退出键盘
    [self.view endEditing:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //弹出键盘
        [self.textView becomeFirstResponder];
        //切换键盘完毕
        self.switchingKeyBoard = NO;
    });
}
#pragma mark - 其他
- (void)openCamera{
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
}
- (void)openAlbum{
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.photosView addPhoto:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
