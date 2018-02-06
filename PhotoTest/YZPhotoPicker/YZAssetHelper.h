//
//  YZAssetHelper.h
//  PhotoTest
//
//  Created by weiyun on 2018/2/2.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"

@interface YZAssetHelper : NSObject

+ (instancetype)sharedAssetHealer;

@property (nonatomic, strong) NSMutableArray *albumNameArr;   ///< 相册名称
@property (nonatomic, strong) NSMutableArray *albumAssetsArr; ///< 相册数组
@property (nonatomic, assign) NSInteger currentGroupIndex; ///< 获取当前第几个相册

/** 获取相册数量 */
- (NSInteger)getGroupCount;
/** 获取相册里面的图片 */
- (UIImage *)getAlbumPhoto:(PHFetchResult *)assets index:(NSInteger)index;
/** 判断是不是GIF图 */
- (BOOL)adjustGIFWithAsset2:(PHAsset *)asset;

/** 计算collectionView的内容高度 */
- (CGFloat)getCollectionContentHeight:(NSInteger)itemCount;

-(NSString *)timeFromSeconds:(NSInteger)seconds;

- (void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                              outputURL:(NSURL*)outputURL
                        completeHandler:(void (^)(AVAssetExportSession*))handler;
@end
