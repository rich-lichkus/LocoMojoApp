//
//  CKMessageVC.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKMessageVC.h"

@interface CKMessageVC ()

@property (weak, nonatomic) IBOutlet UITextView *txvMessage;

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
}

#pragma mark - Target Actions

- (IBAction)pressedBarButton:(id)sender {
    UIBarButtonItem *barItem = (UIBarButtonItem*)sender;
    
    switch (barItem.tag) {
        case 0: // Cancel
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 1: // Post
        {
            //TODO:
            // Create post object, save to parse
            // segue
        }
            break;
    }
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
