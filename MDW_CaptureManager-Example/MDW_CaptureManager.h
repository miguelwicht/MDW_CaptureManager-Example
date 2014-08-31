//
//  MDW_CaptureManager.h
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 31.08.14.
//  Copyright (c) 2014 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CMBufferQueue.h>

@interface MDW_CaptureManager : NSObject

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) UIImage *stillImage;
@property (nonatomic) AVCaptureFlashMode flashMode;
@property (nonatomic, readonly) BOOL hasFlash;
@property (nonatomic, readonly) BOOL hasCamera;

#pragma mark - CaptureSession
- (void)startCaptureSession;
- (void)stopCaptureSession;

#pragma mark - PreviewLayer
- (void)addPreviewLayerToView:(UIView*)view;
- (void)removePreviewLayerFromView:(UIView *)view;
- (void)setPreviewLayerVideoGravity:(NSString *)videoGravity;

#pragma mark - Camera
- (void)switchCamera;
- (void)useFrontCamera;
- (void)useBackCamera;
- (void)captureStillImage;

@end
