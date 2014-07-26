//
//  CKMapPin.h
//  LocoMojo
//
//  Created by Richard Lichkus on 7/24/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CKMapPin : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) kPinType pinType;

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)locationCoor withPinType:(kPinType)pinType withTitle:(NSString*)message;

@end
