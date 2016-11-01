//
//  SongListHeaderView.h
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongListHeaderView : UIView

// 头部标题
@property (nonatomic,strong) UILabel *title;
// 头像旁边标题(与头部视图text相等)
@property (nonatomic,strong) UILabel *smallTitle;
// 背景图 和 方向图
@property (nonatomic,strong)UIImageView * bgImgView;
@property (nonatomic,strong) UIImageView *zhuanjiImgView;
// 头像
@property (nonatomic,strong) UIImageView *avatarImgView;
@property (nonatomic,strong)UILabel * nameLabel;
// 描述
@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic) CGRect visualEffectFrame;

@end
