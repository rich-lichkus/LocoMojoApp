//
//  CKMessageCell.h
//  LocoMojo
//
//  Created by Richard Lichkus on 8/11/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKLeftMessageBubbleView.h"
#import "CKRightMessageBubbleView.h"

@interface CKMessageCell : UITableViewCell
@property (strong, nonatomic) UIView *bubble;
@property (strong, nonatomic) UILabel *lblTitle;
@property (strong, nonatomic) UILabel *lblName;

-(void)updateLeftFrame:(CGRect)frame;
-(void)updateRightFrame:(CGRect)frame;

@end
