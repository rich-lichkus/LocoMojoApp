//
//  CKMojoVC.h
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKPost.h"

@protocol CKMojoVCDelegate <NSObject>

-(void)didPressMap;
-(void)didPressNote;
-(void)removeRegionalPost:(CKPost*)post;

@end


@interface CKMojoVC : UIViewController

@property (nonatomic, unsafe_unretained) id<CKMojoVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

-(void)updateOpenPosts:(NSMutableArray*)posts;

@end

