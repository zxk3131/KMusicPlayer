//
//  BaseModel.m
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

@end
