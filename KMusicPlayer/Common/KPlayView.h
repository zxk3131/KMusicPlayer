//
//  KPlayView.h
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayViewDelegate <NSObject>

- (void)playButtonDidClick:(NSInteger)index;

@end

@interface KPlayView : UIView

@property (nonatomic,weak) id<PlayViewDelegate> delegate;

@property (nonatomic,strong) UIImageView *circleIV;
@property (nonatomic,strong) UIImageView *contentIV;

@property (nonatomic,strong) UIButton *playButton;
/** 切换状态 */
- (void) setPlayButtonView;
- (void) setPauseButtonView;

@end
