//
//  AllPhotoViewController.m
//  PhotoTest
//
//  Created by weiyun on 2018/2/1.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "AllPhotoViewController.h"
#import "Config.h"
#import "PhotoCollectionViewCell.h"

@interface AllPhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic , strong) PHImageRequestOptions *options;
@property (nonatomic , strong) PHFetchResult<PHAsset *> *assets;
@property (nonatomic , strong) UICollectionView *collectionView;
@end

@implementation AllPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"照片";
    
    [self setCollectionView];
    [self getAllPhotoFromAlbum];
}

/** 从相册获取所有照片 */
- (void)getAllPhotoFromAlbum
{
    // 1.请求选项设置
    self.options = [[PHImageRequestOptions alloc] init];
    self.options.resizeMode = PHImageRequestOptionsResizeModeExact;//自定义图片大小的加载模式
    self.options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.options.synchronous = NO;// 是否同步加载
    
    // 2.容器类
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    self.assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:fetchOptions];
    
    /*
     PHAssetMediaType：
     PHAssetMediaTypeUnknown = 0,//在这个配置下，请求不会返回任何东西
     PHAssetMediaTypeImage   = 1,//图片
     PHAssetMediaTypeVideo   = 2,//视频
     PHAssetMediaTypeAudio   = 3,//音频
     */
    
    //NSLog(@"----%zd",self.assets.count);
    
    // 3.刷新collectionView
    [self.collectionView reloadData];
  
    // 4.开启直接回到底部
    //[self setCollectionView];
}

// 设置collectionView直接回到底部
- (void)setCollectionViewContentOff
{
    // collectionView里面item个数，加一个item用来放相机
    // 直接定位到collectionView底部 加上导航栏高度 64
    [self.collectionView setContentOffset:CGPointMake(0, [[YZAssetHelper sharedAssetHealer] getCollectionContentHeight:_assets.count+1] + 64 - self.collectionView.frame.size.height) animated:YES];

    // 注意：下面这个方法不需要上面的计算直接到底部，但是图片加载有延迟，可能体验不好。可能是我代码添加的地方不对吧，如果您实现了，可以评论告诉我哈。
    // [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.frame.size.height) animated:YES];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 这里是把相机放在第一个位置，想放在最后一个位置的话设置 indexPath.row == self.assets.count
    if (indexPath.row == 0) {
        
        CameraCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CameraCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor redColor];
        return cell;
    }else{
        PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor redColor];
        
        // 这里是把相机放在第一个位置，想放在最后一个位置的话设置 index = self.assets.count
        NSInteger index = (self.assets.count - 1) - (indexPath.row - 1);
        
        //9.0可用
        CGSizeMake(self.assets[index].pixelWidth, self.assets[index].pixelHeight);
        
        [[YZAssetHelper sharedAssetHealer] adjustGIFWithAsset2:self.assets[index]];
        cell.photoImageView.image = [[YZAssetHelper sharedAssetHealer] getAlbumPhoto:self.assets index:index];
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    // 这里是把相机放在第一个位置，想放在最后一个位置的话设置 indexPath.row == self.assets.count
    if (indexPath.item == 0) {
        // 调起相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }else{
            NSLog(@"打开相机失败！！");
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate,UINavigationControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //保存图片到本地相册（不想保存就注释掉下面代码）
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//保存图片到本地相册 回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error != NULL){
        NSLog(@"保存图片失败");
    }else NSLog(@"保存图片成功");
}

- (void)setCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //单元格（每一项）的大小（宽高）
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    //最小格间距（每个单元格之间的最小间距）
    layout.minimumInteritemSpacing = itemSpace;
    //最小行间距
    layout.minimumLineSpacing = itemSpace;
    //分区之间的边距
    layout.sectionInset = UIEdgeInsetsMake(itemSpace, itemSpace, itemSpace, itemSpace);
    //设置滚动的方法(Vertical竖向)
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize = CGSizeMake(0, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    [collectionView registerClass:[CameraCollectionViewCell class] forCellWithReuseIdentifier:@"CameraCell"];
    
    _collectionView = collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
