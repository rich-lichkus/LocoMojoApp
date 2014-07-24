//
//  CKAppDelegate.h
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKUser.h"
#import "CKOAuthController.h"
#import "CKFacebookNC.h"
#import "CKTwitterNC.h"

@interface CKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CKUser *currentUser;
@property (strong, nonatomic) CKOAuthController *oAuthController;
@property (strong, nonatomic) CKTwitterNC *twitterNC;
@property (strong, nonatomic) CKFacebookNC *facebookNC;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
