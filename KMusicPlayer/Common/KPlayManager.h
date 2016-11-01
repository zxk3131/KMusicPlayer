//
//  KPlayManager.h
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class TracksViewModel;

@protocol PlayManagerDelegate <NSObject>

@required
- (void)changeMusic;

@end

@interface KPlayManager : NSObject

//播放状态
typedef NS_ENUM(NSInteger, KPlayerCycle) {
    theSong = 1,
    nextSong = 2,
    isRandom = 3
};
//播放状态
typedef NS_ENUM(NSInteger, itemModel) {
    historyItem = 0,
    favoritelItem = 1
};
@property (nonatomic, weak) id<PlayManagerDelegate> delegate;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic) BOOL isPlay;

/** 初始化 */
+ (instancetype)sharedInstance;
/** 清空属性 */
- (void)releasePlayer;

/** 装载专辑 */
- (void)playWithModel:(TracksViewModel *)tracks indexPathRow:(NSInteger ) indexPathRow;

- (void)pauseMusic;
- (void)previousMusic;
- (void)nextMusic;
- (void)nextCycle;

- (void)stopMusic;

/** 状态查询 */
- (NSInteger )playerStatus;
- (NSInteger )FYPlayerCycle;

- (NSString *)playMusicName;
- (NSString *)playSinger;
- (NSString *)playMusicTitle;
- (NSURL *)playCoverLarge;
- (UIImage *)playCoverImage;

- (BOOL)havePlay;

@end
