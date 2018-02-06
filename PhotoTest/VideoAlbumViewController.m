//
//  VideoAlbumViewController.m
//  PhotoTest
//
//  Created by weiyun on 2018/2/2.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "VideoAlbumViewController.h"
#import "Config.h"
#import "PhotoCollectionViewCell.h"
#import <AVKit/AVKit.h>   // 包含类 AVPlayerViewController
#import <AVFoundation/AVFoundation.h>  // 包含类 AVPlayer

@interface VideoAlbumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong) PHFetchResult<PHAsset *> *assets;
@property (nonatomic , strong) PHVideoRequestOptions *options;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) AVPlayerViewController *aVPlayerViewController;

@end

@implementation VideoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setCollectionView];
    [self getAlbumVideoData];
}

- (void)getAlbumVideoData
{
    // PHFetchOptions中的谓词过滤获取
    PHFetchOptions *fetchOption = [[PHFetchOptions alloc] init];
    // 其中：key是PHAsset类的属性   这是一个KVC
    fetchOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:true]];
    //fetchOption.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeVideo];
    //self.assets = [PHAsset fetchAssetsWithOptions:fetchOption];
    
    self.assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:fetchOption];
    
    self.options = [[PHVideoRequestOptions alloc] init];
    self.options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    [self.options setNetworkAccessAllowed:true];
    
    self.title = [NSString stringWithFormat:@"共有 %zd 个视频",self.assets.count];

    [_collectionView reloadData];
    
    [_collectionView setContentOffset:CGPointMake(0, [[YZAssetHelper sharedAssetHealer] getCollectionContentHeight:_assets.count] + 64 - _collectionView.frame.size.height) animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor redColor];
    
    cell.photoImageView.image = [[YZAssetHelper sharedAssetHealer] getAlbumPhoto:self.assets index:indexPath.row];
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:self.assets[indexPath.row] options:self.options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        // asset为AVURLAsset类型  可直接获取相应视频的相对地址
        Float64 duration = CMTimeGetSeconds(asset.duration);
        // 四舍五入
        NSInteger timeD = round(duration);
        // 务必放在主线程中刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.timeLabel.text = [[YZAssetHelper sharedAssetHealer] timeFromSeconds:timeD];
        });
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:self.assets[indexPath.item] options:self.options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *URL = ((AVURLAsset*)asset).URL;
            _aVPlayerViewController = [[AVPlayerViewController alloc]init];
            _aVPlayerViewController.player = [[AVPlayer alloc]initWithURL:URL];
            [self presentViewController:_aVPlayerViewController animated:YES completion:nil];
            
            // 下面就是由.MOV转.mp4格式，然后存储到本地，上传到服务器，这里就不做详细解释了，很简单
            // 转换成data
            //NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
//            [[YZAssetHelper sharedAssetHealer] convertVideoQuailtyWithInputURL:URL outputURL:[NSURL URLWithString:@"path"] completeHandler:^(AVAssetExportSession *s) {
//
//            }];
        });
    }];
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
    collectionView.alwaysBounceVertical = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"VideoCell"];
    
    _collectionView = collectionView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
