//
//  KMoreNetManager.h
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "KNetManager.h"

@interface KMoreNetManager : KNetManager

typedef NS_ENUM(NSUInteger, ContentType) {
    
    ContentTypeNews,  // 听新闻
    ContentTypeNovels,  // 听小说
    ContentTypeTalkShow,  // 听脱口秀
    ContentTypeCrossTalk,  // 听相声
    
    ContentTypeMusic,  // 听音乐。。。
    
    ContentTypeEmotion,  // 听情感心声
    ContentTypeHistory,  // 听历史
    ContentTypeLectures,  // 听讲座
    ContentTypeBroadcasr,  // 听广播剧
    ContentTypeChildrenStory,  // 听儿童故事
    ContentTypeForeignLanguage,  // 听外语
    ContentTypeGame,  // 听游戏
};


/** 解析,获取内容推荐数据模型 */
// http://mobile.ximalaya.com/mobile/discovery/v2/category/recommends?categoryId=1&contentType=album&device=android&scale=2&version=4.3.32.2
+ (id)getContentsForForCategoryId:(NSInteger)categoryID contentType:(NSString*)type completionHandle:(void(^)(id responseObject, NSError *error))completed;


/**  从网络上获取 选集信息  通过AlbumId, mainTitle, idAsc(是否升序)*/
//http://mobile.ximalaya.com/mobile/others/ca/album/track/2758446/true/1/20?position=1&albumId=2758446&isAsc=true&device=android&title=%E5%B0%8F%E7%BC%96%E6%8E%A8%E8%8D%90&pageSize=20
+ (id)getTracksForAlbumId:(NSInteger)albumId mainTitle:(NSString *)title idAsc:(BOOL)isAsc completionHandle:(void(^)(id responseObject, NSError *error))completed;

@end
