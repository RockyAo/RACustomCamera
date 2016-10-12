//
//  RACustomCameraTool.m
//  RACustomCamera
//
//  Created by ZCBL on 16/10/12.
//  Copyright © 2016年 Rocky. All rights reserved.
//

#import "RACustomCameraTool.h"
#import <AVFoundation/AVFoundation.h>

@interface RACustomCameraTool ()<UIGestureRecognizerDelegate>


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
    /**
     *  存储view
     */
    UIView *backView;
}

#pragma mark - 初始化函数
- (instancetype)initCameraInView:(UIView *)view{

    self = [super init];
    if (self) {
        
        isUsingFrontFacingCamera = NO;
        effectiveScale = beginGestureScale = 1.0f;
        backView = view;
        _maxScale = 0;
        [self initAVCaptureSessionInView];
        [self setUpGestureInView];
    }
    return self;
}

- (void)initAVCaptureSessionInView{
    
    self.session = [[AVCaptureSession alloc] init];
    
    NSError *error;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    self.previewLayer.frame = backView.frame;
    backView.layer.masksToBounds = YES;
    [backView.layer addSublayer:self.previewLayer];
    
}
- (void)setUpGestureInView{
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [backView addGestureRecognizer:pinch];
}

//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:backView];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        
        effectiveScale = beginGestureScale * recognizer.scale;
        if (effectiveScale < 1.0){
            effectiveScale = 1.0;
        }
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        NSLog(@"%f",maxScaleAndCropFactor);
        
        
        if (self.maxScale) {
            
            if (effectiveScale > self.maxScale)
                effectiveScale = self.maxScale;
        }else{
            
            if (effectiveScale > maxScaleAndCropFactor)
                effectiveScale = maxScaleAndCropFactor;

        }
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(effectiveScale, effectiveScale)];
        [CATransaction commit];
        
    }
    
}


@end
