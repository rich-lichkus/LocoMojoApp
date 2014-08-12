//
//  CKMessageCell.m
//  LocoMojo
//
//  Created by Richard Lichkus on 8/11/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKMessageCell.h"
#import "PCLocoMojo.h"

@interface CKMessageCell ()



@end


@implementation CKMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{    
    self.lblTitle = [[UILabel alloc] initWithFrame:self.bounds];
    [self.lblTitle setFont:[UIFont systemFontOfSize:18.0f]];
    [self addSubview:self.lblTitle];
    
    self.lblName = [[UILabel alloc] initWithFrame:self.bounds];
    self.lblName.font = [UIFont systemFontOfSize:12.0f];
    self.lblName.textColor = [UIColor lightGrayColor];
    [self addSubview:self.lblName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateLeftFrame:(CGRect)frame{
    CGRect labelFrame = CGRectMake(frame.origin.x+10,
                                   frame.origin.y,
                                   frame.size.width-20,
                                   frame.size.height-12);
    CGRect nameFrame = CGRectMake(40, frame.size.height-15, frame.size.width-57, 20);
    
    self.lblTitle.frame = labelFrame;

    self.lblTitle.textColor = [UIColor blackColor];
    self.lblTitle.textAlignment = NSTextAlignmentLeft;
    self.lblName.frame = nameFrame;
    self.lblName.textAlignment = NSTextAlignmentLeft;
    [self.bubble removeFromSuperview];
    self.bubble = [[CKLeftMessageBubbleView alloc] initWithFrame:frame];
    self.bubble.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bubble];
    [self bringSubviewToFront:self.lblTitle];
    [self bringSubviewToFront:self.lblName];
}

-(void)updateRightFrame:(CGRect)frame{
    CGRect labelFrame = CGRectMake(frame.origin.x+10,
                                   frame.origin.y,
                                   frame.size.width-20,
                                   frame.size.height-12);
    CGRect nameFrame = CGRectMake(7, frame.size.height-20, frame.size.width-45, 20);
    
    self.lblTitle.frame = labelFrame;
    self.lblTitle.textColor = [UIColor whiteColor];
    self.lblTitle.textAlignment = NSTextAlignmentLeft;
    self.lblName.frame = nameFrame;
    self.lblName.textAlignment = NSTextAlignmentRight;
    [self.bubble removeFromSuperview];
    self.bubble = [[CKRightMessageBubbleView alloc] initWithFrame:frame];
    self.bubble.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bubble];
    [self bringSubviewToFront:self.lblTitle];
    [self bringSubviewToFront:self.lblName];
}

@end
