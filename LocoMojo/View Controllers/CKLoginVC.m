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

-(void)configureCurrentUser{
    
    NSLog(@"configureCurrentUser");
    BOOL unlock = NO;
    if([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        NSLog(@"Facebook!");
        unlock = YES;
    } else if([PFUser currentUser] && [PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]){
        NSLog(@"Twitter!");
        unlock = YES;
    } else if ([PFUser currentUser].isAuthenticated){
        NSLog(@"Email!");
        unlock = YES;
    }
    if(unlock){
        [self.loginView unlockScreen:unlock];
        [self.delegate openProfileView];
    }
}

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
    [self.loginView.txtPassword resignFirstResponder];
    if(self.loginView.txtPassword.text.length >0 && self.loginView.txtPassword.text.length >0){
        [PFUser logInWithUsernameInBackground:self.loginView.txtUsername.text password:self.loginView.txtPassword.text block:^(PFUser *user, NSError *error) {
            if(!error){
                [self.weak_currentUser updateUserWithPFUser:user];
                [self unlockScreen];
                self.loginView.txtPassword.text = @"";
                self.loginView.txtUsername.text = @"";
                self.loginView.btnLogin.enabled = NO;
                [self.delegate setUsername];
            } else {
                [self handleLoginError:error];
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
                [self.loginView showErrorMessage:@"Facebook login canceled." willShow:YES];
            } else {
                [self handleLoginError:error];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self unlockScreen];
            [self addNewFBInfoToPFUser];
            [self.weak_currentUser updateUserWithFBUser:user];
            [self.delegate setUsername];
        } else {
            NSLog(@"User with facebook logged in!");
            [self unlockScreen];
            // Get user's Facebook data
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                [self.weak_currentUser updateUserWithFBUser:result];
                [self.delegate setUsername];
            }];
        }
    }];
}

-(void)pressedTwitterLogin:(id)sender{
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (!user) {
            if(!error){
                NSLog(@"The user cancelled the Twitter login.");
            } else {
                [self handleLoginError:error];
            }
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in with Twitter!");
            NSString *twitterUsername = [[PFTwitterUtils twitter] screenName];
        
            NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSString * requestString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", twitterUsername];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
            [[PFTwitterUtils twitter] signRequest:request];
            NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {                
                NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (!error) {
                    NSArray *nameArray = [result[@"name"] componentsSeparatedByString:@" "];
                    user[@"first_name"] = nameArray[0];
                    user[@"last_name"] = nameArray[1];
                    user[@"account_type"] = [NSNumber numberWithInteger: kTwitter];
                    user[@"avatar_location"] = [result[@"profile_image_url_https"] stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
                    [user saveEventually];
                    [self.weak_currentUser updateUserWithTWUser:user];
                    [self.delegate setUsername];
                }
            }];
            [dataTask resume];
            [self unlockScreen];

        } else {
            NSLog(@"User logged in with Twitter!");
            [self.weak_currentUser updateUserWithTWUser:user];
            [self unlockScreen];
            [self.delegate setUsername];
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
        case kLoginPasswordTxtTag:{
            [self.loginView.btnLogin setEnabled:YES];
        }
            break;
    }
}

#pragma mark - Self Defined

-(void)unlockScreen{
    [self.loginView showErrorMessage:nil willShow:NO];
    [self.loginView unlockScreen:YES];
    [self.delegate openProfileView];
}

-(void)handleLoginError:(id)error{
    
    NSString *errorMessage;
    
    if([error isKindOfClass:[NSError class]]){
        
        NSError *nsError = (NSError*)error;
        
        switch ([nsError.userInfo[@"code"] integerValue]) {
            case 101:
                 errorMessage = @"Invalid Credentials.";
                break;
            default:
                 errorMessage = @"Error Occurred.";
                break;
        }
    }
    
    [self.loginView showErrorMessage:errorMessage willShow:YES];
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
