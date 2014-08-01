//
//  CKRootVC.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKAppDelegate.h"
#import "CKRootVC.h"
#import "CKMapVC.h"
#import "CKMessageVC.h"
#import "CKMojoVC.h"
#import "PCLocoMojo.h"

#define CELL_SEPARATOR_HEIGHT 1
#define PERCENTAGE_VIEW_WIDTH .70
#define TEXTFIELD_HEIGHT 40
#define UIBUTTON_HEIGHT 40
#define TEXTFIELD_PADDING 10

#define UPPER_BOUND_INTERVAL_SEC 60.0
#define REGION_SIZE 10       // Kilo
#define REGION_EDGE_BUFFER 2 // Kilo
#define VISIBLE_REGION 2000  // Meters
#define READABLE_REGION 150  // Meters

@interface CKRootVC () <CKMojoVCDelegate,CKMapVCDelegate, UITextFieldDelegate, CLLocationManagerDelegate, CKMessageVCDelegate, UIActionSheetDelegate>

@property (nonatomic) BOOL regionalPostsLoaded;

@property (strong, nonatomic) CKMapVC *mapVC;
@property (strong, nonatomic) CKMessageVC *messageVC;
@property (strong, nonatomic) CKMojoVC *mojoVC;
@property (strong, nonatomic) CLLocation *lastLocation;
@property (strong, nonatomic) NSDate *lastLocationDate;

// Weak
@property (weak, nonatomic) CKAppDelegate *weak_appDelegate;
@property (weak, nonatomic) CKOAuthController *weak_oAuthController;
@property (weak, nonatomic) CKFacebookNC *weak_facebookNC;
@property (weak, nonatomic) CKTwitterNC *weak_twitterNC;
@property (weak, nonatomic) CKUser *weak_currentUser;

// Lock Screen
@property (strong, nonatomic) UIView *uivTopView;
@property (strong, nonatomic) UIButton *btnFacebook;
@property (strong, nonatomic) UIButton *btnTwitter;
@property (strong, nonatomic) UITextField *txtUsername;
@property (strong, nonatomic) UITextField *txtPassword;

@property (strong, nonatomic) UIView *uivBottomView;
@property (strong, nonatomic) UIButton *btnLogin;

// Profile View
@property (strong, nonatomic) UIView *userView;
@property (strong, nonatomic) UIImageView *imgAvatar;
@property (strong, nonatomic) UIButton *btnUsername;

@end

@implementation CKRootVC

#pragma mark - Intialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureChildViews];
    
    [self configureLockView];
    
    [self configureProfileView];
    
    self.regionalPostsLoaded = NO;
    
     [self configureCurrentUser];
}

#pragma mark - Configuration

