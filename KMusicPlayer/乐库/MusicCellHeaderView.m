//
//  MusicCellHeaderView.m
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "MusicCellHeaderView.h"

@implementation MusicCellHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.titleLb setTextColor:[UIColor blackColor]];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLb.text = title;
}

- (UILabel *)titleLb {
    
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [self addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(180);
        }];
        _titleLb.font = [UIFont systemFontOfSize:13];
        _titleLb.text = _title;
    }
    return _titleLb;
}

@end
