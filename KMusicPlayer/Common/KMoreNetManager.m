//
//  KMoreNetManager.m
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "KMoreNetManager.h"
#import "ContentsModel.h"
#import "DestinationModel.h"

#define kURLPath @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends"
#define kURLCategoryPath @"http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends"
#define kURLAlbumPath @"http://mobile.ximalaya.com/mobile/discovery/v1/category/album"

// 小编推荐栏 更多跳转URL
#define KURLEditor @"http://mobile.ximalaya.com/mobile/discovery/v1/recommend/editor"
// 精品听单栏 更多跳转URL
#define KURLSpecial @"http://mobile.ximalaya.com/m/subject_list"

#define kURLVersion @"version":@"4.3.26.2"
#define kURLDevice @"device":@"ios"
#define KURLScale @"scale":@2
#define kURLCalcDimension @"calcDimension":@"hot"
#define kURLPageID @"pageId":@1
#define kURLStatus  @"status":@0
#define KURLPer_page @"per_page":@10
#define kURLPosition @"position":@1

// 汉字UTF8进行转换并转入字典
#define kURLMoreTitle @"title":[@"更多" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

@implementation KMoreNetManager

+ (id)getContentsForForCategoryId:(NSInteger)categoryID contentType:(NSString *)type completionHandle:(void (^)(id, NSError *))completed
{
    NSDictionary *params = @{@"categoryId":@(categoryID),@"contentType":type,kURLDevice,@"scale":@2,@"version":@"4.3.26.2"};
    
    return [self GET:kURLPath parameters:params complationHandle:^(id responseObject, NSError *error) {
        completed([ContentsModel mj_objectWithKeyValues:responseObject],error);
        //NSLog(@"%@",responseObject);
    }];
}

/**  从网络上获取 选集信息  通过AlbumId, mainTitle, idAsc(是否升序)*/
+ (id)getTracksForAlbumId:(NSInteger)albumId mainTitle:(NSString *)title idAsc:(BOOL)isAsc completionHandle:(void(^)(id responseObject, NSError *error))completed {
    NSDictionary *params = @{@"albumId":@(albumId),@"title":title,@"isAsc":@(isAsc), kURLDevice,kURLPosition};
    NSString *path = [NSString stringWithFormat:@"http://mobile.ximalaya.com/mobile/others/ca/album/track/%ld/true/1/20",(long)albumId];
    return [self GET:path parameters:params complationHandle:^(id responseObject, NSError *error) {
        completed([DestinationModel mj_objectWithKeyValues:responseObject],error);
        //NSLog(@"%@",responseObject);
        
    }];
}

@end
