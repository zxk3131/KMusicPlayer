//
//  KPlayManager.m
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "KPlayManager.h"
#import "TracksViewModel.h"
#import <MediaPlayer/MediaPlayer.h>


#include <sys/types.h>
#include <sys/sysctl.h>

@interface KPlayManager ()

@property (nonatomic) KPlayerCycle  cycle;

@property (nonatomic, strong) AVPlayerItem   *currentPlayerItem;

@property (nonatomic) BOOL isLocalVideo; //是否播放本地文件
@property (nonatomic) BOOL isFinishLoad; //是否下载完毕

@property (nonatomic,strong) TracksViewModel *tracksVM;
@property (nonatomic,assign) NSInteger indexPathRow;
@property (nonatomic,assign) NSInteger rowNumber;


@end

static KPlayManager *_instance = nil;

@implementation KPlayManager{
    id _timeObserve;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
                
        //播放方式
        NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        
        if (defaults[@"cycle"]){
            
            NSInteger cycleDefaults = [defaults[@"cycle"] integerValue];
            _cycle = cycleDefaults;
            
        }else{
            _cycle = theSong;
        }
        //监听播放状态
        [self.player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        // 支持后台播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        // 激活
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        // 开始监控
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
    return self;
}

#pragma mark - play
- (void)playWithModel:(TracksViewModel *)tracks indexPathRow:(NSInteger ) indexPathRow{
    
    _tracksVM = tracks;
    _rowNumber = self.tracksVM.rowNumber;
    _indexPathRow = indexPathRow;
    
    //缓存播放实现，可自行查找AVAssetResourceLoader资料,或采用AudioQueue实现
    NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
    _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
    _player = [[AVPlayer alloc] initWithPlayerItem:_currentPlayerItem];
    
    [self addMusicTimeMake];
    
    _isPlay = YES;
    [_player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentPlayerItem];
    
}

-(void)addMusicTimeMake{
    __weak KPlayManager *weakSelf = self;
    //监听
    _timeObserve = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        KPlayManager *innerSelf = weakSelf;
        
        [innerSelf updateLockedScreenMusic];//控制中心
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"musicTimeInterval" object:nil userInfo:nil];//时间变化
        
    }];
}

-(void)removeMusicTimeMake{
    //[_player removeTimeObserver:_playbackObserver];
    if (_timeObserve) {
        [_player removeTimeObserver:_timeObserve];
        _timeObserve = nil;
    }
}

#pragma mark - KVO

-(void)addNotification{
    
    //给AVPlayerItem添加播放完成通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    
}

//清空播放器监听属性
- (void)releasePlayer{
    
    if (!self.currentPlayerItem) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player removeObserver:self forKeyPath:@"status"];
    
    self.currentPlayerItem = nil;
}

