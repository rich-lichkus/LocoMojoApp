//
//  CKMapVC.h
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CKMapVCDelegate <NSObject>

-(void)didPressMojo;

@end

@interface CKMapVC : UIViewController

@property (strong, nonatomic) id<CKMapVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

-(void)updateVisiblePosts:(NSMutableArray*)posts;
-(void)updateOpenPosts:(NSMutableArray*)posts;

@end
