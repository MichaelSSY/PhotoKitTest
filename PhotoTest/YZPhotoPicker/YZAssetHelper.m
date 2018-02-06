//
//  YZAssetHelper.m
//  PhotoTest
//
//  Created by weiyun on 2018/2/2.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "YZAssetHelper.h"

@interface YZAssetHelper ()
@property (nonatomic, strong) PHImageRequestOptions *options;

@end

@implementation YZAssetHelper
+ (instancetype)sharedAssetHealer
{
    static YZAssetHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[YZAssetHelper alloc] init];
        [_sharedInstance getAlbumArray];
    });
    
    return _sharedInstance;
}

- (void)getAlbumArray
{
    _albumAssetsArr = [NSMutableArray array];
    _albumNameArr = [NSMutableArray array];
    
    // 1.请求选项设置
    _options = [[PHImageRequestOptions alloc] init];
    _options.resizeMode = PHImageRequestOptionsResizeModeExact;//自定义图片大小的加载模式
    _options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    _options.synchronous = YES;//是否同步加载
    
    /*
     2、获取所有图片（注意不能在胶卷中获取图片，因为胶卷中的图片包含了video的显示图）
     */
    [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];//这样获取
    
    // 3.获取系统设置的相册信息(其实也不完全  譬如没有<照片流>等)
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    //NSLog(@"系统相册的数目 = %ld",smartAlbums.count);
    for (PHAssetCollection *collection in smartAlbums) {
        PHFetchResult *results = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        //NSLog(@"相册名:%@，有%ld张图片",collection.localizedTitle,results.count);
        [_albumNameArr addObject:collection.localizedTitle];//存储assets's名字
        [_albumAssetsArr addObject:results];//存储assets's内容
    }
    
    // 4.用户自定义的资源
    PHFetchResult *customCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in customCollections) {
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        [_albumNameArr addObject:collection.localizedTitle];
        [_albumAssetsArr addObject:assets];
    }
}

/**
 *  获取相册数量
 */
- (NSInteger)getGroupCount
{
    return _albumAssetsArr.count;
}

/**
 *  获取相册一张照片
 */
- (UIImage *)getAlbumPhoto:(PHFetchResult *)assets index:(NSInteger)index
{
    __block UIImage *image = nil;
    if (assets.count > 0) {
        // CGSizeMake(300, 300) 目标尺寸越大图片越清晰，但是太大的话会很卡的哦
        [[PHImageManager defaultManager] requestImageForAsset:assets[index] targetSize: CGSizeMake(300, 300) contentMode:PHImageContentModeAspectFill options:_options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            image = result;
          
            ////        NSLog(@"%@",result);
            //        NSLog(@"%ld",self.num);
            // NSLog(@"%@",info.allKeys);
            //        NSLog(@"---------------------------------------------------------------");
            
        }];
    }
    return image;
}

- (CGFloat)getCollectionContentHeight:(NSInteger)itemCount
{
    /**
     根据item个数判断是整数行，还是有余数
     */
    // (取整)行数
    NSInteger row = itemCount / 4;
    // (取余)余数
    NSInteger quyu = itemCount % 4;
    
    // collectionView的内容高度
    float contentHeight = 0;
    
    if (quyu == 0) {
        // 整除4 row表示行数
        contentHeight = (row + 1)*itemSpace + row*itemWidth;
    }else{
        // （row + 1）表示行数
        contentHeight = (row + 1 + 1)*itemSpace + (row + 1)*itemWidth;
    }
    
    return contentHeight;
}

-(NSString *)timeFromSeconds:(NSInteger)seconds
{
    NSInteger m = seconds/60;
    NSInteger s = seconds%60;
    NSString *mString ;
    NSString *sString ;
    if (m<10){
        mString =[NSString stringWithFormat:@"0%ld",(long)m];
    }else{
        mString =[NSString stringWithFormat:@"%ld",(long)m];
    }
    
    if (s<10){
        sString =[NSString stringWithFormat:@"0%ld",(long)s];
    }else{
        sString =[NSString stringWithFormat:@"%ld",(long)s];
    }

    return  [NSString stringWithFormat:@"%@:%@",mString,sString];
}


/** 关于localIdentifier：
 * 我们可以在第一次获取到相册中的 GIF 的时候，将其获取到的所有 GIF 的 localIdentifier 记录下来。这样，下次启动的时候，就可以通过这些 localIdentifier 来直接获取 GIF 资源
 *  PHAsset fetchAssetsWithLocalIdentifiers:<#(nonnull NSArray<NSString *> *)#> options:<#(nullable PHFetchOptions *)#>
 */
#pragma mark - 判断资源是不是GIF ：（资源类型判别可以为UI提供一些图片类型的指示）
////方法1 iOS 9.0
- (BOOL)adjustGIFWithAsset:(PHAsset *)asset {
    if ([asset isKindOfClass:[PHAsset class]]) {
        //每个asset 都有一个或者多个PHAssetResource(如：被编辑保存过的aseet会有若干个resource, 且被修改后的GIF类型的asset得uniformTypeIdentifier 会发生改变变成了public.jpeg 类型，所以修改多地GIF的就不再是GIF了，所以要对比最后一个resource的类型)
        NSArray<PHAssetResource *>* tmpArr = [PHAssetResource assetResourcesForAsset:asset];
        if (tmpArr.count) {
            PHAssetResource *resource = tmpArr.lastObject;
            if (resource.uniformTypeIdentifier.length) {
                return UTTypeConformsTo( (__bridge CFStringRef)resource.uniformTypeIdentifier, kUTTypeGIF);
            }
        }
    }
    return false;
}

//方法2
- (BOOL)adjustGIFWithAsset2:(PHAsset *)asset {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    [options setSynchronous:true];//同步
    __block NSString *dataUTIStr = nil;
    if ([asset isKindOfClass:[PHAsset class]]) {
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            dataUTIStr = dataUTI;
        }];
    }
    if (dataUTIStr.length) {
        return UTTypeConformsTo( (__bridge CFStringRef)dataUTIStr, kUTTypeGIF);
    }
    return false;
}

/**mov转mp4格式 最好设一个block 转完码之后的回调*/
- (void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                              outputURL:(NSURL*)outputURL
                        completeHandler:(void (^)(AVAssetExportSession*))handler

{
    //转码配置
    AVURLAsset * avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession * exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 //NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 //NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 //NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 //NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:{
                 //NSLog(@"AVAssetExportSessionStatusCompleted");
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //从沙河中删除掉视频文件，节约存储空间
                     NSFileManager * fileManager = [NSFileManager defaultManager];
                     [fileManager removeItemAtPath:[outputURL path] error:nil];
                 });
                 break;
             }
                 
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
         
     }];
}




@end
