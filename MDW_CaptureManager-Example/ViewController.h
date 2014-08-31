//
//  ViewController.h
//  MDW_CaptureManager-Example
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 31.08.14.
//  Copyright (c) 2014 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDW_CaptureManager.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) MDW_CaptureManager *captureManager;
@property (nonatomic, strong) UIView *cameraPreview;
@property (nonatomic, strong) UIButton *switchCameraButton;
@property (nonatomic, strong) UIButton *startCapturingButton;
@property (nonatomic, strong) UIButton *stopCapturingButton;
@property (nonatomic, strong) UIButton *takePictureButton;
@property (nonatomic, strong) UIButton *flashModeButton;
@property (nonatomic, strong) UIButton *switchVideoGravityButton;
@property (nonatomic, strong) UIButton *togglePreviewLayerButton;

@end
