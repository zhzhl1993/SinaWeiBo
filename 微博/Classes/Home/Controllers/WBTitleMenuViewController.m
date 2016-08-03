//
//  WBTitleMenuViewController.m
//  微博
//
//  Created by 朱占龙 on 16/7/13.
//  Copyright © 2016年 cuit. All rights reserved.
//

#import "WBTitleMenuViewController.h"

@interface WBTitleMenuViewController ()

@end

@implementation WBTitleMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"我的消息";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"@我的";
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"我的订阅";
    }else{
        cell.textLabel.text = @"设置";
    }
    
    return cell;
}
@end
