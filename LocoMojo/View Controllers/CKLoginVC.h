//
//  CKLoginVC.h
//  LocoMojo
//
//  Created by Richard Lichkus on 8/5/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKLoginView.h"

@protocol CKLoginVCDelegate <NSObject>

-(void)openProfileView;

@end

@interface CKLoginVC : UIViewController

@property (nonatomic, unsafe_unretained) id<CKLoginVCDelegate> delegate;
@property (strong, nonatomic) CKLoginView *loginView;
@property (nonatomic, getter = isLocked) BOOL locked;

@end
