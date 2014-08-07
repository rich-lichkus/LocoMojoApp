//
//  CKLoginVC.m
//  LocoMojo
//
//  Created by Richard Lichkus on 8/5/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKLoginVC.h"
#import "CKAppDelegate.h"
#import "CKUser.h"
#import <Parse/Parse.h>

@interface CKLoginVC () <UITextFieldDelegate>

@property (weak, nonatomic) CKAppDelegate *weak_appDelegate;
@property (weak, nonatomic) CKUser *weak_currentUser;

@end

@implementation CKLoginVC

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        NSLog(@"coder");
    }
    return self;
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self configureLoginViews];
    
    [self configureControllers];
}

#pragma mark - Configuration

-(void)configureLoginViews{
    self.loginView = [[CKLoginView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.loginView];
    self.loginView.txtUsername.delegate = self;
    self.loginView.txtPassword.delegate = self;
    [self.loginView.btnLogin addTarget:self action:@selector(pressedLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.btnFacebook addTarget:self action:@selector(pressedFacebookLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView.btnTwitter addTarget:self action:@selector(pressedTwitterLogin:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)configureControllers{
    // App Delegate
    self.weak_appDelegate = (CKAppDelegate *)[UIApplication sharedApplication].delegate;
    self.weak_currentUser = self.weak_appDelegate.currentUser;
}

#pragma mark - Target Actions

-(void)pressedLogin:(id)sender{
    // TODO: Handle parse error and/or display
    [self.loginView.txtPassword resignFirstResponder];
    if(self.loginView.txtPassword.text.length >0 && self.loginView.txtPassword.text.length >0){
        [PFUser logInWithUsernameInBackground:self.loginView.txtUsername.text password:self.loginView.txtPassword.text block:^(PFUser *user, NSError *error) {
            if(!error){
                [self.weak_currentUser updateUserWithPFUser:user];
                [self unlockScreen];
                self.loginView.txtPassword.text = @"";
                self.loginView.txtUsername.text = @"";
                self.loginView.btnLogin.enabled = NO;
            } else {
                NSAssert(error, @"Error: Parse email login.");
                NSLog(@"%@",error.localizedDescription);
            }
        }];
    }
}

-(void)pressedFacebookLogin:(id)sender{
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {

        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self unlockScreen];
            [self addNewFBInfoToPFUser];
        } else {
            NSLog(@"User with facebook logged in!");
            [self unlockScreen];
            // Get user's Facebook data
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                [self.weak_currentUser updateUserWithFBUser:result];
            }];
        }
    }];
}

-(void)pressedTwitterLogin:(id)sender{
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            [self unlockScreen];
            //[self addNewTWInfoToPFUser];
            NSLog(@"user");
        } else {
            NSLog(@"User logged in with Twitter!");
            [self unlockScreen];
            // Get user's Twitter data
            NSLog(@"user");
        }
    }];
}

#pragma mark - Parse

-(void)addNewFBInfoToPFUser{
    // Get user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        [PFUser currentUser][@"first_name"] = result[@"first_name"];
        [PFUser currentUser][@"last_name"] = result[@"last_name"];
        [PFUser currentUser][@"account_type"] = [NSNumber numberWithInteger:kFacebook];
        [PFUser currentUser][@"avatar_location"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",result[@"id"]];
        [[PFUser currentUser] saveInBackground];
    }];
}

#pragma mark - TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    switch (textField.tag) {
        case kLoginUsernameTxtTag:
            
            break;
        case kLoginPasswordTxtTag:
            [self.loginView.btnLogin setEnabled:YES];
            break;
    }
}

#pragma mark - Self Defined

-(void)unlockScreen{
    [self.loginView unlockScreen:YES];
    [self.delegate openProfileView];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
