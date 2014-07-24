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

- (instancetype)initWith:(CKCircle*)circle;

@end
