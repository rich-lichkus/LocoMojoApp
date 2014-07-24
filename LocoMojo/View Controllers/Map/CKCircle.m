//
//  CKCircle.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/24/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKCircle.h"

@interface CKCircle ()

@end

@implementation CKCircle

-(instancetype)initWith:(CLLocationCoordinate2D)midCoordinates boundingRect:(MKMapRect)rect; {
    self = [super init];
    if(self) {
        _midCoordinate = midCoordinates;
        _overlayBoundingMapRect = rect;
    }
    return  self;
}

@end
