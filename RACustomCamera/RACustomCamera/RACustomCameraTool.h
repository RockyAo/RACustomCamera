//
//  RACustomCameraTool.h
//  RACustomCamera
//
//  Created by ZCBL on 16/10/12.
//  Copyright © 2016年 Rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RACustomCameraTool : NSObject


/**
 最大缩放比例（min：1- max：67.5）
 */
@property(nonatomic,assign)CGFloat maxScale;

/**
 初始化相机

 @param view 添加相机的view（相机大小为该View的frame）

 @return RACustomCameraTool Object
 */
- (instancetype)initCameraInView:(UIView *)view;

@end
