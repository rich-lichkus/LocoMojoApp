//
//  CKCircleMapOverlay.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/24/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKCircleMapOverlay.h"

@implementation CKCircleMapOverlay

@synthesize coordinate;
@synthesize boundingMapRect;

- (instancetype)initWith:(MKCircle*)circle{
    self = [super init];
    if (self) {
        self.circle = circle;
    }
    return self;
}

@end