-(void)configureCurrentUser{
    BOOL unlock = NO;
    if([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
        NSLog(@"Facebook!");
        unlock = YES;
    } else if ([PFUser currentUser].isAuthenticated){
        NSLog(@"Email!");
        unlock = YES;
    }
    if(unlock){
        [self unlockScreen:unlock];
        [self showProfileView:YES];
    }
}

-(void)configureProfileView{
    
    CGFloat viewHeight = 44;
    CGFloat imgSide = 40;
    CGFloat padding = 5;
    CGFloat imgPadding = 2;
    
    self.userView = [[UIView alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, viewHeight)];
    self.userView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    
    self.imgAvatar = [[UIImageView alloc] initWithFrame: CGRectMake(imgPadding, imgPadding, imgSide, imgSide)];
    self.imgAvatar.image = [UIImage imageNamed:@"profile"];
    self.imgAvatar.layer.cornerRadius = 5;
    self.imgAvatar.layer.masksToBounds = YES;
    
    self.btnUsername = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnUsername.frame = CGRectMake(self.imgAvatar.frame.size.width+padding, 0,
                                        self.userView.frame.size.width-2*self.imgAvatar.frame.size.width-2*imgPadding-2*padding, viewHeight);
    [self.btnUsername setTitle:@"Richard Lichkus" forState:UIControlStateNormal];
    [self.btnUsername addTarget:self action:@selector(pressedUsername:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.userView addSubview:self.imgAvatar];
    [self.userView addSubview:self.btnUsername];
    [self.view addSubview:self.userView];
}


-(void)configureChildViews{
    // Mojo VC
    [self addChildViewController:self.mojoVC];
    [self.mojoVC didMoveToParentViewController:self];
    [self.view addSubview:self.mojoVC.view];
    self.mojoVC.delegate = self;

    // Map VC
    [self addChildViewController:self.mapVC];
    [self.mapVC didMoveToParentViewController:self];
    [self.view addSubview:self.mapVC.view];
    self.mapVC.delegate = self;
    
    // Messages VC
    [self addChildViewController:self.messageVC];
    [self.messageVC didMoveToParentViewController:self];
    [self.view addSubview:self.messageVC.view]; 
    self.messageVC.delegate = self;
}

-(void)configureLockView{
        
    float halfScreen = self.view.frame.size.height*.5;
    float uiElementWidth = self.view.frame.size.width*.75;
    
    // Lock Screen Top View
    self.uivTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                               self.view.frame.size.width,
                                                               halfScreen)];
    self.uivTopView.backgroundColor = [UIColor whiteColor];
    
    self.btnFacebook = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x-(uiElementWidth*.5),
                                                                self.uivTopView.frame.size.height - (4*TEXTFIELD_HEIGHT+4*TEXTFIELD_PADDING),
                                                                uiElementWidth*.5-TEXTFIELD_PADDING*.5,
                                                                TEXTFIELD_HEIGHT)];
    [self.btnFacebook setBackgroundImage:[PCLocoMojo imageOfFacebookLogin] forState:UIControlStateNormal];
    [self.btnFacebook addTarget:self action:@selector(pressedFacebookLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnFacebook setTitle:@"Facebook" forState:UIControlStateNormal];
    
    self.btnTwitter = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x+TEXTFIELD_PADDING*.5,
                                                                  self.uivTopView.frame.size.height - (4*TEXTFIELD_HEIGHT+4*TEXTFIELD_PADDING),
                                                                  uiElementWidth*.5,
                                                                  TEXTFIELD_HEIGHT)];
    [self.btnTwitter setBackgroundImage:[PCLocoMojo imageOfLoginTwitter] forState:UIControlStateNormal];
    [self.btnTwitter addTarget:self action:@selector(pressedTwitterLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnTwitter setTitle:@"Twitter" forState:UIControlStateNormal];
    
    
    self.txtUsername = [[UITextField alloc] initWithFrame:CGRectMake(self.view.center.x-(uiElementWidth*.5),
                                                                     self.uivTopView.frame.size.height - (2*TEXTFIELD_HEIGHT+2*TEXTFIELD_PADDING),
                                                                     uiElementWidth,
                                                                     TEXTFIELD_HEIGHT)];
    self.txtUsername.borderStyle = UITextBorderStyleRoundedRect;
    self.txtUsername.backgroundColor = [UIColor colorWithWhite:0.800 alpha:0.250];
    self.txtUsername.placeholder = @"Username";
    self.txtUsername.delegate = self;
    self.txtUsername.tag = kLoginUsernameTxtTag;
    
    self.txtPassword = [[UITextField alloc] initWithFrame:CGRectMake(self.view.center.x-(uiElementWidth*.5),
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
    [self.view addSubview:self.uivTopView];
    
    // Lock Screen Bottom View
    self.uivBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, halfScreen,
                                                                  self.view.frame.size.width, halfScreen)];
    self.uivBottomView.backgroundColor = [UIColor whiteColor];
    
    self.btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x-(uiElementWidth*.5), 0, uiElementWidth, UIBUTTON_HEIGHT)];
    [self.btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    self.btnLogin.enabled = NO;
    [self.btnLogin setBackgroundImage:[PCLocoMojo imageOfLoginDisabled] forState:UIControlStateDisabled];
    [self.btnLogin setBackgroundImage:[PCLocoMojo imageOfLoginNormal] forState:UIControlStateNormal];
    self.btnLogin.layer.cornerRadius = 5;
    self.btnLogin.layer.masksToBounds = YES;
    [self.btnLogin addTarget:self action:@selector(pressedLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.uivBottomView addSubview:self.btnLogin];
    [self.view addSubview:self.uivBottomView];
    
    // App Delegate
    self.weak_appDelegate = (CKAppDelegate *)[UIApplication sharedApplication].delegate;
    self.weak_currentUser = self.weak_appDelegate.currentUser;
    
    // Core Location
    self.weak_appDelegate.locationManager.delegate = self;
    [self.weak_appDelegate.locationManager startUpdatingLocation];

    // OAuth Controller
    self.weak_oAuthController = self.weak_appDelegate.oAuthController;
    
    // Facebook NC
    self.weak_facebookNC = self.weak_appDelegate.facebookNC;
    
    //  Twitter NC
    self.weak_twitterNC = self.weak_appDelegate.twitterNC;
}

#pragma mark - Target Action

-(void)pressedLogin:(id)sender{
// TODO: Handle parse error and/or display
    [self.txtPassword resignFirstResponder];
    if(self.txtPassword.text.length >0 && self.txtUsername.text.length >0){
        [PFUser logInWithUsernameInBackground:self.txtUsername.text password:self.txtPassword.text block:^(PFUser *user, NSError *error) {
            if(!error){
                [self.weak_currentUser updateUserWithPFUser:user];
                [self unlockScreen:YES];
                [self showProfileView:YES];
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
            [self unlockScreen:YES];
            [self showProfileView:YES];
            [self addNewFBInfoToPFUser];
        } else {
            NSLog(@"User with facebook logged in!");
            [self unlockScreen:YES];
            [self showProfileView:YES];
            // Get user's Facebook data
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                [self.weak_currentUser updateUserWithFBUser:result];
            }];
        }
    }];
}

