//
//  SceneViewController.m
//  MTFloridEyes
//
//  Created by 明桐的Mac on 17/1/6.
//  Copyright © 2017年 小谩的Mac. All rights reserved.
//

#import "SceneViewController.h"
#import "SceneModel.h"
#import "SceneTableViewCell.h"

@interface SDWebImageManager  (cache)

- (BOOL)memoryCachedImageExistsForURL:(NSURL *)url;

@end

@implementation SDWebImageManager (cache)

- (BOOL)memoryCachedImageExistsForURL:(NSURL *)url {
    NSString *key = [self cacheKeyForURL:url];
    return ([self.imageCache imageFromMemoryCacheForKey:key] != nil) ?  YES : NO;
}

@end

@interface SceneViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableDictionary *selectDic;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SceneViewController

- (void)createUI {
    
    [self.view addSubview:[self crateTableView]];
    [self.tableView registerClass:[SceneTableViewCell class] forCellReuseIdentifier:@"CellID"];
}

- (UIBarButtonItem *)leftNavigationBarButton {
    return nil;
}

- (NSMutableArray *)dateArray {
    
    if (!_dateArray) {
        _dateArray = [[NSMutableArray alloc]init];
    }
    return _dateArray;
}

//懒加载
- (NSMutableDictionary *)selectDic{
    
    if (!_selectDic) {
        
        _selectDic = [[NSMutableDictionary alloc]init];
        
    }
    return _selectDic;
}

- (void)loadOnce {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:date];

    NSString *url = [NSString stringWithFormat:kEveryDay,dateString];
    
    [LORequestManger GET:url success:^(id response) {
        NSDictionary *dic = (NSDictionary*)response;
        if (dic.allKeys > 0 && dic.allValues > 0) {
            NSArray *arr = dic[@"dailyList"];
            [arr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull objDic, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableArray *selectArray = [NSMutableArray array];
                NSArray *arrVideo = objDic[@"videoList"];
                [arrVideo enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull objDic1, NSUInteger idx, BOOL * _Nonnull stop) {
                    SceneModel *model = [[SceneModel alloc] initWithJSONDic:objDic1];
                    model.collectionCount = objDic1[@"consumption"][@"collectionCount"];
                    model.replyCount = objDic1[@"consumption"][@"replyCount"];
                    model.shareCount = objDic1[@"consumption"][@"shareCount"];
                    
                    [selectArray addObject:model];
                }];
                NSString *date = [[objDic[@"date"] stringValue] substringToIndex:10];
                [self.selectDic setValue:selectArray forKey:date];
            }];
            
            NSComparisonResult (^priceBlock)(NSString *, NSString *) = ^(NSString *string1, NSString *string2){
                
                NSInteger number1 = [string1 integerValue];
                NSInteger number2 = [string2 integerValue];
                
                if (number1 > number2) {
                    return NSOrderedAscending;
                }else if(number1 < number2){
                    return NSOrderedDescending;
                }else{
                    return NSOrderedSame;
                }
                
            };
            
            self.dateArray = [[[self.selectDic allKeys] sortedArrayUsingComparator:priceBlock]mutableCopy];
            
            NSLog(@"%ld",[self.dateArray count]);
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (UITableView*)crateTableView {
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,KWidth,KHeight) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollsToTop = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor whiteColor];
    }

    return _tableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.dateArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.selectDic[self.dateArray[section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SceneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[SceneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    return cell;
}

// 头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *string = self.dateArray[section];
    long long int date1 = (long long int)[string intValue];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date1];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMdd"];
    NSString *dateString = [dateFormatter stringFromDate:date2];
    
    return dateString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 250;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

//添加每个cell出现时的3D动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(SceneTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    SceneModel *model = self.selectDic[self.dateArray[indexPath.section]][indexPath.row];
    
    if (![[SDWebImageManager sharedManager] memoryCachedImageExistsForURL:[NSURL URLWithString:model.coverForDetail]]) {
        
        CATransform3D rotation;//3D旋转
        
        rotation = CATransform3DMakeTranslation(0 ,50 ,20);
        //        rotation = CATransform3DMakeRotation( M_PI_4 , 0.0, 0.7, 0.4);
        //逆时针旋转
        
        rotation = CATransform3DScale(rotation, 0.9, .9, 1);
        
        rotation.m34 = 1.0/ -600;
        
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        cell.layer.transform = rotation;
        
        [UIView beginAnimations:@"rotation" context:NULL];
        //旋转时间
        [UIView setAnimationDuration:0.6];
        cell.layer.transform = CATransform3DIdentity;
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
    }
    [cell cellOffset];
    cell.model = model;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSArray<SceneTableViewCell *> *array = [self.tableView visibleCells];
    
    [array enumerateObjectsUsingBlock:^(SceneTableViewCell * _Nonnull objCell, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [objCell cellOffset];
    }];
    
}
@end
