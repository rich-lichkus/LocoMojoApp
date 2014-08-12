//
//  CKRightMessageBubbleView.m
//  LocoMojo
//
//  Created by Richard Lichkus on 8/11/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKRightMessageBubbleView.h"
#import "PCLocoMojo.h"

@implementation CKRightMessageBubbleView

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
    // Drawing code
    [PCLocoMojo drawRightSharpMessageBubbleWithFrame:rect];
}


@end
