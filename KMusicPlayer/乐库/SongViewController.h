//
//  SongViewController.h
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongViewController : UIViewController

// 选择接受外界title, 以及albumId 初始化
- (instancetype)initWithAlbumId:(NSInteger)albumId title:(NSString *)oTitle;

@property (nonatomic,assign) NSInteger albumId;
@property (nonatomic,strong) NSString *oTitle;

@end
