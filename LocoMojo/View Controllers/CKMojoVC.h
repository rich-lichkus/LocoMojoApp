//
//  CKMojoVC.h
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CKMojoVCDelegate <NSObject>

-(void)didPressMap;
-(void)didPressNote;

@end


@interface CKMojoVC : UIViewController

@property (nonatomic, unsafe_unretained) id<CKMojoVCDelegate> delegate;

-(void)updateOpenPosts:(NSMutableArray*)posts;

@end

