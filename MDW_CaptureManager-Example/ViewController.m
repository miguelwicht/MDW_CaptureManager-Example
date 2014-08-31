//
//  ViewController.m
//  MDW_CaptureManager-Example
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 31.08.14.
//  Copyright (c) 2014 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self initCaptureManager];
    [self initButtons];
    [self addNotificationObservers];
}

- (void)addNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WriteImageToSavedPhotosAlbum) name:@"MDW_CaptureManagerDidTakePictureNotification" object:nil];
}

- (void)removeNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MDW_CaptureManagerDidTakePictureNotification" object:nil];
}

- (void)initCaptureManager
{
    self.cameraPreview = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:self.cameraPreview atIndex:0];
    
    self.captureManager = [[MDW_CaptureManager alloc] init];
    [self.captureManager startCaptureSession];
    [self.captureManager addPreviewLayerToView:self.cameraPreview];
}

- (void)initButtons
{
    self.startCapturingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startCapturingButton setTitle:@"Start Capturing" forState:UIControlStateNormal];
    [self.startCapturingButton setFrame:CGRectMake(0, 40, self.view.frame.size.width, 40)];
    [self.startCapturingButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.startCapturingButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [self.view addSubview:self.startCapturingButton];
    
    self.stopCapturingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.stopCapturingButton setTitle:@"Stop Capturing" forState:UIControlStateNormal];
    [self.stopCapturingButton setFrame:CGRectMake(0, 81, self.view.frame.size.width, 40)];
    [self.stopCapturingButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.stopCapturingButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [self.view addSubview:self.stopCapturingButton];
    
    self.switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.switchCameraButton setTitle:@"Switch Camera" forState:UIControlStateNormal];
    [self.switchCameraButton setFrame:CGRectMake(0, 122, self.view.frame.size.width, 40)];
    [self.switchCameraButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchCameraButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [self.view addSubview:self.switchCameraButton];
    
    self.takePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.takePictureButton setTitle:@"Take Picture" forState:UIControlStateNormal];
    [self.takePictureButton setFrame:CGRectMake(0, 163, self.view.frame.size.width, 40)];
    [self.takePictureButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.takePictureButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [self.view addSubview:self.takePictureButton];
    
    self.flashModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flashModeButton setTitle:[NSString stringWithFormat:@"FlashMode: %ld", self.captureManager.flashMode] forState:UIControlStateNormal];
    [self.flashModeButton setFrame:CGRectMake(0, 204, self.view.frame.size.width, 40)];
    [self.flashModeButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.flashModeButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [self.view addSubview:self.flashModeButton];
    
    self.switchVideoGravityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.switchVideoGravityButton setTitle:[NSString stringWithFormat:@"Gravity: %@", [self.captureManager.previewLayer.videoGravity stringByReplacingOccurrencesOfString:@"AVLayerVideoGravity" withString:@""]] forState:UIControlStateNormal];
    [self.switchVideoGravityButton setFrame:CGRectMake(0, 245, self.view.frame.size.width, 40)];
    [self.switchVideoGravityButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchVideoGravityButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [self.view addSubview:self.switchVideoGravityButton];
    
    self.togglePreviewLayerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *previewLayerState = self.captureManager.previewLayer.superlayer != nil ? @"Visible" : @"hidden";
    [self.togglePreviewLayerButton setTitle:[NSString stringWithFormat:@"PreviewLayer: %@", previewLayerState] forState:UIControlStateNormal];
    [self.togglePreviewLayerButton setFrame:CGRectMake(0, 286, self.view.frame.size.width, 40)];
    [self.togglePreviewLayerButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.togglePreviewLayerButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [self.view addSubview:self.togglePreviewLayerButton];
}

- (void)buttonPressed:(id)sender
{
    if (sender == self.startCapturingButton)
    {
        [self.captureManager startCaptureSession];
    }
    else if (sender == self.stopCapturingButton)
    {
        [self.captureManager stopCaptureSession];
    }
    else if (sender == self.switchCameraButton)
    {
        [self.captureManager switchCamera];
    }
    else if (sender == self.takePictureButton)
    {
        [self.captureManager captureStillImage];
    }
    else if (sender == self.flashModeButton)
    {
        int lastFlashMode = AVCaptureFlashModeAuto;
        int currentFlashMode = self.captureManager.flashMode;
        int flashMode = currentFlashMode < lastFlashMode ? currentFlashMode + 1 : AVCaptureFlashModeOff;

        [self.captureManager setFlashMode:flashMode];
        [self.flashModeButton setTitle:[NSString stringWithFormat:@"FlashMode: %ld", self.captureManager.flashMode] forState:UIControlStateNormal];
    }
    else if (sender == self.switchVideoGravityButton)
    {
        // change video gravity and set button's title to current gravity
        // possible Gravities: AVLayerVideoGravityResize, AVLayerVideoGravityResizeAspect, AVLayerVideoGravityResizeAspectFill
        // should be an enum...
        
        NSString *currentVideoGravity = self.captureManager.previewLayer.videoGravity;
        
        if ([currentVideoGravity isEqualToString:AVLayerVideoGravityResize])
        {
            [self.captureManager setPreviewLayerVideoGravity:AVLayerVideoGravityResizeAspect];
        }
        else if ([currentVideoGravity isEqualToString:AVLayerVideoGravityResizeAspect])
        {
            [self.captureManager setPreviewLayerVideoGravity:AVLayerVideoGravityResizeAspectFill];
        }
        else if ([currentVideoGravity isEqualToString:AVLayerVideoGravityResizeAspectFill])
        {
            [self.captureManager setPreviewLayerVideoGravity:AVLayerVideoGravityResize];
        }
        
        [self.switchVideoGravityButton setTitle:[NSString stringWithFormat:@"Gravity: %@", [self.captureManager.previewLayer.videoGravity stringByReplacingOccurrencesOfString:@"AVLayerVideoGravity" withString:@""]] forState:UIControlStateNormal];
    }
    else if (sender == self.togglePreviewLayerButton)
    {
        if (self.captureManager.previewLayer.superlayer == nil)
        {
            [self.captureManager addPreviewLayerToView:self.cameraPreview];
        }
        else
        {
            [self.captureManager removePreviewLayerFromView:self.cameraPreview];
        }
        
        NSString *previewLayerState = self.captureManager.previewLayer.superlayer != nil ? @"Visible" : @"hidden";
        [self.togglePreviewLayerButton setTitle:[NSString stringWithFormat:@"PreviewLayer: %@", previewLayerState] forState:UIControlStateNormal];
    }
}

- (void)WriteImageToSavedPhotosAlbum
{
    UIImageWriteToSavedPhotosAlbum(self.captureManager.stillImage, self, nil, nil);
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc
{
    [self removeNotificationObservers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
