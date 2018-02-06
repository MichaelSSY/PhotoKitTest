//
//  YZImagePickerController.m
//  PhotoTest
//
//  Created by weiyun on 2018/2/1.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#import "YZImagePickerController.h"
#import "YZImageGroupTableViewController.h"

@interface YZImagePickerController ()

@end

@implementation YZImagePickerController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:[[YZImageGroupTableViewController alloc] init]];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
