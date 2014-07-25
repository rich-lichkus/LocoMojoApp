//
//  CKCircleMapOverlay.h
//  LocoMojo
//
//  Created by Richard Lichkus on 7/24/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CKCircle.h"
@class CKCircle;

@interface CKCircleMapOverlay : NSObject <MKOverlay>

@property (strong, nonatomic) MKCircle *circle;

- (instancetype)initWith:(MKCircle*)circle;

@end
