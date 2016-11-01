//
//  TabbarViewController.m
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "TabbarViewController.h"
#import "MusicViewController.h"
#import "MineViewController.h"
#import "KMainPlayViewController.h"
#import "KPlayView.h"
#import "KPlayManager.h"
#import "TracksViewModel.h"

@interface TabbarViewController ()<PlayViewDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) KPlayView *playView;
@property (nonatomic,strong) TracksViewModel *tracksVM;

@property (nonatomic,assign) NSInteger indexPathRow;
@property (nonatomic,assign) NSInteger rowNumber;

@property (nonatomic) BOOL isCan;


@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTabBarController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabBarController{
    MusicViewController * music = [MusicViewController new];
    [self controller:music title:@"音乐" image:@"" selectedimage:@""];
    
    MineViewController * mine = [MineViewController new];
    [self controller:mine title:@"我的" image:@"" selectedimage:@""];
    
    MusicViewController * item = [MusicViewController new];
    [self controller:item title:@"" image:@"" selectedimage:@""];
    
    /*播放器*/
    self.playView = [[KPlayView alloc] init];
    [self addNotification];
    
    self.playView.delegate = self;
    [self.view addSubview:_playView];
    
    [_playView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo([[UIScreen mainScreen] bounds].size.width/3);
        make.height.mas_equalTo(70);
        
        make.right.equalTo(self.view).with.offset(0);
    }];
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
}

-(void)controller:(UIViewController *)TS title:(NSString *)title image:(NSString *)image selectedimage:(NSString *)selectedimage{
    
    TS.tabBarItem.title = title;
    
    TS.tabBarItem.image = [UIImage imageNamed:image];
    TS.tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary * textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [TS.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary * selecttextAttrs = [NSMutableDictionary dictionary];
    selecttextAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [TS.tabBarItem setTitleTextAttributes:selecttextAttrs forState:UIControlStateSelected];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:TS];
    nav.delegate = self;
    [self addChildViewController:nav];
}

#pragma mark - PlayView的代理方法
- (void)playButtonDidClick:(NSInteger)index {
    
    if ([[KPlayManager sharedInstance] playerStatus]) {
        KMainPlayViewController *mainPlay = [[KMainPlayViewController alloc]initWithNibName:@"FYMainPlayController" bundle:nil];
        
        /** 自定义返回，存在问题,改用手势返回 */
        //_interactiveTransition = [[FYPercentDrivenInteractiveTransition alloc]init:mainPlay];
        //mainPlay.transitioningDelegate = self;
        
        [self presentViewController: mainPlay animated:YES completion:nil];
    }else{
        if ([[KPlayManager sharedInstance] havePlay]) {
            [MBProgressHUD show:@"歌曲加载中"];
        }else
            [MBProgressHUD show:@"尚未加载歌曲"];
    }
    
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated{
    
    if (viewController.hidesBottomBarWhenPushed) {
        
    } else {
        
        if(self.tabBar.frame.origin.y == [[UIScreen mainScreen] bounds].size.height ){
            
            [UIView animateWithDuration:0.2
                             animations:^{
                                 CGRect tabFrame = self.tabBar.frame;
                                 tabFrame.origin.y += -49;
                                 self.tabBar.frame = tabFrame;
                             }];
            self.tabBar.hidden = NO;
            
        }
        //self.playView.hidden = YES;
    }
    [super.view bringSubviewToFront:self.playView];
}

/** 添加通知 */
-(void)addNotification{
    // 控制PlayView样式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPausePlayView:) name:@"setPausePlayView" object:nil];
    // 开启一个通知接受,开始播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingWithInfoDictionary:) name:@"BeginPlay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playingInfoDictionary:) name:@"StartPlay" object:nil];
    //当前歌曲改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCoverURL:) name:@"changeCoverURL" object:nil];
    
}

#pragma mark - 消息中心
// 暂停图片
- (void)setPausePlayView:(NSNotification *)notification{
    
    if ([[KPlayManager sharedInstance] isPlay]) {
        [self.playView setPlayButtonView];
    }else{
        [self.playView setPauseButtonView];
    }
    
}


/** 通过播放地址 和 播放图片 */
- (void)playingWithInfoDictionary:(NSNotification *)notification {
    
    if (!_isCan) {
        _isCan = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dejTableInteger" object:nil userInfo:nil];
        // 设置背景图
        NSURL *coverURL = notification.userInfo[@"coverURL"];
        
        _tracksVM = notification.userInfo[@"theSong"];
        _indexPathRow = [notification.userInfo[@"indexPathRow"] integerValue];
        _rowNumber = self.tracksVM.rowNumber;
        
        [self.playView setPlayButtonView];
        
        
        UIImageView * sImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENW - 60, SCREENH - 60, 50, 50)];
        [sImgView sd_setImageWithURL:coverURL];
        [self.view addSubview:sImgView];
        sImgView.layer.cornerRadius = 25;
        sImgView.clipsToBounds = YES;
        
        [self endPlayImgView:coverURL];
    }
    
}

