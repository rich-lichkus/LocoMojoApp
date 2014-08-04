//
//  CKMessageVC.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKMessageVC.h"
#import "PCLocoMojo.h"

@interface CKMessageVC () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblGPSPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblGPSAccuracy;
@property (weak, nonatomic) IBOutlet UITextView *txvMessage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiMojo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiSend;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;

// Camera View
@property (strong, nonatomic) UIView *cameraView;
@property (strong, nonatomic) UIButton *btnCancel;

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
    self.cameraView = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y,0,0)];
    self.cameraView.layer.cornerRadius = 0;
    self.cameraView.layer.masksToBounds = YES;
    self.cameraView.backgroundColor = [UIColor lightGrayColor];
    
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnCancel.frame = CGRectMake(self.view.center.x, self.view.center.y, 60, 44);
    [self.btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(pressedCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cameraView];
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
    
    [self.btnCancel removeFromSuperview];
    
    CGFloat viewSide = show ? self.view.frame.size.height*1.2 : 0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionLinear];
    
    animation.fromValue = [NSNumber numberWithFloat:show ? 0.0f : viewSide*.5];
    animation.toValue = [NSNumber numberWithFloat:show ? viewSide*.5 : 0.0f];
    
    animation.duration = .5;
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.cameraView.frame = CGRectMake(self.view.center.x-viewSide*.5,
                                self.view.center.y-viewSide*.5,
                                viewSide, viewSide);
        [self.cameraView.layer addAnimation:animation forKey:@"cornerRadius"];
    } completion: ^(BOOL finished){
        [self.cameraView addSubview:self.btnCancel];
        if(show){
            self.cameraView.frame = self.view.frame;
            self.cameraView.layer.cornerRadius = 0;
        } else {
            [self.btnCancel removeFromSuperview];
            self.cameraView.layer.cornerRadius = viewSide*.5;
        }
    }];
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
