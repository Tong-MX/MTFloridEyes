//
//  BaseViewController.m
//  MTFloridEyes
//
//  Created by 明桐的Mac on 17/1/6.
//  Copyright © 2017年 小谩的Mac. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () {
    BOOL hasAppeared;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self configLeftNavigationBarButton:[self leftNavigationBarButton]];
    [self initParameters];
    [self createUI];
}

- (void)createUI{
    
}

- (void)loadOnce{
    
}

- (void)loadMultiple{
    
}

- (void)reduceChange{
    
}

- (void)initParameters {
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self reduceChange];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!hasAppeared) {
        [self loadOnce];
    }
    [self loadMultiple];
    hasAppeared = true;
}

- (void)configLeftNavigationBarButton:(UIBarButtonItem *)barButton{
    self.navigationItem.leftBarButtonItem = barButton;
}

- (UIBarButtonItem *)leftNavigationBarButton {
    return [[UIBarButtonItem alloc]initWithCustomView:[self leftBtnWithJudgeCustom]];
}

- (UIButton*)leftBtnWithJudgeCustom {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(popBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"right_arrow_@2x (2)"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 0, 19.0, 16.0);
    return btn;
}

- (void)popBtnClicked{
    [self.navigationController popViewControllerAnimated:true];
}

@end
