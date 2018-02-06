//
//  PhotoCollectionViewCell.m
//  PhotoTest
//
//  Created by weiyun on 2018/1/31.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import <Masonry.h>

@implementation PhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _photoImageView  = [[UIImageView alloc]init];
        _photoImageView.clipsToBounds = YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_photoImageView];
        [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.contentView);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_photoImageView);
            make.height.equalTo(15);
            make.bottom.equalTo(self.contentView.bottom).offset(-7);
        }];
    }
    
    return self;
}

@end


@implementation CameraCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (_cameraView == nil) {
            [self.contentView addSubview:self.cameraView];
        }
    }
    
    return self;
}

- (CameraView *)cameraView
{
    NSInteger space = 4;
    CGFloat width = (SCREEN_WIDTH - space*5) / 4;
    if (_cameraView == nil) {
        _cameraView = [[CameraView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    }
    return _cameraView;
}

@end
