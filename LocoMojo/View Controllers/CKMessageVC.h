//
//  CKMessageVC.h
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol CKMessageVCDelegate <NSObject>

-(void)postMessage:(NSString*)message;
-(void)didPressCancel;

@end

@interface CKMessageVC : UIViewController

@property (nonatomic, unsafe_unretained) id<CKMessageVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *txvMessage;

-(void)setTextForGPSLabel:(CLLocation*)location;

@end
