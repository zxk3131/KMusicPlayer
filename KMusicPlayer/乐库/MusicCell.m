//
//  MusicCell.m
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "MusicCell.h"

@interface MusicCell ()

@property (nonatomic,strong) UIImageView *coverImgVIew;
@property (nonatomic,strong) UILabel *titleLb;
// 作者
@property (nonatomic,strong) UILabel *introLb;
// 播放次数
@property (nonatomic,strong) UILabel *playsLb;
// 集数
@property (nonatomic,strong) UILabel *tracksLb;

@end

@implementation MusicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 右箭头风格
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // 分割线缩短
        self.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewModel:(MoreContentViewModel *)viewModel{
    _viewModel = viewModel;
    [self.coverImgVIew sd_setImageWithURL:[viewModel coverURLForIndexPath:self.indexPath] placeholderImage:nil];
    
    self.titleLb.text = [viewModel titleForIndexPath:self.indexPath];
    self.introLb.text = [viewModel subTitleForIndexPath:self.indexPath];
    self.playsLb.text = [viewModel playsForIndexPath:self.indexPath];
    self.tracksLb.text = [viewModel tracksForIndexPath:self.indexPath];
}

- (UIImageView *)coverImgVIew {
    if (!_coverImgVIew) {
        // 框框背景图
        _coverImgVIew = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"findradio_bg"]];
        [self.contentView addSubview:_coverImgVIew];
        [_coverImgVIew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(60);
        }];
    }
    return _coverImgVIew;
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [UILabel new];
        [self.contentView addSubview:_titleLb];
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.mas_equalTo(self.coverImgVIew.mas_right).mas_equalTo(12);
            make.right.mas_equalTo(-10);
        }];
        _titleLb.font = [UIFont systemFontOfSize:14];
        
    }
    return _titleLb;
}
- (UILabel *)introLb {
    if (!_introLb) {
        _introLb = [UILabel new];
        [self.contentView addSubview:_introLb];
        [_introLb mas_makeConstraints:^(MASConstraintMaker *make) {
            // 照片中间
            make.centerY.mas_equalTo(self.coverImgVIew);
            make.leadingMargin.mas_equalTo(self.titleLb);
            make.right.bottom.mas_equalTo(-10);
        }];
        _introLb.textColor = [UIColor lightGrayColor];
        _introLb.font = [UIFont systemFontOfSize:12];
    }
    return _introLb;
}
// 播放数
- (UILabel *)playsLb {
    if (!_playsLb) {
        _playsLb = [UILabel new];
        [self.contentView addSubview:_playsLb];
        
        [_playsLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leadingMargin.mas_equalTo(self.titleLb);
            make.bottom.mas_equalTo(-10);
            make.width.mas_lessThanOrEqualTo(100);
        }];
        _playsLb.textColor = [UIColor lightGrayColor];
        _playsLb.font = [UIFont systemFontOfSize:11];
    }
    return _playsLb;
}

// 集数
- (UILabel *)tracksLb {
    if (!_tracksLb) {
        _tracksLb = [UILabel new];
        [self.contentView addSubview:_tracksLb];
        
        [_tracksLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.playsLb.mas_right).mas_equalTo(20);
            make.bottom.mas_equalTo(-10);
            make.width.mas_lessThanOrEqualTo(100);
        }];
        _tracksLb.textColor = [UIColor lightGrayColor];
        _tracksLb.font = [UIFont systemFontOfSize:11];
        
    }
    return _tracksLb;
}

@end
