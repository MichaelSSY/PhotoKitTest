//
//  ViewController.m
//  PhotoTest
//
//  Created by weiyun on 2018/1/31.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "ViewController.h"
#import "AllPhotoViewController.h"
#import "SmartAlbumTableViewController.h"
#import "VideoAlbumViewController.h"
#import "YZImagePickerController.h"

#import "Config.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"PhotoKit";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(openAppSettings)];
    self.navigationItem.rightBarButtonItem = cancel;
    
    
    NSArray *array = @[@"仿简书",@"图片集",@"视频集",@"仿微信"];
    
    for (int i = 0; i < array.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left).offset(40);
            make.width.equalTo(SCREEN_WIDTH-40*2);
            make.height.equalTo(45);
            make.top.equalTo(self.view.top).offset(100+45*i);
        }];
    }
}

/** 进入app设置页面 */
- (void)openAppSettings {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            NSLog(@"已授权");
        }else{
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
                }];
            } else NSLog(@"无法打开设置");
        }
    }];
}

- (void)buttonClick:(UIButton *)button
{
    UIViewController *vc;
    switch (button.tag) {
        case 0:
            vc = [[AllPhotoViewController alloc] init];
            break;
        case 1:
            vc = [[SmartAlbumTableViewController alloc] init];
            break;
        case 2:
            vc = [[VideoAlbumViewController alloc] init];
            break;
        case 3:{
            YZImagePickerController *picker = [[YZImagePickerController alloc] initWithRootViewController:[UIViewController new]];
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
