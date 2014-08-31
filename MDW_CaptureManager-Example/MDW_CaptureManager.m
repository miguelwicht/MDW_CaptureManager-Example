//
//  MDW_CaptureManager.m
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 31.08.14.
//  Copyright (c) 2014 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

#import "MDW_CaptureManager.h"
#define kImageCapturedSuccessfully @"MDW_CaptureManagerDidTakePictureNotification"

@interface MDW_CaptureManager ()

#pragma mark - Private properties
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureDevice *currentDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *currentInput;

@property (nonatomic, strong) AVCaptureDevice *frontCamera;
@property (nonatomic, strong) AVCaptureDevice *backCamera;

@property (nonatomic, readwrite) BOOL hasCamera;

@end

@implementation MDW_CaptureManager

#pragma mark - Initialization

- (id)init
{
	if ((self = [super init]))
    {
        [self initCameras];
        [self initStillImageOutput];
        [self initCaptureSession];
	}
	return self;
}

#pragma mark - CaptureSession

- (void)initCaptureSession
{
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession setSessionPreset: AVCaptureSessionPresetPhoto];
    [self.captureSession addOutput:self.stillImageOutput];
    [self.captureSession addInput:self.currentInput];
}

- (void)startCaptureSession
{
    if (self.hasCamera)
    {
        [self.captureSession startRunning];
    } else
    {
        NSLog(@"Device has no camera");
    }
}

- (void)stopCaptureSession
{
    [self.captureSession stopRunning];
}

#pragma mark - PreviewLayer

- (void)addPreviewLayerToView:(UIView*)view
{
    if (!self.previewLayer)
    {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    }
    self.previewLayer.frame = view.bounds;
    [view.layer insertSublayer:self.previewLayer atIndex:0];
}

- (void)removePreviewLayerFromView:(UIView *)view
{
    [self.previewLayer removeFromSuperlayer];
}

- (void)setPreviewLayerVideoGravity:(NSString*)videoGravity
{
    [self.previewLayer setVideoGravity:videoGravity];
}

#pragma mark - Camera

- (void)initCameras
{
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices)
    {
        if ([device hasMediaType:AVMediaTypeVideo])
        {
            switch (device.position)
            {
                case AVCaptureDevicePositionBack:
                    self.backCamera = device;
                    break;
                    
                case AVCaptureDevicePositionFront:
                    self.frontCamera = device;
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    self.hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    self.currentDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.currentInput = [AVCaptureDeviceInput deviceInputWithDevice:self.currentDevice error:nil];
}

- (void)initStillImageOutput
{
    self.stillImageOutput = [AVCaptureStillImageOutput new];
    [self.stillImageOutput setOutputSettings:[NSDictionary dictionaryWithObject:AVVideoCodecJPEG forKey:AVVideoCodecKey]];
}

- (void)switchCamera
{
    if (self.currentInput.device == self.frontCamera)
    {
        [self useBackCamera];
    }
    else
    {
        [self useFrontCamera];
    }
}

- (void)useFrontCamera
{
    [self useCamera:self.frontCamera];
}

- (void)useBackCamera
{
    [self useCamera:self.backCamera];
}

- (void)useCamera:(AVCaptureDevice*)camera
{
    [self.captureSession beginConfiguration];
    
    [self.captureSession removeInput:self.currentInput];
    self.currentInput = [AVCaptureDeviceInput deviceInputWithDevice:camera error:nil];
    [self.captureSession addInput:self.currentInput];
    
    [self.captureSession commitConfiguration];
}

- (void)captureStillImage
{
    AVCaptureConnection *vc = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    typedef void(^MyBufBlock)(CMSampleBufferRef, NSError*);
    MyBufBlock h = ^(CMSampleBufferRef buf, NSError *err) {
        self.stillImage = [[UIImage alloc] initWithData:[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:buf]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kImageCapturedSuccessfully object:nil];
        });
    };
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:vc completionHandler:h];
}

#pragma mark - Flash

- (BOOL) hasFlash
{
    return [self.currentDevice hasFlash];
}

- (AVCaptureFlashMode)flashMode
{
    return self.currentDevice.flashMode;
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode
{
    BOOL isFlashModeSupported = [self.currentDevice isFlashModeSupported:flashMode];
    
    if (isFlashModeSupported)
    {
        if ( [self.currentDevice lockForConfiguration:NULL] == YES )
        {
            [self.currentDevice setFlashMode:flashMode];
            [self.currentDevice unlockForConfiguration];
        }
        else
        {
            NSLog(@"Could not set flashMode");
        }
    }
    else
    {
        NSLog(@"Could not set flashMode");
    }
}

@end