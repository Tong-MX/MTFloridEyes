//
//  BaseModel.m
//  BTProject
//
//  Created by 明桐的Mac on 16/3/23.
//  Copyright © 2016年 小谩的Mac. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)initWithJSONDic:(NSDictionary*)json {
    self = [super init];
    if (self) {
        [self _setValueForJSONKeysWithDictionary:json];
    }
    return self;
}


- (void)_setValueForJSONKeysWithDictionary:(NSDictionary*)json {
    //建立model和JSON的对应关系
    NSDictionary *relationship = [self _setUpRelationship:json];
    for (id jsonKey in relationship) {
        //根据value生成setter方法
        id modelValue = relationship[jsonKey];
        
        //生成SEL变量，指向一个方法
        SEL sel = [self _makeSELWithName:modelValue];
        
        //增强程序的健壮性
        if ([self respondsToSelector:sel]) {
            
            //获取真正的数据
            id jasonValue = json[jsonKey];
            
            //设置属性值x
            [self performSelector:sel  withObject:jasonValue];
            
        }
        
    }
    
}//设置model的Value

- (SEL)_makeSELWithName:(NSString*)modelValue {
    //image - > setImage
    //取出首字母,转化成大写
    NSString *capital = [[modelValue substringToIndex:1]uppercaseString];
    
    //获取剩下的字母
    NSString *end = [modelValue substringFromIndex:1];
    
    //拼接字符串
    NSString *setterMethod = [NSString stringWithFormat:@"set%@%@:",capital,end];
    
    //根据字符创生成方法
    SEL sel = NSSelectorFromString(setterMethod);
    
    //返回生成的setter
    return sel;
    
}//合成setter方法

- (NSMutableDictionary*)_setUpRelationship:(NSDictionary*)json {
    /*
     relationship
     key :JSON  KEY
     value: Model 属性值
     */
    NSMutableDictionary *relationship = [NSMutableDictionary dictionaryWithCapacity:json.count];
    
    for (id jsonKey in json) {
        
        if ([jsonKey isEqualToString:@"id"]) {
            
            //id拼接  例如：BaseModel -> BaseModelID
            NSString *className = NSStringFromClass([self class]);
            
            NSString *newModeValue = [className stringByAppendingFormat:@"%@",[jsonKey uppercaseString]];
            
            [relationship setObject:newModeValue forKey:jsonKey];
            
        }else {
            //model :iamge  json :image
            [relationship   setObject:jsonKey forKey:jsonKey];
        }

    }

    return  relationship;
    
}//建立映射关系
@end
