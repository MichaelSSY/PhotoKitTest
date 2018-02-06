//
//  YZImageCollectionViewController.m
//  PhotoTest
//
//  Created by weiyun on 2018/2/1.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "YZImageCollectionViewController.h"
#import "YZImagePickerController.h"
#import "Config.h"
#import "PhotoCollectionViewCell.h"

@interface YZImageCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) PHFetchResult *assets;
@property (nonatomic , strong) UICollectionView *collectionView;
@end

@implementation YZImageCollectionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // NSLog(@"1");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = cancel;

    self.currentIndex = [YZAssetHelper sharedAssetHealer].currentGroupIndex;
    self.title = [YZAssetHelper sharedAssetHealer].albumNameArr[self.currentIndex];
    
    self.assets = [YZAssetHelper sharedAssetHealer].albumAssetsArr[self.currentIndex];
    
    [self setCollectionView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor redColor];
    
    [[YZAssetHelper sharedAssetHealer] adjustGIFWithAsset2:self.assets[indexPath.row]];

    cell.photoImageView.image = [[YZAssetHelper sharedAssetHealer] getAlbumPhoto:self.assets index:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)setCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.minimumInteritemSpacing = itemSpace;
    layout.minimumLineSpacing = itemSpace;
    layout.sectionInset = UIEdgeInsetsMake(itemSpace, itemSpace, itemSpace, itemSpace);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize = CGSizeMake(0, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    // 当数据不多，不够一屏幕时也可以滑动，默认NO
    collectionView.alwaysBounceVertical = YES;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    
    _collectionView = collectionView;
 
    [_collectionView setContentOffset:CGPointMake(0, [[YZAssetHelper sharedAssetHealer] getCollectionContentHeight:_assets.count] + 64 - _collectionView.frame.size.height) animated:YES];
}

- (void)cancel
{
    [(YZImagePickerController *)self.navigationController cancel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
