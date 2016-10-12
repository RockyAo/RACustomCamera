//
//  RACustomCameraController.h
//  RACustomCamera
//
//  Created by Rocky on 15/9/22.
//  Copyright © 2015年 Rocky. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RACustomCameraControllerDelegate <NSObject>

@optional
- (void)photoCapViewController:(UIViewController *)viewController didFinishDismissWithImage:(UIImage *)image;

@end
@interface RACustomCameraController : UIViewController

@property(nonatomic,weak)id<RACustomCameraControllerDelegate> delegate;

@end
