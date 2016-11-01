//
//  KNetManager.m
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "KNetManager.h"

@implementation KNetManager

static AFHTTPSessionManager * manager = nil;

/** AFHTTPSessionManager单例 */
+ (AFHTTPSessionManager *)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        // 设置接受解析的内容类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain",@"text/javascript",@"application/json", nil];
    });
    return manager;
}

+ (id)GET:(NSString *)path parameters:(NSDictionary *)params complationHandle:(void (^)(id, NSError *))completed {
    
    //NSLog(@"Request Path: %@, params %@", path, params);
    //NSString *urlStr = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [[self defaultManager] GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        completed(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"GET ERROR: %@",error.userInfo);
    }];
}

+ (id)POST:(NSString *)path parameters:(NSDictionary *)params complationHandle:(void (^)(id, NSError *))completed {
    
    return [[self defaultManager] POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        completed(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"POST ERROR: %@",error.userInfo);
    }];
}

+ (NSString *)percentURLByPath:(NSString *)path params:(NSDictionary *)params{
    NSMutableString *percentPath =[NSMutableString stringWithString:path];
    NSArray *keys = params.allKeys;
    NSInteger count = keys.count;
    
    for (int i = 0; i < count; i++) {
        if (i == 0) {
            [percentPath appendFormat:@"?%@=%@", keys[i], params[keys[i]]];
        }else{
            [percentPath appendFormat:@"&%@=%@", keys[i], params[keys[i]]];
        }
    }
    
    
    return [percentPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
