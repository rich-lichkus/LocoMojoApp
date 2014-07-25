//
//  CKButtonLocation.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/25/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKButtonLocation.h"
#import "PCLocoMojo.h"

@interface CKButtonLocation()

@property (nonatomic) BOOL on;

@end

@implementation CKButtonLocation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.on = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [PCLocoMojo drawCurrentLocationWithIsSelected:self.on];
}

-(void)toggleOn{
    self.on = !self.on;
}

-(BOOL)isOn{
    return self.on;
}

@end
