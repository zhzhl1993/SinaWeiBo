//
//  testViewController.m
//  微博
//
//  Created by 朱占龙 on 16/7/8.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "testViewController.h"
#import "Test2ViewController.h"

@interface testViewController ()

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    Test2ViewController *test2 = [[Test2ViewController alloc] init];
    test2.title = @"测试2控制器";
    
    [self.navigationController pushViewController:test2 animated:YES];
}

@end
