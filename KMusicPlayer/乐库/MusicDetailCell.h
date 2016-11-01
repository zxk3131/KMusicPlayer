//
//  MusicDetailCell.h
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TracksViewModel.h"

@interface MusicDetailCell : UITableViewCell

@property (nonatomic,strong)NSIndexPath * indexPath;
@property (nonatomic,strong)TracksViewModel * viewModel;

@end
