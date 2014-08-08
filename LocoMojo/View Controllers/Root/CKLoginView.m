//
//  CKLoginView.m
//  LocoMojo
//
//  Created by Richard Lichkus on 8/5/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "PCLocoMojo.h"
#import "CKLoginView.h"
#import <Parse/Parse.h>

#define CELL_SEPARATOR_HEIGHT 1
#define PERCENTAGE_VIEW_WIDTH .70
#define TEXTFIELD_HEIGHT 40
#define UIBUTTON_HEIGHT 40
#define TEXTFIELD_PADDING 10

//typedef NS_ENUM (NSInteger, kLoginElementTags){
//    kLoginUsernameTxtTag = 0,
//    kLoginPasswordTxtTag
//};

@interface CKLoginView()

@end

@implementation CKLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUIElements];
    }
    return self;
}

-(void)configureUIElements{
    float halfScreen = self.frame.size.height*.5;
    float uiElementWidth = self.frame.size.width*.75;
    
    // Lock Screen Top View
    self.uivTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                               self.frame.size.width,
                                                               halfScreen)];
    self.uivTopView.backgroundColor = [UIColor whiteColor];
    
    self.btnFacebook = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x-(uiElementWidth*.5),
                                                                  self.uivTopView.frame.size.height - (4*TEXTFIELD_HEIGHT+4*TEXTFIELD_PADDING),
                                                                  uiElementWidth*.5-TEXTFIELD_PADDING*.5,
                                                                  TEXTFIELD_HEIGHT)];
    [self.btnFacebook setBackgroundImage:[PCLocoMojo imageOfFacebookLogin] forState:UIControlStateNormal];
    [self.btnFacebook setTitle:@"Facebook" forState:UIControlStateNormal];
    
    self.btnTwitter = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x+TEXTFIELD_PADDING*.5,
                                                                 self.uivTopView.frame.size.height - (4*TEXTFIELD_HEIGHT+4*TEXTFIELD_PADDING),
                                                                 uiElementWidth*.5,
                                                                 TEXTFIELD_HEIGHT)];
    [self.btnTwitter setBackgroundImage:[PCLocoMojo imageOfLoginTwitter] forState:UIControlStateNormal];
    [self.btnTwitter setTitle:@"Twitter" forState:UIControlStateNormal];
    
    // Error View
    self.uivError = [[UIView alloc] initWithFrame:CGRectMake(self.uivTopView.frame.origin.x,
                                                             self.btnFacebook.frame.origin.y+TEXTFIELD_PADDING+TEXTFIELD_HEIGHT+20,
                                                             self.uivTopView.frame.size.width, 0)];
    self.uivError.backgroundColor = [UIColor redColor];
    [self.uivTopView addSubview:self.uivError];
    
    self.lblError = [[UILabel alloc] initWithFrame:self.uivError.bounds];
    self.lblError.text = @"Error";
    self.lblError.textAlignment = NSTextAlignmentCenter;
    self.lblError.textColor = [UIColor whiteColor];
    [self.uivError addSubview:self.lblError];

    
    self.txtUsername = [[UITextField alloc] initWithFrame:CGRectMake(self.center.x-(uiElementWidth*.5),
                                                                     self.uivTopView.frame.size.height - (2*TEXTFIELD_HEIGHT+2*TEXTFIELD_PADDING),
                                                                     uiElementWidth,
                                                                     TEXTFIELD_HEIGHT)];
    self.txtUsername.borderStyle = UITextBorderStyleRoundedRect;
    self.txtUsername.backgroundColor = [UIColor colorWithWhite:0.800 alpha:0.250];
    self.txtUsername.placeholder = @"Username";
    self.txtUsername.tag = kLoginUsernameTxtTag;
    
    self.txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(self.center.x-(uiElementWidth*.5),
                                                                     self.uivTopView.frame.size.height - TEXTFIELD_HEIGHT - TEXTFIELD_PADDING,
                                                                     uiElementWidth,
                                                                     TEXTFIELD_HEIGHT)];
    self.txtPassword.borderStyle = UITextBorderStyleRoundedRect;
    self.txtPassword.backgroundColor = [UIColor colorWithWhite:0.800 alpha:0.250];
    self.txtPassword.placeholder = @"Password";
    self.txtPassword.tag = kLoginPasswordTxtTag;
    self.txtPassword.secureTextEntry = YES;
    
    [self.uivTopView addSubview:self.btnFacebook];
    [self.uivTopView addSubview:self.btnTwitter];
    [self.uivTopView addSubview:self.txtUsername];
    [self.uivTopView addSubview:self.txtPassword];
    [self addSubview:self.uivTopView];
    
    // Lock Screen Bottom View
    self.uivBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, halfScreen,self.frame.size.width, halfScreen)];
    self.uivBottomView.backgroundColor = [UIColor whiteColor];
    
    self.btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x-(uiElementWidth*.5), 0, uiElementWidth, UIBUTTON_HEIGHT)];
    [self.btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    self.btnLogin.enabled = NO;
    [self.btnLogin setBackgroundImage:[PCLocoMojo imageOfLoginDisabled] forState:UIControlStateDisabled];
    [self.btnLogin setBackgroundImage:[PCLocoMojo imageOfLoginNormal] forState:UIControlStateNormal];
    self.btnLogin.layer.cornerRadius = 5;
    self.btnLogin.layer.masksToBounds = YES;
    [self.uivBottomView addSubview:self.btnLogin];
    
 
    
    [self addSubview:self.uivBottomView];
}

#pragma mark - Animations

-(void)unlockScreen:(BOOL)authenticated{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        if(!authenticated){
            self.superview.frame = CGRectOffset(self.superview.frame, self.superview.frame.size.width,0);
        }
        
        int halfScreen = self.frame.size.height*.5;
        int dy = authenticated ? -halfScreen : halfScreen;
        
        [UIView animateWithDuration:.5 animations:^{
            self.uivTopView.frame = CGRectOffset(self.uivTopView.frame, 0, dy);
            self.uivBottomView.frame = CGRectOffset(self.uivBottomView.frame, 0, -dy);
        } completion:^(BOOL finished) {
            if(authenticated){
                self.superview.frame = CGRectOffset(self.superview.frame, -self.superview.frame.size.width, 0);
            }
        }];
    }];
}

-(void)showErrorMessage:(NSString*)errorMessage willShow:(BOOL)show{
    
    self.lblError.text = errorMessage;
    
    CGFloat height = show ? 40 : 0;
    CGFloat dy = show ? 20 : -20;
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.uivError.frame = CGRectMake(self.uivError.frame.origin.x, self.uivError.frame.origin.y-dy, self.uivError.frame.size.width, height);
        self.lblError.frame = self.uivError.bounds;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
