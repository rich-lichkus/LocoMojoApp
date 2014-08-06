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

@interface CKLoginView()<UITextFieldDelegate>
// UI Elements
@property (strong, nonatomic) UIView *uivTopView;
@property (strong, nonatomic) UIButton *btnFacebook;
@property (strong, nonatomic) UIButton *btnTwitter;
@property (strong, nonatomic) UITextField *txtUsername;
@property (strong, nonatomic) UITextField *txtPassword;

@property (strong, nonatomic) UIView *uivBottomView;
@property (strong, nonatomic) UIButton *btnLogin;

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
    [self.btnFacebook addTarget:self action:@selector(pressedFacebookLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnFacebook setTitle:@"Facebook" forState:UIControlStateNormal];
    
    self.btnTwitter = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x+TEXTFIELD_PADDING*.5,
                                                                 self.uivTopView.frame.size.height - (4*TEXTFIELD_HEIGHT+4*TEXTFIELD_PADDING),
                                                                 uiElementWidth*.5,
                                                                 TEXTFIELD_HEIGHT)];
    [self.btnTwitter setBackgroundImage:[PCLocoMojo imageOfLoginTwitter] forState:UIControlStateNormal];
    [self.btnTwitter addTarget:self action:@selector(pressedTwitterLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTwitter setTitle:@"Twitter" forState:UIControlStateNormal];
    
    
    self.txtUsername = [[UITextField alloc] initWithFrame:CGRectMake(self.center.x-(uiElementWidth*.5),
                                                                     self.uivTopView.frame.size.height - (2*TEXTFIELD_HEIGHT+2*TEXTFIELD_PADDING),
                                                                     uiElementWidth,
                                                                     TEXTFIELD_HEIGHT)];
    self.txtUsername.borderStyle = UITextBorderStyleRoundedRect;
    self.txtUsername.backgroundColor = [UIColor colorWithWhite:0.800 alpha:0.250];
    self.txtUsername.placeholder = @"Username";
    self.txtUsername.delegate = self;
    self.txtUsername.tag = kLoginUsernameTxtTag;
    
    self.txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(self.center.x-(uiElementWidth*.5),
                                                                     self.uivTopView.frame.size.height - TEXTFIELD_HEIGHT - TEXTFIELD_PADDING,
                                                                     uiElementWidth,
                                                                     TEXTFIELD_HEIGHT)];
    self.txtPassword.borderStyle = UITextBorderStyleRoundedRect;
    self.txtPassword.backgroundColor = [UIColor colorWithWhite:0.800 alpha:0.250];
    self.txtPassword.placeholder = @"Password";
    self.txtPassword.delegate = self;
    self.txtPassword.tag = kLoginPasswordTxtTag;
    self.txtPassword.secureTextEntry = YES;
    
    [self.uivTopView addSubview:self.btnFacebook];
    [self.uivTopView addSubview:self.btnTwitter];
    [self.uivTopView addSubview:self.txtUsername];
    [self.uivTopView addSubview:self.txtPassword];
    [self addSubview:self.uivTopView];
    
    // Lock Screen Bottom View
    self.uivBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, halfScreen,
                                                                  self.frame.size.width, halfScreen)];
    self.uivBottomView.backgroundColor = [UIColor whiteColor];
    
    self.btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(self.center.x-(uiElementWidth*.5), 0, uiElementWidth, UIBUTTON_HEIGHT)];
    [self.btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    self.btnLogin.enabled = NO;
    [self.btnLogin setBackgroundImage:[PCLocoMojo imageOfLoginDisabled] forState:UIControlStateDisabled];
    [self.btnLogin setBackgroundImage:[PCLocoMojo imageOfLoginNormal] forState:UIControlStateNormal];
    self.btnLogin.layer.cornerRadius = 5;
    self.btnLogin.layer.masksToBounds = YES;
    [self.btnLogin addTarget:self action:@selector(pressedLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.uivBottomView addSubview:self.btnLogin];
    [self addSubview:self.uivBottomView];

}

#pragma mark - Target Actions

-(void)pressedLogin:(id)sender{
    // TODO: Handle parse error and/or display
    [self.txtPassword resignFirstResponder];
    if(self.txtPassword.text.length >0 && self.txtUsername.text.length >0){
//        [PFUser logInWithUsernameInBackground:self.txtUsername.text password:self.txtPassword.text block:^(PFUser *user, NSError *error) {
//            if(!error){
//                [self.weak_currentUser updateUserWithPFUser:user];
//                [self unlockScreen:YES];
//                [self showProfileView:YES];
//            } else {
//                
//                NSAssert(error, @"Error: Parse email login.");
//                NSLog(@"%@",error.localizedDescription);
//            }
//        }];
    }
}

-(void)pressedFacebookLogin:(id)sender{
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
//    // Login PFUser using Facebook
//    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//        
//        if (!user) {
//            if (!error) {
//                NSLog(@"Uh oh. The user cancelled the Facebook login.");
//            } else {
//                NSLog(@"Uh oh. An error occurred: %@", error);
//            }
//        } else if (user.isNew) {
//            NSLog(@"User with facebook signed up and logged in!");
//            [self unlockScreen:YES];
//            [self showProfileView:YES];
//            [self addNewFBInfoToPFUser];
//        } else {
//            NSLog(@"User with facebook logged in!");
//            [self unlockScreen:YES];
//            [self showProfileView:YES];
//            // Get user's Facebook data
//            FBRequest *request = [FBRequest requestForMe];
//            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                [self.weak_currentUser updateUserWithFBUser:result];
//            }];
//        }
//    }];
}

-(void)pressedTwitterLogin:(id)sender{
//    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
//        if (!user) {
//            NSLog(@"The user cancelled the Twitter login.");
//            return;
//        } else if (user.isNew) {
//            NSLog(@"User signed up and logged in with Twitter!");
//            [self unlockScreen:YES];
//            [self showProfileView:YES];
//            //            [self addNewTWInfoToPFUser];
//            NSLog(@"user");
//        } else {
//            NSLog(@"User logged in with Twitter!");
//            [self unlockScreen:YES];
//            [self showProfileView:YES];
//            // Get user's Twitter data
//            NSLog(@"user");
//        }
//    }];
}

-(void)pressedUsername:(id)sender{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Logout?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Logout", nil];
//    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case kLoginUsernameTxtTag:
            
            break;
        case kLoginPasswordTxtTag:
            [self.btnLogin setEnabled:YES];
            break;
    }
}

#pragma mark - Animations

-(void)unlockScreen:(BOOL)authenticated{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        int halfScreen = self.frame.size.height*.5;
        int dy = authenticated ? -halfScreen : halfScreen;
        
        [UIView animateWithDuration:.5 animations:^{
            self.uivTopView.frame = CGRectOffset(self.uivTopView.frame, 0, dy);
            self.uivBottomView.frame = CGRectOffset(self.uivBottomView.frame, 0, -dy);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
