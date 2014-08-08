//
//  CKLoginView.h
//  LocoMojo
//
//  Created by Richard Lichkus on 8/5/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKLoginView : UIView

// UI Elements
@property (strong, nonatomic) UIView *uivTopView;
@property (strong, nonatomic) UIButton *btnFacebook;
@property (strong, nonatomic) UIButton *btnTwitter;
@property (strong, nonatomic) UITextField *txtUsername;
@property (strong, nonatomic) UITextField *txtPassword;

@property (strong, nonatomic) UIView *uivBottomView;
@property (strong, nonatomic) UIButton *btnLogin;

@property (strong, nonatomic) UIView *uivError;
@property (strong, nonatomic) UILabel *lblError;

-(void)unlockScreen:(BOOL)authenticated;
-(void)showErrorMessage:(NSString*)errorMessage willShow:(BOOL)show;

@end
