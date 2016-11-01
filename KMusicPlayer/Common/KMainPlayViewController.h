//
//  KMainPlayViewController.h
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMainPlayViewController : UIViewController

@property (nonatomic,strong) NSString *musicTitle;
@property (nonatomic,strong) NSString *musicName;
@property (nonatomic,strong) NSString *singer;

@property (nonatomic,strong) NSURL *coverLarge;

@end
