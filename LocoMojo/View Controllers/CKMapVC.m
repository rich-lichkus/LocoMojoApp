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
#import "CKPost.h"
#import "CKMapPin.h"
#import <Parse/Parse.h>
#import "CKButtonLocation.h"

@class CKMapPin;

@interface CKMapVC () <MKMapViewDelegate>

@property (strong, nonatomic) NSMutableArray *visiblePosts;
@property (strong, nonatomic) NSMutableArray *readablePosts;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet CKButtonLocation *btnLocation;

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
    [self.btnLocation toggleOn];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView.userLocation addObserver:self
                                forKeyPath:@"location"
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                                   context:nil];
}

#pragma mark - Map

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [self.mapView removeOverlays:self.mapView.overlays];
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:userLocation.location.coordinate radius:150];
    [self.mapView addOverlay:circle];
    NSLog(@"added Overlay");
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if([overlay isKindOfClass:MKCircle.class]) {
        NSLog(@"render Overlay");
        MKCircleRenderer *circleRender = [[MKCircleRenderer alloc] initWithCircle:overlay];
        circleRender.fillColor = [UIColor colorWithRed:0.000 green:1.000 blue:0.502 alpha:0.500];
        return circleRender;
    }

    return nil;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    if([annotation isKindOfClass:CKMapPin.class]){
        MKPinAnnotationView *pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        if(pin == nil){
            pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        } else {
            pin.annotation = annotation;
        }
        switch (((CKMapPin*)annotation).pinType) {
            case kReadable:
                pin.pinColor = MKPinAnnotationColorGreen;
                break;
            case kVisible:
                pin.pinColor = MKPinAnnotationColorRed;
                break;
        }
        return pin;
    }
    return nil;
}

#pragma mark - Key-Value

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(self.btnLocation.isOn){
        MKCoordinateRegion region;
        region.center = self.mapView.userLocation.coordinate;
        
        MKCoordinateSpan span;
        span.latitudeDelta  = .005;
        span.longitudeDelta = .005;
        region.span = span;
        
        [self.mapView setRegion:region animated:YES];
    }
}

#pragma mark - Target Actions

- (IBAction)pressedMojo:(id)sender {
    [self.delegate didPressMojo];
}

- (IBAction)pressedLocation:(id)sender {
    NSLog(@"pressed location");
    [self.btnLocation toggleOn];
}

#pragma mark - Methods

-(void)updateVisiblePosts:(NSMutableArray *)posts{
    self.visiblePosts = posts;
    for(CKMapPin* annotation in self.mapView.annotations){
        if([annotation isKindOfClass:CKMapPin.class]){
            if (annotation.pinType == kVisible) {
                [self.mapView removeAnnotation:annotation];
            }
        }
    }
    for(CKPost *post in posts){
        [self.mapView addAnnotation:[[CKMapPin alloc] initWithCoordinate:post.location.coordinate withPinType:kVisible]];
    }
}

-(void)updateOpenPosts:(NSMutableArray *)posts{
    self.readablePosts = posts;
    for(CKMapPin* annotation in self.mapView.annotations){
        if([annotation isKindOfClass:CKMapPin.class]){
            if (annotation.pinType == kReadable) {
                [self.mapView removeAnnotation:annotation];
            }
        }
    }
    for(CKPost *post in posts){
        [self.mapView addAnnotation:[[CKMapPin alloc] initWithCoordinate:post.location.coordinate withPinType:kReadable]];
    }
}

#pragma mark - Navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

#pragma mark - Lazy

-(NSMutableArray*)visiblePosts{
    if(!_visiblePosts){
        _visiblePosts = [[NSMutableArray alloc] init];
    }
    return _visiblePosts;
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
