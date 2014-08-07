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

#import "CKLoginView.h"
#import "CKLoginVC.h"

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

@interface CKRootVC () <CKMojoVCDelegate,CKMapVCDelegate, UITextFieldDelegate, CLLocationManagerDelegate, CKMessageVCDelegate, UIActionSheetDelegate, CKLoginVCDelegate>

@property (nonatomic) BOOL regionalPostsLoaded;

@property (strong, nonatomic) CKMapVC *mapVC;
@property (strong, nonatomic) CKMessageVC *messageVC;
@property (strong, nonatomic) CKMojoVC *mojoVC;
@property (strong, nonatomic) CKLoginVC *loginVC;
@property (strong, nonatomic) CLLocation *lastLocation;
@property (strong, nonatomic) NSDate *lastLocationDate;

// Weak
@property (weak, nonatomic) CKAppDelegate *weak_appDelegate;
@property (weak, nonatomic) CKOAuthController *weak_oAuthController;
@property (weak, nonatomic) CKFacebookNC *weak_facebookNC;
@property (weak, nonatomic) CKTwitterNC *weak_twitterNC;
@property (weak, nonatomic) CKUser *weak_currentUser;

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
    
    [self configureProfileView];
    
    [self configureControllers];
    
    [self configureChildViews];
    
    self.regionalPostsLoaded = NO;
}

#pragma mark - Configuration

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
    NSLog(@"Profile view");
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
    
    // Login VC
    [self addChildViewController:self.loginVC];
    [self.loginVC didMoveToParentViewController:self];
    [self.view addSubview:self.loginVC.view];
    self.loginVC.delegate = self;
    [self.loginVC configureCurrentUser];
    NSLog(@"set delegate");
}

-(void)configureControllers {

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
            [self.loginVC.loginView unlockScreen:NO];
        }
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

#pragma mark - Login Delegate

-(void)openProfileView{
    [self showProfileView:YES];
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
    [self.view bringSubviewToFront:self.userView];
    NSLog(@"%@", NSStringFromCGRect(self.userView.frame));
    dy = show ? -dy : dy;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [UIView animateWithDuration:.3 animations:^{
            self.userView.frame = CGRectOffset(self.userView.frame, 0, dy);
            NSLog(@"%@", NSStringFromCGRect(self.userView.frame));
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

-(CKLoginVC*)loginVC{
    if(!_loginVC){
        _loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        _loginVC.view.frame = self.view.frame;
        _loginVC.view.backgroundColor = [UIColor clearColor];
    }
    return _loginVC;
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
