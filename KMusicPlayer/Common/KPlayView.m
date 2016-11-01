//
//  KPlayView.m
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "KPlayView.h"

@implementation KPlayView

- (instancetype)init{
    if (self = [super init]) {
        UIView *backView = [[UIView alloc]init];
        //backView.backgroundColor = [UIColor greenColor];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(SCREENW/3);
            make.height.mas_equalTo(49);
            
            make.right.equalTo(self).with.offset(0);
        }];
        
        // 布局
        UIView *backgoundIV = [[UIView alloc] init];
        [self addSubview:backgoundIV];
        [backgoundIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(85);
            make.height.mas_equalTo(70);
            
            make.right.equalTo(self).with.offset(0);
        }];
        
        _circleIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_np_loop"]];
        [backgoundIV addSubview:_circleIV];
        [_circleIV mas_makeConstraints:^(MASConstraintMaker *make){
            
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(70);
            
            make.right.equalTo(self).with.offset(0);
        }];
        
        [self.playButton setImage:[UIImage imageNamed:@"tabbar_np_play"] forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(touchPlayButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBackView:)];
        _circleIV.tag = 100;
        [_circleIV addGestureRecognizer:tap];
        
        // 设置circle的用户交互
        _circleIV.userInteractionEnabled = YES;
    }
    return self;
}

//- (UIImageView *)contentIV {
//    if (!_contentIV) {
//        // 声明一个内容视图, 并约束好位置
//        _contentIV = [[UIImageView alloc] init];
//        // 绑定到圆视图
//        [_circleIV addSubview:_contentIV];
//        [_contentIV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
//        }];
//        // KVO观察image变化, 变化了就初始化定时器, 值变化则执行task, BlockKit框架对通知的一个拓展
//        [_contentIV bk_addObserverForKeyPath:@"image" options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
//            // 启动定时器
//        }];
//        // 作圆内容视图背景
//        _contentIV.layer.cornerRadius = 22;
//        _contentIV.clipsToBounds = YES;
//    }
//    return _contentIV;
//}

- (UIButton *)playButton {
    
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setHighlighted:NO];// 去掉长按高亮
        _playButton.tag = 101;
        [self  addSubview:_playButton];
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(70);
        }];
    }
    
    return _playButton;
}

- (void)setPlayButtonView{
    
    [self.playButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.playButton setImage:nil forState:UIControlStateNormal];
}

- (void)setPauseButtonView{
    
    [self.playButton setBackgroundImage:[UIImage imageNamed:@"avatar_bg"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"toolbar_play_h_p"] forState:UIControlStateNormal];
}

-(void)touchPlayButton:(UIButton *)sender{
    
    int tag = (int)sender.tag-100;
    [self.delegate playButtonDidClick:tag];
}

-(void)OnTapBackView:(UITapGestureRecognizer *)sender//点击触发 手势
{
    UIView *backView = (UIView *)sender.view;
    int tag = (int)backView.tag-100;
    [self.delegate playButtonDidClick:tag];
}

@end
