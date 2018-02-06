//
//  SmartAlbumTableViewController.m
//  PhotoTest
//
//  Created by weiyun on 2018/2/1.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "SmartAlbumTableViewController.h"
#import "Config.h"

@interface SmartAlbumTableViewController ()
@property (nonatomic , strong) PHImageRequestOptions *options;
@property (nonatomic, strong) NSMutableArray *albumNameArr; ///< 相册名称
@property (nonatomic, strong) NSMutableArray *albumAssetsArr; ///< 相册数组
@end

@implementation SmartAlbumTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.albumNameArr = [NSMutableArray array];
    self.albumAssetsArr = [NSMutableArray array];

    self.tableView.rowHeight = 80;
    
    [self getSmartAlbumData];
    
}
- (void)getSmartAlbumData
{
    /*
     1、首次加载APP时出现的问题：仅会获取相应的权限 而不会响应方法
     */
    // 每次访问相册都会调用这个handler  检查改app的授权情况
    // PHPhotoLibrary
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            //code
        }
    }];
    
    self.options = [[PHImageRequestOptions alloc] init];//请求选项设置
    self.options.resizeMode = PHImageRequestOptionsResizeModeExact;//自定义图片大小的加载模式
    self.options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.options.synchronous = YES;//是否同步加载
    
    /*
     2、获取所有图片（注意不能在胶卷中获取图片，因为胶卷中的图片包含了video的显示图）
     */  
    // [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];//这样获取
    
    /*
     3、使用PHImageManager请求时的回调同步or异步时、block回调次数的问题
     */
    
    /*
     4、回调得出的图片size的问题: 由3个参数决定
     */
    /*
     在ShowAlbumViewController 中观察
     
     在PHImageContentModeAspectFill 下  图片size 有一个分水岭  {125,125}   {126,126}
     当imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
     时: 设置size 小于{125,125}时，你得到的图片size 将会是设置的1/2
     
     而在PHImageContentModeAspectFit 分水岭  {120,120}   {121,121}
     */
    
    
    /*
     5、回调中info字典key消失的问题: 当最终获取到的图片的size的高／宽没有一个能达到原有的图片size的高／宽时 部分key 会消失
     */
    
    
    //    PHAsset 用户照片库中一个单独的资源，简单而言就是单张图片或者视音频的元数据吧
    
    //    PHAsset 组合而成 PHAssetCollection(PHCollection)   一个单独的资源集合(PHAssetCollection)可以是照片库中相簿中一个相册或者照片中一个时刻，或者是一个特殊的“智能相册”。这种智能相册包括所有的视频集合，最近添加的项目，用户收藏，所有连拍照片等
    
    //    PHCollectionList 则是包含PHAssetCollection的PHAssetCollection。因为它本身就是 PHCollection，所以集合列表可以包含其他集合列表，它们允许复杂的集合继承。例子：年度->精选->时刻
    
    //    PHFetchResult 某个系列（PHAssetCollection）或者是相册（PHAsset）的返回结果，一个集合类型，PHAsset 或者 PHAssetCollection 的类方法均可以获取到
    
    //    PHImageManager 处理图片加载，加载图片过程有缓存处理
    
    //    PHImageManager(PHImageManager的抽象) 处理图像的整个加载过程的缓存 要加载大量资源的缩略图时可以使用该类的startCachingImage... 预先将一些图像加载到内存中，达到预先缓冲的效果
    
    //    PHImageRequestOptions 设置加载图片方式的参数()
    
    //    PHFetchOptions 集合资源的配置方式（按一定的(时间)顺序对资源进行排列、隐藏/显示某一个部分的资源集合）
    
    
    
    
    /*
     PHAssetCollectionTypeMoment      Moment中
     PHAssetCollectionTypeAlbum       用户创建的相册
     PHAssetCollectionTypeSmartAlbum  系统相册中//系统本来就拥有的相册 如Favorites、Videos、Camera Roll等
     */
    /*
     // PHAssetCollectionTypeAlbum regular subtypes
     PHAssetCollectionSubtypeAlbumRegular         = 2,
     PHAssetCollectionSubtypeAlbumSyncedEvent     = 3,
     PHAssetCollectionSubtypeAlbumSyncedFaces     = 4,
     PHAssetCollectionSubtypeAlbumSyncedAlbum     = 5,
     PHAssetCollectionSubtypeAlbumImported        = 6,
     
     // PHAssetCollectionTypeAlbum shared subtypes
     PHAssetCollectionSubtypeAlbumMyPhotoStream   = 100,//照片流
     PHAssetCollectionSubtypeAlbumCloudShared     = 101,//iCloud 分享
     
     // PHAssetCollectionTypeSmartAlbum subtypes
     PHAssetCollectionSubtypeSmartAlbumGeneric    = 200,//一般
     PHAssetCollectionSubtypeSmartAlbumPanoramas  = 201,//全景
     PHAssetCollectionSubtypeSmartAlbumVideos     = 202,//视频
     PHAssetCollectionSubtypeSmartAlbumFavorites  = 203,//收藏
     PHAssetCollectionSubtypeSmartAlbumTimelapses = 204,//定时拍摄
     PHAssetCollectionSubtypeSmartAlbumAllHidden  = 205,//
     PHAssetCollectionSubtypeSmartAlbumRecentlyAdded = 206,//最近添加
     PHAssetCollectionSubtypeSmartAlbumBursts     = 207,//连拍
     PHAssetCollectionSubtypeSmartAlbumSlomoVideos = 208,//慢动作视频
     PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209,//用户相册
     PHAssetCollectionSubtypeSmartAlbumSelfPortraits NS_AVAILABLE_IOS(9_0) = 210,   //头像\肖像
     PHAssetCollectionSubtypeSmartAlbumScreenshots NS_AVAILABLE_IOS(9_0) = 211,     //截屏
     // Used for fetching, if you don't care about the exact subtype
     PHAssetCollectionSubtypeAny = NSIntegerMax
     */

    // 获取系统设置的相册信息(其实也不完全  譬如没有<照片流>等)
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];

    for (PHAssetCollection *collection in smartAlbums) {
        PHFetchResult *results = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        // NSLog(@"相册名:%@，有%ld张图片",collection.localizedTitle,results.count);
        [self.albumNameArr addObject:collection.localizedTitle];//存储assets's名字
        [self.albumAssetsArr addObject:results];//存储assets's内容
    }
    
    // 用户自定义的资源
    PHFetchResult *customCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *collection in customCollections) {
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        [self.albumNameArr addObject:collection.localizedTitle];
        [self.albumAssetsArr addObject:assets];
    }
    
    //如果要添加照片流 可以打开此下的注释
//    PHFetchResult *stream = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
//    for (PHAssetCollection *collection in stream) {
//        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
//        [self.albumNameArr addObject:collection.localizedTitle];
//        [self.albumAssetsArr addObject:assets];
//    }
    
    self.title = [NSString stringWithFormat:@"共有 %zd 个相册",self.albumNameArr.count];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumNameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"SmartAlbumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.albumNameArr[indexPath.row];
    PHFetchResult *assets = self.albumAssetsArr[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld张",assets.count];
    
    if (assets.count > 0) {
        [[PHImageManager defaultManager] requestImageForAsset:[assets lastObject] targetSize: CGSizeMake(300, 300) contentMode:PHImageContentModeAspectFill options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.imageView.image = result;
        }];
    }else{
        // 防止cell重用问题
        cell.imageView.image = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
