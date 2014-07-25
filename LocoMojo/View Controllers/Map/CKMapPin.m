//
//  CKMapPin.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/24/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKMapPin.h"

@implementation CKMapPin

@synthesize coordinate;
@synthesize pinType;

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)locationCoor withPinType:(kPinType)pinType{
    self = [super init];
    if(self){
        self.coordinate = locationCoor;
        self.pinType = pinType;
    }
    return self;
}

@end