-(void)pressedTwitterLogin:(id)sender{
    //[self.weak_oAuthController authenticateUserWithWebService:kTwitter];
}

-(void)pressedUsername:(id)sender{
    // TODO: Present Action sheet to log out, options based on account used to sign in
    NSLog(@"Pressed Username");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Logout?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Logout", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - Action Sheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            [PFUser logOut];
            [self showProfileView:NO];
            [self unlockScreen:NO];
        }
            break;
    }
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

#pragma mark - Mojo Delegate

-(void)didPressMap{
    [self slideViews:kRight];
    [self showProfileView:NO];
}

-(void)didPressNote{
    [self slideViews:kLeft];
    [self showProfileView:NO];
}

#pragma mark - Map Delegate

-(void)didPressMojo{
    [self slideViews:kLeft];
    [self showProfileView:YES];
}

#pragma mark - Message Delegate

-(void)didPressCancel{
    [self slideViews:kRight];
    [self showProfileView:YES];
}

-(void)postMessage:(NSString *)message{
    [self parsePostMessage:message];
}

#pragma mark - Core Location Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *lastLocation = [locations lastObject];
    self.weak_currentUser.lastLocation = lastLocation;
    self.lastLocationDate = lastLocation.timestamp;
    self.lastLocation = lastLocation;
    [self updatePostMessages:lastLocation];
    [self.messageVC setTextForGPSLabel:self.lastLocation];
}

#pragma mark - Animation

