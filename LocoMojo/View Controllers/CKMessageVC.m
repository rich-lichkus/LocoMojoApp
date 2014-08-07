//
//  CKMessageVC.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKMessageVC.h"
#import "PCLocoMojo.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@interface CKMessageVC () <UITextViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblGPSPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblGPSAccuracy;
@property (weak, nonatomic) IBOutlet UITextView *txvMessage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiMojo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiSend;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;

// Camera View
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDevice *deviceCamera;
@property (strong, nonatomic) UIView *cameraView;
@property (strong, nonatomic) AVCaptureStillImageOutput *capturedImage;
@property (strong, nonatomic) UIImageView *imgCamera;
@property (strong, nonatomic) UIButton *btnCancel;
@property (strong, nonatomic) UIButton *btnFlash;
@property (strong, nonatomic) UIButton *btnSwitchCamera;
@property (strong, nonatomic) UIButton *btnCapture;
@property (strong, nonatomic) UIButton *btnPhoto;

- (IBAction)pressedBarButton:(id)sender;

@end

@implementation CKMessageVC

#pragma mark - Instantiation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUIElements];
    
    //[self configureCameraView];
}

#pragma mark - Configuration

-(void)configureUIElements{
    // TextView
    self.txvMessage.layer.cornerRadius =10;
    self.txvMessage.layer.masksToBounds = YES;
    [self.txvMessage.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.txvMessage.layer setBorderWidth:2];
    self.txvMessage.delegate = self;
    
    // Camera View
//    self.cameraView = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y,0,0)];
//    self.cameraView.layer.cornerRadius = 0;
//    self.cameraView.layer.masksToBounds = YES;
//    self.cameraView.backgroundColor = [UIColor lightGrayColor];
//    
//    self.imgCamera = [[UIImageView alloc] initWithFrame:CGRectMake(self.cameraView.frame.size.height*1.2*.5-self.view.frame.size.width*.5,
//                                                                   self.cameraView.frame.size.height*1.2*.5-self.view.frame.size.height*.5,
//                                                                   self.view.frame.size.width, self.view.frame.size.height)];
//    [self.cameraView addSubview:self.imgCamera];
    [self.view addSubview:self.cameraView];
}

-(void)configureCameraView{
    
    self.session = [[AVCaptureSession alloc] init];
	self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
	
	CALayer *viewLayer = self.imgCamera.layer;
	NSLog(@"viewLayer = %@", viewLayer);
	
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
	captureVideoPreviewLayer.frame = self.imgCamera.bounds;
	[self.imgCamera.layer addSublayer:captureVideoPreviewLayer];
	
	self.deviceCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.deviceCamera error:&error];
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[self.session addInput:input];
    
    self.capturedImage = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.capturedImage setOutputSettings:outputSettings];
    
    [self.session addOutput:self.capturedImage];
    
    [self.session startRunning];
}

#pragma mark - Methods

-(void)setTextForGPSLabel:(CLLocation *)location {
    self.lblGPSPosition.text = [NSString stringWithFormat:@"GPS: %.6f, %.6f",location.coordinate.latitude, location.coordinate.longitude];
    self.lblGPSAccuracy.text = [NSString stringWithFormat:@"Accuracy: H%.2f, V%.2f",location.horizontalAccuracy, location.verticalAccuracy];
}

#pragma mark - Target Actions
- (IBAction)pressedCamera:(id)sender {
    [self showCamera:YES];
}

-(void)pressedCapture:(id)sender{
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.capturedImage.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    NSLog(@"about to request a capture from: %@", self.capturedImage);
    [self.capturedImage captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         }
         else
             NSLog(@"no attachments");
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         self.imgCamera.image = image;
     }];
}

-(void)pressedSwitchCamera:(id)sender{
    // Switch Camera
}

-(void)pressedPhoto:(id)sender{
    // Show photo library
}

-(void)pressedFlash:(id)sender{
    // Switch flash
    NSError *configError = nil;
    [self.deviceCamera lockForConfiguration:&configError];
    switch (self.deviceCamera.flashMode) {
        case AVCaptureFlashModeAuto:
            [self.deviceCamera setFlashMode:AVCaptureFlashModeOn];
            break;
        case AVCaptureFlashModeOn:
            [self.deviceCamera setFlashMode:AVCaptureFlashModeOff];
            break;
        case AVCaptureFlashModeOff:
            [self.deviceCamera setFlashMode:AVCaptureFlashModeAuto];
            break;
    }
    [self.deviceCamera unlockForConfiguration];
}

-(void)pressedCancel:(id)sender{
    [self showCamera:NO];
}

