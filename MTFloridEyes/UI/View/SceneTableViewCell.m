//
//  SceneTableViewCell.m
//  MTFloridEyes
//
//  Created by 明桐的Mac on 17/1/6.
//  Copyright © 2017年 小谩的Mac. All rights reserved.
//

#import "SceneTableViewCell.h"

@implementation SceneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        self.clipsToBounds = YES;
        
        _picture = [[UIImageView alloc]initWithFrame:CGRectMake(0, -(KHeight/1.7 -250)/2, KWidth, KHeight/1.7)];
        _picture.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView  addSubview:_picture];
        
        _coverview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 250)];
        _coverview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.33];
        [self.contentView addSubview:_coverview];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 250 / 2 - 30, KWidth, 30)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        
        _littleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 250 / 2 + 30, KWidth, 30)];
        _littleLabel.font = [UIFont systemFontOfSize:14];
        _littleLabel.textAlignment = NSTextAlignmentCenter;
        _littleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_littleLabel];
    
    }
    return self;
    
}

- (void)setModel:(SceneModel *)model{
    if (_model != model) {
        
        [_picture sd_setImageWithURL:[NSURL URLWithString:model.coverForDetail] placeholderImage:nil];
        _titleLabel.text = model.title;
        // 转换时间
        NSInteger time = [model.duration integerValue];
        NSString *timeString = [NSString stringWithFormat:@"%02ld'%02ld''",time/60,time% 60];
        NSString *string = [NSString stringWithFormat:@"#%@ / %@",model.category, timeString];
        _littleLabel.text = string;
    }
    
}

- (CGFloat)cellOffset {
    
    CGRect centerToWindow = [self convertRect:self.bounds toView:self.window];
    CGFloat centerY = CGRectGetMidY(centerToWindow);
    CGPoint windowCenter = self.superview.center;
    
    CGFloat cellOffsetY = centerY - windowCenter.y;
    
    CGFloat offsetDig =  cellOffsetY / self.superview.frame.size.height *2;
    CGFloat offset =  -offsetDig * (KHeight/1.7 - 250)/2;
    
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0,offset);
    
    self.picture.transform = transY;
    
    return offset;
}
@end
