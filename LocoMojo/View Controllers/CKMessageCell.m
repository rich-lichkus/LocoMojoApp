//
//  CKMessageCell.m
//  LocoMojo
//
//  Created by Richard Lichkus on 8/11/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKMessageCell.h"
#import "PCLocoMojo.h"


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

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