- (IBAction)pressedBarButton:(id)sender {
    UIBarButtonItem *barItem = (UIBarButtonItem*)sender;
    
    switch (barItem.tag) {
        case 0: // Cancel
        {
            [self.delegate didPressCancel];
        }
            break;
        case 1: // Post
        {
            if(self.txvMessage.text.length >0){
                [self.delegate postMessage:self.txvMessage.text];
            }
        }
            break;
    }
    
    [self.txvMessage resignFirstResponder];
    self.txvMessage.text = @"";
}

#pragma mark - Animations

-(void) showCamera:(BOOL)show{
    
    [self removeSubviewsToCameraView];
    
    if(!show){
        self.cameraView.frame = CGRectMake(self.view.center.x-self.view.frame.size.height*1.2 *.5,
                                            self.view.center.y-self.view.frame.size.height*1.2 *.5,
                                            self.view.frame.size.height*1.2 , self.view.frame.size.height*1.2 );
        self.imgCamera.frame = CGRectMake(self.view.frame.size.height*1.2*.5-self.view.frame.size.width*.5,
                                           self.view.frame.size.height*1.2*.5-self.view.frame.size.height*.5,
                                           self.view.frame.size.width, self.view.frame.size.height);
    }
    
    CGFloat viewSide = show ? self.view.frame.size.height*1.2 : 0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSNumber numberWithFloat:show ? 0.0f : self.view.frame.size.height*1.2*.5];
    animation.toValue = [NSNumber numberWithFloat:show ? self.view.frame.size.height*1.2*.5 : 0.0f];
    animation.duration = .3;
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.cameraView.frame = CGRectMake(self.view.center.x-viewSide*.5,
                                self.view.center.y-viewSide*.5,
                                viewSide, viewSide);
        [self.cameraView.layer addAnimation:animation forKey:@"cornerRadius"];
        
        self.imgCamera.frame = CGRectMake(viewSide*.5-self.view.frame.size.width*.5,
                                          viewSide*.5-self.view.frame.size.height*.5,
                                          self.view.frame.size.width, self.view.frame.size.height);
        
    } completion: ^(BOOL finished){
        [self addSubviewsToCameraView];
        if(show){
            self.cameraView.frame = self.view.frame;
            self.cameraView.layer.cornerRadius = 0;
            self.imgCamera.frame = self.view.frame;
        } else {
            [self.btnCancel removeFromSuperview];
            self.cameraView.layer.cornerRadius = 0;
        }
    }];
}

-(void)addSubviewsToCameraView
{
    CGFloat buttonPadding = 10;
    CGFloat buttonSide = 50;
    
    // Switch Camera Button
    self.btnSwitchCamera = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnSwitchCamera.frame = CGRectMake(self.view.frame.size.width-buttonPadding-buttonSide, buttonPadding, buttonSide, buttonSide);
    [self.btnSwitchCamera setTitle:@"Flip" forState:UIControlStateNormal];
    [self.cameraView addSubview:self.btnSwitchCamera];
    
    // Capture Button
    self.btnCapture = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnCapture.frame = CGRectMake(self.view.center.x-buttonSide*.5, self.view.frame.size.height-buttonPadding-buttonSide, buttonSide, buttonSide);
    [self.btnCapture setTitle:@"Capture" forState:UIControlStateNormal];
    [self.cameraView addSubview:self.btnCapture];
    [self.btnCapture addTarget:self action:@selector(pressedCapture:) forControlEvents:UIControlEventTouchUpInside];
    
    // Photo Button
    self.btnPhoto = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnPhoto.frame = CGRectMake(self.view.frame.size.width-buttonPadding-buttonSide, self.view.frame.size.height-buttonPadding-buttonSide,
                                   buttonSide, buttonSide);
    [self.btnPhoto setTitle:@"Photo" forState:UIControlStateNormal];
    [self.cameraView addSubview:self.btnPhoto];
    
    // Flash Button
    self.btnFlash = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnFlash.frame = CGRectMake(buttonPadding, buttonPadding,
                                   buttonSide, buttonSide);
    [self.btnFlash setTitle:@"Flash" forState:UIControlStateNormal];
    [self.cameraView addSubview:self.btnFlash];
    
    // Cancel Button
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnCancel.frame = CGRectMake(buttonPadding, self.view.frame.size.height-buttonPadding-buttonSide,
                            buttonSide, buttonSide);
    [self.btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(pressedCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraView addSubview:self.btnCancel];
}

-(void)removeSubviewsToCameraView{
    [self.btnFlash removeFromSuperview];
    [self.btnSwitchCamera removeFromSuperview];
    [self.btnCapture removeFromSuperview];
    [self.btnPhoto removeFromSuperview];
    [self.btnCancel removeFromSuperview];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
