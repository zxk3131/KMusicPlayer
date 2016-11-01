//
//  MusicViewController.m
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "MusicViewController.h"
#import "KPlayManager.h"
#import "MoreContentViewModel.h"
#import "MusicCell.h"
#import "MusicCellHeaderView.h"
#import "SongViewController.h"

@interface MusicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) MoreContentViewModel *moreVM;
@property (nonatomic,weak)UITableView * tableView;

@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    [self.moreVM getDataCompletionHandle:^(NSError *error) {
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.moreVM.sectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.moreVM rowForSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MusicCellHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    header.title = [self.moreVM mainTitleForSection:section];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.indexPath = indexPath;
    cell.viewModel = self.moreVM;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 从本控制器VM获取头标题, 以及分类ID回初始化
    SongViewController *vc = [[SongViewController alloc] initWithAlbumId:[self.moreVM albumIdForIndexPath:indexPath] title:[self.moreVM titleForIndexPath:indexPath]];
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (MoreContentViewModel *)moreVM {
    if (!_moreVM) {
        _moreVM = [[MoreContentViewModel alloc] initWithCategoryId:2 contentType:@"album"];
    }
    return _moreVM;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView * table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        table.delegate = self;
        table.dataSource = self;
        
        [table registerClass:[MusicCell class] forCellReuseIdentifier:@"cell"];
        [table registerClass:[MusicCellHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
        
        [self.view addSubview:table];
        _tableView = table;
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _tableView;
}

@end
