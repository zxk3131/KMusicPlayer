//
//  BaseViewModel.m
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

/**  取消任务 */
- (void)cancelTask {
    [self.dataTask cancel];
}
/**  暂停任务 */
- (void)suspendTask {
    [self.dataTask suspend];
}
/**  继续任务 */
- (void)resumeTask {
    [self.dataTask resume];
}

@end
