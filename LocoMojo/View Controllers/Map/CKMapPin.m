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
@synthesize title;
@synthesize subtitle;

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)locationCoor withPinType:(kPinType)pinType withTitle:(NSString *)message{
    self = [super init];
    if(self){
        self.coordinate = locationCoor;
        self.pinType = pinType;
        self.title = message;
    }
    return self;
}

- (NSString *)title {
    return title;
}

- (NSString *)subtitle {
    return subtitle;
}

- (CLLocationCoordinate2D)coordinate {
    return coordinate;
}

@end
