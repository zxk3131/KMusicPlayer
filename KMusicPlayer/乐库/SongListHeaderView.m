//
//  SongListHeaderView.m
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "SongListHeaderView.h"

@interface SongListHeaderView()

@property (strong, nonatomic) UIVisualEffectView *visualEffectView;


@end

@implementation SongListHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 用户交互
        self.userInteractionEnabled = YES;
        self.bgImgView.image = [UIImage imageNamed:@"bg_albumView_header"];
        
        if(![_visualEffectView isDescendantOfView:self]) {
            UIVisualEffect *blurEffect;
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            _visualEffectView.frame = CGRectMake(0, 0, SCREENW, frame.size.height+20);
            [self addSubview:_visualEffectView];
        }
    }
    return self;
}

- (void)setVisualEffectFrame:(CGRect)visualEffectFrame{
    
    CGFloat height = visualEffectFrame.size.height;
    _visualEffectView.frame = CGRectMake(0, 0, SCREENW, height);
}

#pragma mark - 各个控件的懒加载

- (UILabel *)title {
    if (!_title) {
        _title = [UILabel new];
        [self addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(0);
            make.top.equalTo(@20);
            make.width.mas_lessThanOrEqualTo(250);
        }];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont boldSystemFontOfSize:18];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (UIImageView *)zhuanjiImgView {
    if (!_zhuanjiImgView) {
        _zhuanjiImgView = [UIImageView new];
        [self addSubview:_zhuanjiImgView];
        [_zhuanjiImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 100));
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.title.mas_bottom).mas_equalTo(15);
        }];
    }
    return _zhuanjiImgView;
}

- (UIImageView *)avatarImgView {
    if (!_avatarImgView) {
        _avatarImgView = [UIImageView new];
        [self addSubview:_avatarImgView];
        [_avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.topMargin.mas_equalTo(self.avatarImgView);
            make.left.mas_equalTo(self.avatarImgView.mas_right).mas_equalTo(10);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        
    }
    return _avatarImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.avatarImgView);
            make.left.equalTo(self.avatarImgView.mas_right).offset(6);
            make.right.mas_greaterThanOrEqualTo(10);
        }];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [UILabel new];
        [self addSubview:_descLabel];
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImgView).offset(10);
            make.leadingMargin.mas_equalTo(self.avatarImgView);
            // 可能根据字体来设置
            make.right.mas_equalTo(-10);
        }];
        _descLabel.numberOfLines = 0;
        _descLabel.font = [UIFont systemFontOfSize:18];
        _descLabel.textColor = [UIColor whiteColor];
        _descLabel.text = @"暂无简介";
    }
    return _descLabel;
}
@end
