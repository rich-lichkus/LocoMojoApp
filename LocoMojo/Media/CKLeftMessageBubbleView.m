//
//  CKLeftMessageBubbleView.m
//  LocoMojo
//
//  Created by Richard Lichkus on 8/11/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKLeftMessageBubbleView.h"
#import "PCLocoMojo.h"

@implementation CKLeftMessageBubbleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [PCLocoMojo drawLeftMessageBubbleWithFrame:rect];
}


@end
