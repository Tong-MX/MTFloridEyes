//
//  SceneTableViewCell.h
//  MTFloridEyes
//
//  Created by 明桐的Mac on 17/1/6.
//  Copyright © 2017年 小谩的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneModel.h"

@interface SceneTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *picture;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *littleLabel;

@property (nonatomic, strong) UIView *coverview;

@property (nonatomic, strong) SceneModel *model;

- (CGFloat)cellOffset;
@end
