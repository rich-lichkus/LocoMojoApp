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
@property (weak, nonatomic) IBOutlet UITextView *txvMessage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiMojo;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiSend;

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
    [self.txvMessage.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.txvMessage.layer setBorderWidth:2];
    self.txvMessage.delegate = self;
}

#pragma mark - Methods

-(void)setTextForGPSLabel:(CLLocation *)location{
    self.lblGPSPosition.text = [NSString stringWithFormat:@" GPS(%.6f, %.6f)",location.coordinate.latitude, location.coordinate.longitude];
}

#pragma mark - Target Actions

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
