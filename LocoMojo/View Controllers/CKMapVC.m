//
//  CKMapVC.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKMapVC.h"
#import <MapKit/MapKit.h>

@interface CKMapVC ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation CKMapVC

#pragma mark - Intialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - Target Actions

- (IBAction)pressedMojo:(id)sender {
    [self.delegate didPressMojo];
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
