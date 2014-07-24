//
//  CKCircle.h
//  LocoMojo
//
//  Created by Richard Lichkus on 7/24/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CKCircle : NSObject

@property (nonatomic, readonly) CLLocationCoordinate2D midCoordinate;
@property (nonatomic, readonly) MKMapRect overlayBoundingMapRect;

-(instancetype)initWith:(CLLocationCoordinate2D)midCoordinates boundingRect:(MKMapRect)rect;

@end
