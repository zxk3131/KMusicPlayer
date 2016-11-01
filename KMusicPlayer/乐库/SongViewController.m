//
//  SongViewController.m
//  KMusicPlayer
//
//  Created by 赵祥凯 on 16/11/1.
//  Copyright © 2016年 zxk. All rights reserved.
//

#import "SongViewController.h"
#import "SongListHeaderView.h"
#import "MusicDetailCell.h"
#import "TracksViewModel.h"

@interface SongViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SongListHeaderView  *infoView;
@property (nonatomic,strong) TracksViewModel *tracksVM;


// 升序降序标签: 默认升序
@property (nonatomic,assign) BOOL isAsc;
@end

@implementation SongViewController

- (instancetype)initWithAlbumId:(NSInteger)albumId title:(NSString *)oTitle {
    if (self = [super init]) {
        _albumId = albumId;
        _oTitle = oTitle;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initHeaderView];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - tableView懒加载
- (TracksViewModel *)tracksVM {
    if (!_tracksVM) {
        _tracksVM = [[TracksViewModel alloc] initWithAlbumId:_albumId title:_oTitle isAsc:!_isAsc];
    }
    return _tracksVM;
}

- (UITableView *)tableView {
    if (!_tableView) {
        // 设置普通模式
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[MusicDetailCell class] forCellReuseIdentifier:@"cell"];
        
        _tableView.rowHeight = 80;
        
    }
    return _tableView;
}

- (void)initHeaderView{
    _infoView = [[SongListHeaderView alloc] init];
    self.tableView.tableHeaderView = _infoView;
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@120);
    }];
    
    [self.tracksVM getDataCompletionHandle:^(NSError *error) {
        [self.tableView reloadData];
        // 刷新成功时候才作的方法
        // 顶头标题
        _infoView.title.text = self.tracksVM.albumTitle;
        [_infoView.avatarImgView sd_setImageWithURL:self.tracksVM.albumCoverURL placeholderImage:nil];
        
        // 昵称及头像
        _infoView.nameLabel.text = self.tracksVM.albumNickName;
        [_infoView.avatarImgView sd_setImageWithURL:self.tracksVM.albumIconURL placeholderImage:nil];
        
        //判断?成功返回值:失败返回值
        _infoView.descLabel.text = self.tracksVM.albumDesc.length == 0 ? @"暂无简介": self.tracksVM.albumDesc  ;
    }];
}

#pragma mark - UITableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracksVM.rowNumber;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MusicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    cell.indexPath = indexPath;
    cell.viewModel = self.tracksVM;
    
    return cell;
}

// 点击行数  实现听歌功能
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 当前播放信息
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"coverURL"] = [self.tracksVM coverURLForRow:indexPath.row];
    userInfo[@"musicURL"] = [self.tracksVM playURLForRow:indexPath.row];
    //有些地址不能正确显示图片，搞不懂
    //NSLog(@"%@",[self.tracksVM coverURLForRow:indexPath.row]);
    
    NSInteger indexPathRow = indexPath.row;
    NSNumber *indexPathRown = [[NSNumber alloc]initWithInteger:indexPathRow];
    userInfo[@"indexPathRow"] = indexPathRown;
    
    //专辑
    userInfo[@"theSong"] = _tracksVM;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BeginPlay" object:nil userInfo:[userInfo copy]];
}

- (void)dealloc {
    NSLog(@"song dealloc");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
