//
//  hBaseViewController.m
//  hRACDemo
//
//  Created by Admin on 2016/11/29.
//  Copyright © 2016年 hyc. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()


@end

@implementation BaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 关闭透明,及上下延伸
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setExtendedLayoutIncludesOpaqueBars:NO];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]init];
    [backBtn setTitle:@""];
    [self.navigationItem setBackBarButtonItem:backBtn];
    
    // 加个背景色，不然没动画效果
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