-(void)showProfileView:(BOOL)show{

    CGFloat dy = self.userView.frame.size.height;
    dy = show ? -dy : dy;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [UIView animateWithDuration:.3 animations:^{
            self.userView.frame = CGRectOffset(self.userView.frame, 0, dy);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

-(void)slideViews:(kDirection)direction{
    
    // kRight is 1, =+width
    CGFloat width = self.view.frame.size.width;
    CGFloat dx = direction ? width : -width;
    
    [UIView animateWithDuration:.3 animations:^{
        self.mojoVC.view.frame = CGRectOffset(self.mojoVC.view.frame, dx, 0);
        self.mapVC.view.frame = CGRectOffset(self.mapVC.view.frame, dx, 0);
        self.messageVC.view.frame = CGRectOffset(self.messageVC.view.frame, dx, 0);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)slideMessages:(kDirection)direction{
    [self.view bringSubviewToFront:self.messageVC.view];
    // kUp is 2, =+height
    CGFloat height = self.view.frame.size.height;
    CGFloat dy = direction-2 ? height : -height;
    
    [UIView animateWithDuration:.3 animations:^{
        self.messageVC.view.frame = CGRectOffset(self.messageVC.view.frame, 0, dy);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)unlockScreen:(BOOL)authenticated{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        int halfScreen = self.view.frame.size.height*.5;
        int dy = authenticated ? -halfScreen : halfScreen;
        
        [UIView animateWithDuration:.5 animations:^{
            self.uivTopView.frame = CGRectOffset(self.uivTopView.frame, 0, dy);
            self.uivBottomView.frame = CGRectOffset(self.uivBottomView.frame, 0, -dy);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

#pragma mark - Parse

-(void)parsePostMessage:(NSString*)message{
    PFObject *pfMessage = [PFObject objectWithClassName:@"post"];
    pfMessage[@"messageString"] = message;
    pfMessage[@"creator"] = [PFUser currentUser];
    PFGeoPoint *pfLocation = [PFGeoPoint geoPointWithLocation:self.lastLocation];
    pfMessage[@"location"] = pfLocation;
    [pfMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            NSAssert(error, @"Error saving post.");
            NSLog(@"%@",error);
        } else{
            [self slideViews:kRight];
            [self.weak_currentUser addRegionalPostWithPfPost:pfMessage];
            [self updateFilteredPosts:self.weak_currentUser.lastLocation];
            [self showProfileView:YES];
        }
    }];
}


-(void)updatePostMessages:(CLLocation*)userLocation{
    
    // If no regional posts or close to region's edge => Get new regional posts
    NSLog(@"should update parse?");
    if(!self.regionalPostsLoaded || [self.weak_currentUser.regionalLocation distanceFromLocation:userLocation] > REGION_SIZE-REGION_EDGE_BUFFER){
        self.regionalPostsLoaded = YES;
        PFQuery *geoQuery = [PFQuery queryWithClassName:@"post"];
        geoQuery.limit = 100;
        [geoQuery includeKey:@"creator"];
        [geoQuery orderByAscending:@"createdAt"];
        [geoQuery  whereKey:@"location" nearGeoPoint:[PFGeoPoint geoPointWithLatitude:userLocation.coordinate.latitude
                                                                            longitude:userLocation.coordinate.longitude] withinKilometers:REGION_SIZE];
        NSLog(@"Querying parse");
        [geoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error){
                [self.weak_currentUser setRegionalPostsWithArrayofPfPosts:objects];
                [self updateFilteredPosts:userLocation];
            }
        }];
    }
    [self updateFilteredPosts:userLocation];
}

-(void)updateFilteredPosts:(CLLocation*)userLocation{
    NSMutableArray *visiblePosts = [[NSMutableArray alloc] init];
    NSMutableArray *readablePosts = [[NSMutableArray alloc] init];
    
    for(CKPost *post in self.weak_currentUser.regionalPosts)
    {
        double distance = [post.location distanceFromLocation:userLocation];
        if(distance <= READABLE_REGION){
            [readablePosts addObject:post];
        } else if (distance <= VISIBLE_REGION){
            [visiblePosts addObject:post];
        }
    }
    
    [self.mapVC updateVisiblePosts:[visiblePosts mutableCopy]];
    [self.mapVC updateOpenPosts:[readablePosts mutableCopy]];
    [self.mojoVC updateOpenPosts:[readablePosts mutableCopy]];
}

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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

#pragma mark - Lazy

-(CKMapVC*)mapVC{
    if(!_mapVC){
        _mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mapVC"];
        _mapVC.view.frame = CGRectOffset(self.view.frame,-self.view.frame.size.width,0);
    }
    return _mapVC;
}

-(CKMojoVC*)mojoVC{
    if(!_mojoVC){
        _mojoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mojoVC"];
        _mojoVC.view.frame = self.view.frame;
    }
    return _mojoVC;
}

-(CKMessageVC*)messageVC{
    if(!_messageVC){
        _messageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"messageVC"];
        _messageVC.view.frame = CGRectOffset(self.view.frame,self.view.frame.size.width,0);
    }
    return _messageVC;
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