- (void)endPlayImgView:(NSURL *)coverURL{
    
    // 设置背景图
    [self.playView.contentIV sd_setImageWithURL:coverURL];
    self.playView.contentIV.alpha = 0.0;
    
    KPlayManager *playmanager = [KPlayManager sharedInstance];
    [playmanager playWithModel:_tracksVM indexPathRow:_indexPathRow];
    _isCan = NO;
    // 远程控制事件 Remote Control Event
    // 加速计事件 Motion Event
    // 触摸事件 Touch Event
    // 开始监听远程控制事件
    // 成为第一响应者（必备条件）
    [self becomeFirstResponder];
    
}

- (void)playingInfoDictionary:(NSNotification *)notification {
    
    // 设置背景图
    NSURL *coverURL = notification.userInfo[@"coverURL"];
    
    _tracksVM = notification.userInfo[@"theSong"];
    _indexPathRow = [notification.userInfo[@"indexPathRow"] integerValue];
    _rowNumber = self.tracksVM.rowNumber;
    
    [self.playView setPlayButtonView];
    
    [self.playView.contentIV sd_setImageWithURL:coverURL];
    self.playView.contentIV.alpha = 0.0;
    
    
    KPlayManager *playmanager = [KPlayManager sharedInstance];
    [playmanager playWithModel:_tracksVM indexPathRow:_indexPathRow];
    _isCan = NO;
    // 远程控制事件 Remote Control Event
    // 加速计事件 Motion Event
    // 触摸事件 Touch Event
    // 开始监听远程控制事件
    // 成为第一响应者（必备条件）
    [self becomeFirstResponder];
    
}

- (void)changeCoverURL:(NSNotification *)notification {
    
    // 设置背景图
    NSURL *coverURL = notification.userInfo[@"coverURL"];
    
    [self.playView.contentIV sd_setImageWithURL:coverURL];
    self.playView.contentIV.alpha = 0.0;
    
    //修改透明度
    CABasicAnimation * alphaBaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaBaseAnimation.fillMode = kCAFillModeForwards;//不恢复原态
    alphaBaseAnimation.duration = 1.0;
    alphaBaseAnimation.removedOnCompletion = NO;
    [alphaBaseAnimation setToValue:[NSNumber numberWithFloat:1.0]];
    alphaBaseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];//决定动画的变化节奏
    
    [self.playView.contentIV.layer addAnimation:alphaBaseAnimation forKey:[NSString stringWithFormat:@"%ld",(long)self.playView.contentIV]];
    
}

#pragma mark - 远程控制事件监听
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    //    event.type; // 事件类型
    //    event.subtype; // 事件的子类型
    //    UIEventSubtypeRemoteControlPlay                 = 100,
    //    UIEventSubtypeRemoteControlPause                = 101,
    //    UIEventSubtypeRemoteControlStop                 = 102,
    //    UIEventSubtypeRemoteControlTogglePlayPause      = 103,
    //    UIEventSubtypeRemoteControlNextTrack            = 104,
    //    UIEventSubtypeRemoteControlPreviousTrack        = 105,
    //    UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
    //    UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
    //    UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
    //    UIEventSubtypeRemoteControlEndSeekingForward    = 109,
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [[KPlayManager sharedInstance] pauseMusic];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [[KPlayManager sharedInstance] nextMusic];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [[KPlayManager sharedInstance] previousMusic];
            
        default:
            break;
    }
}


# pragma mark - HUD

- (void)dealloc {
    // 关闭消息中心
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[KPlayManager sharedInstance] releasePlayer];
    
    NSLog(@"play dealloc");
}

@end
