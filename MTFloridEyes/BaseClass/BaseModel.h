//
//  BaseModel.h
//  BTProject
//
//  Created by 明桐的Mac on 16/3/23.
//  Copyright © 2016年 小谩的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

/*
 自动设置属性值
 （1）model 和JSON [dic]建立映射关系
 （2）JSON的key就是model的属性值。例外：JSON ：id
 处理方法：类名加 +ID；
 （3）生成setter字符串：通过给定的JSON的key，生成字符串
 例如： image  -> setImage
 (4)根据生成的setter字符串，生成SEL变量（制定一个方法）
 （5）根据生成的方法设置model的属性值
 */
- (id)initWithJSONDic:(NSDictionary*)json;

//将接受到的数据建立映射关系
//根据关键字定制setter方法
//根据关键字制定的setter方法给value赋值
@end