/** 监控播放状态 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    AVPlayer *player = (AVPlayer *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        
        NSLog(@"当前状态——%ld",(long)[player status]);
        
    }
}


#pragma mark - 接收动作

- (void)pauseMusic{
    if (!self.currentPlayerItem) {
        return;
    }
    if (_player.rate) {
        _isPlay = NO;
        [_player pause];
        
    } else {
        _isPlay = YES;
        [_player play];
        
    }
    
}

- (void)previousMusic{
    
    if (_cycle == theSong) {
        [self playPreviousMusic];
    }else if(_cycle == nextSong){
        [self playPreviousMusic];
    }else if(_cycle == isRandom){
        [self randomMusic];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:_indexPathRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCoverURL" object:nil userInfo:userInfo];
}

- (void)nextMusic{
    
    if (_cycle == theSong) {
        [self playNextMusic];
    }else if(_cycle == nextSong){
        [self playNextMusic];
    }else if(_cycle == isRandom){
        [self randomMusic];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:_indexPathRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCoverURL" object:nil userInfo:userInfo];
}

- (void)nextCycle{
    
    NSDictionary* defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    
    if (defaults[@"cycle"]) {
        
        NSInteger cycleDefaults = [defaults[@"cycle"] integerValue];
        _cycle = cycleDefaults;
        
    }else{
        _cycle = theSong;
    }
}

#pragma mark - 播放动作

-(void)playbackFinished:(NSNotification *)notification{
    
    if (_cycle == theSong) {
        [self playAgain];
    }else if(_cycle == nextSong){
        [self playNextMusic];
    }else if(_cycle == isRandom){
        [self randomMusic];
    }
    NSLog(@"开始下一首");
    [self.delegate changeMusic];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:_indexPathRow];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCoverURL" object:nil userInfo:userInfo];
    
}

- (void)playPreviousMusic{
    
    if (_currentPlayerItem){
        
        if (_indexPathRow > 0) {
            _indexPathRow--;
        }else{
            _indexPathRow = _rowNumber-1;
        }
        
        NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
        _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
        
        //[_player replaceCurrentItemWithPlayerItem:_currentPlayerItem];
        _player = [[AVPlayer alloc] initWithPlayerItem:_currentPlayerItem];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self addMusicTimeMake];
        _isPlay = YES;
        [_player play];
        
        [self.delegate changeMusic];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
        
    }
    
    
    
}

- (void)playNextMusic{
    
    if (_currentPlayerItem) {
        
        if (_indexPathRow < _rowNumber-1) {
            _indexPathRow++;
        }else{
            _indexPathRow = 0;
        }
        
        NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
        _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
        
        //[_player replaceCurrentItemWithPlayerItem:_currentPlayerItem];
        _player = [[AVPlayer alloc] initWithPlayerItem:_currentPlayerItem];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self addMusicTimeMake];
        _isPlay = YES;
        [_player play];
        
        [self.delegate changeMusic];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    }
    
}

- (void)randomMusic{
    
    if (_currentPlayerItem) {
        
        _indexPathRow = random()%_rowNumber;
        
        NSURL *musicURL = [self.tracksVM playURLForRow:_indexPathRow];
        _currentPlayerItem = [AVPlayerItem playerItemWithURL:musicURL];
        
        //[_player replaceCurrentItemWithPlayerItem:_currentPlayerItem];
        _player = [[AVPlayer alloc] initWithPlayerItem:_currentPlayerItem];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self addMusicTimeMake];
        _isPlay = YES;
        [_player play];
        
        [self.delegate changeMusic];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];
    }
}

-(void)playAgain{
    
    [_player seekToTime:CMTimeMake(0, 1)];
    _isPlay = YES;
    [_player play];
}

- (void)stopMusic{
    
}

#pragma mark - 返回

- (NSInteger )playerStatus{
    if (_currentPlayerItem.status == AVPlayerItemStatusReadyToPlay) {
        return 1;
    }else{
        return 0;
    }
}

- (NSInteger )FYPlayerCycle{
    
    return _cycle;
}

- (NSString *)playMusicName{
    return [[self.tracksVM titleForRow: _indexPathRow] copy];
    
}

- (NSString *)playSinger{
    
    return [[self.tracksVM nickNameForRow: _indexPathRow] copy];
    
}

- (NSString *)playMusicTitle{
    
    return [[self.tracksVM albumTitle] copy];
    
}

- (NSURL *)playCoverLarge{
    
    return [[self.tracksVM coverLargeURLForRow: _indexPathRow] copy];
}

- (UIImage *)playCoverImage{
    
    UIImageView *imageCoverView = [[UIImageView alloc] init];
    [imageCoverView sd_setImageWithURL:[self playCoverLarge] placeholderImage:nil];
    
    return [imageCoverView.image copy];
}

- (BOOL)havePlay{
    
    return _isPlay;
}

#pragma mark - 锁屏时候的设置，效果需要在真机上才可以看到
- (void)updateLockedScreenMusic{
    
    // 播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    // 初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] = [self playMusicName];
    // 歌手
    info[MPMediaItemPropertyArtist] = [self playSinger];
    // 歌曲名称
    info[MPMediaItemPropertyTitle] = [self playMusicTitle];
    // 设置图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[self playCoverImage]];
    // 设置持续时间（歌曲的总时间）
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem duration])] forKey:MPMediaItemPropertyPlaybackDuration];
    // 设置当前播放进度
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem currentTime])] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    // 切换播放信息
    center.nowPlayingInfo = info;
    
}

@end

