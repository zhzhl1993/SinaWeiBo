//
//  Test2ViewController.m
//  微博
//
//  Created by 朱占龙 on 16/7/9.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "Test2ViewController.h"

@interface Test2ViewController ()

@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //巧妙利用程序的执行顺序，覆盖不满足要求的部分
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:0 target:nil action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
