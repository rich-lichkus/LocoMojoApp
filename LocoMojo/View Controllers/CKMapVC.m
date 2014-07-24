//
//  CKMapVC.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKMapVC.h"
#import <MapKit/MapKit.h>
#import "CKCircleMapOverlay.h"
#import "CKCircleOverlayRender.h"
#import "PCLocoMojo.h"

@interface CKMapVC () <MKMapViewDelegate>

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

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureMapView];
}

#pragma mark - Configuration

-(void)configureMapView{
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    
    [self.mapView.userLocation addObserver:self
                                forKeyPath:@"location"
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                                   context:nil];
}

#pragma mark - Map

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CKCircle *circle = [[CKCircle alloc] initWith:self.mapView.centerCoordinate boundingRect:self.mapView.visibleMapRect];
    [self.mapView addOverlay:[[CKCircleMapOverlay alloc] initWith:circle]];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if([overlay isKindOfClass:CKCircleMapOverlay.class]) {
        UIImage *circleOverlayImage = [PCLocoMojo imageOfCircleOverlay];
        CKCircleOverlayRender *overlayRender = [[CKCircleOverlayRender alloc] initWithOverlay:overlay overlayImage:circleOverlayImage];
        return overlayRender;
    }
    return nil;
}

#pragma mark - Key-Value

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    MKCoordinateRegion region;
    region.center = self.mapView.userLocation.coordinate;
    
    MKCoordinateSpan span;
    double delta = 0;
    span.latitudeDelta  = delta;
    span.longitudeDelta = delta;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - Target Actions

- (IBAction)pressedMojo:(id)sender {
    [self.delegate didPressMojo];
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
