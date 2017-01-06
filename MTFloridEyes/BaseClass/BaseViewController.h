//
//  BaseViewController.h
//  MTFloridEyes
//
//  Created by 明桐的Mac on 17/1/6.
//  Copyright © 2017年 小谩的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)createUI;
- (void)loadOnce;//加载网络数据

- (void)loadMultiple;//视图将要显示时候
- (void)reduceChange;//视图将要消失时候

- (void)initParameters;//初始化数据
- (UIBarButtonItem *)leftNavigationBarButton;//重写更换样式
@end
