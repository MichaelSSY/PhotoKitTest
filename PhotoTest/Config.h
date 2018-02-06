//
//  Config.h
//  PhotoTest
//
//  Created by weiyun on 2018/2/1.
//  Copyright © 2018年 孙世玉. All rights reserved.
//

#ifndef Config_h
#define Config_h

//******************************* Masonary *******************************//
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS


#import <Photos/Photos.h>
#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "YZAssetHelper.h"
#import <MobileCoreServices/MobileCoreServices.h>


#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define  itemSpace 4
#define  itemWidth (SCREEN_WIDTH - itemSpace*5)/4



#endif /* Config_h */
