//
//  RACustomCameraTool.m
//  RACustomCamera
//
//  Created by ZCBL on 16/10/12.
//  Copyright © 2016年 Rocky. All rights reserved.
//

#import "RACustomCameraTool.h"
#import <AVFoundation/AVFoundation.h>

@interface RACustomCameraTool ()


@property (nonatomic) dispatch_queue_t sessionQueue;
/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession* session;
/**
 *  输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**
 *  照片输出流
 */
@property (nonatomic, strong) AVCaptureStillImageOutput* stillImageOutput;
/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;



@end

@implementation RACustomCameraTool{

    /**
     *  判断使用哪一个摄像头
     */
    BOOL isUsingFrontFacingCamera;
    /**
     *  记录开始的缩放比例
     */
    CGFloat beginGestureScale;
    /**
     *  最后的缩放比例
     */
    CGFloat effectiveScale;
}

- (instancetype)initCameraInView:(UIView *)view{

    self = [super init];
    if (self) {
        
        isUsingFrontFacingCamera = NO;
        effectiveScale = beginGestureScale = 1.0f;
    }
    return self;
}

@end
