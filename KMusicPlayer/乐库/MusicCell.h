//
//  MusicCell.h
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreContentViewModel.h"

@interface MusicCell : UITableViewCell

@property(nonatomic,strong)MoreContentViewModel * viewModel;
@property(nonatomic,strong)NSIndexPath * indexPath;

@end
