//
//  CameraView.m
//  PhotoTest
//
//  Created by weiyun on 2018/2/1.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "CameraView.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraView ()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureDevice * device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPlayer;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;//原始视频帧，用于获取实时图像以及视频录制
@end

@implementation CameraView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        /**
         设置 Session
         */
        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPreset640x480;
        
        /**
         设置 摄像头前后置
         */
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *temdevice in devices) {
            if (temdevice.position == AVCaptureDevicePositionBack) {
                self.device = temdevice;
            }
        }
        
        /**
         设置 Input
         */
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        if ([self.session canAddInput:self.input]) {
            [self.session addInput:self.input];
        }
        
        /**
         设置 Output
         
         注意： AVCaptureVideoDataOutput和代理方法其实可以不写，因为这只是一个现实窗口而已，做个样子，没有实际的用处，点击item的时候会调起真正的相机。
         */
        self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = NO;
        [self.videoDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        [self.videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
        if ([self.session canAddOutput:self.videoDataOutput]) {
            [self.session addOutput:self.videoDataOutput];
        }

        /**
         设置 VideoPreviewLayer
         */
        self.videoPlayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        [self.videoPlayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        self.videoPlayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.layer addSublayer:self.videoPlayer];
        
        // 开始捕捉
        [self.session startRunning];
        
    }
    return self;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{

}


@end
