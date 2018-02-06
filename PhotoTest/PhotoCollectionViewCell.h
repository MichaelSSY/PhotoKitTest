//
//  PhotoCollectionViewCell.h
//  PhotoTest
//
//  Created by weiyun on 2018/1/31.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraView.h"
#import "Config.h"

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic , strong) UILabel *timeLabel;
@property (nonatomic , strong) UIImageView *photoImageView;
@end

@interface CameraCollectionViewCell : UICollectionViewCell
@property (nonatomic , strong) CameraView *cameraView;
@end
