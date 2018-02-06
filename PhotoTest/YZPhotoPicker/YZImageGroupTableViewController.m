//
//  YZImageGroupTableViewController.m
//  PhotoTest
//
//  Created by weiyun on 2018/2/1.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "YZImageGroupTableViewController.h"
#import "YZImageCollectionViewController.h"
#import "YZImagePickerController.h"
#import "Config.h"

@interface YZImageGroupTableViewController ()

@end

@implementation YZImageGroupTableViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"照片";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = cancel;
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tableView.rowHeight = 70;
    self.tableView.tableFooterView = [UIView new];
    
    [YZAssetHelper sharedAssetHealer].currentGroupIndex = 0;
    YZImageCollectionViewController *vc = [[YZImageCollectionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    
}

- (void)cancel{
    [(YZImagePickerController *)self.navigationController cancel];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[YZAssetHelper sharedAssetHealer] getGroupCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [YZAssetHelper sharedAssetHealer].albumNameArr[indexPath.row];
    
    PHFetchResult *assets = [YZAssetHelper sharedAssetHealer].albumAssetsArr[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld张",assets.count];
    // 取最新的一张照片
    cell.imageView.image = [[YZAssetHelper sharedAssetHealer] getAlbumPhoto:assets index:assets.count - 1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [YZAssetHelper sharedAssetHealer].currentGroupIndex = indexPath.row;
    YZImageCollectionViewController *picker = [[YZImageCollectionViewController alloc] init];
    [self.navigationController pushViewController:picker animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
