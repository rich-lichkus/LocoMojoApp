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

@interface CKRootVC () <CKMojoVCDelegate,CKMapVCDelegate, UITextFieldDelegate>

@property (strong, nonatomic) CKMapVC *mapVC;
@property (strong, nonatomic) CKMessageVC *messageVC;
@property (strong, nonatomic) CKMojoVC *mojoVC;

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
}

#pragma mark - Configuration
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
    
    // OAuth Controller
    self.weak_oAuthController = self.weak_appDelegate.oAuthController;
    
    // Facebook NC
    self.weak_facebookNC = self.weak_appDelegate.facebookNC;
    
    //  Twitter NC
    self.weak_twitterNC = self.weak_appDelegate.twitterNC;
}

#pragma mark - Target Action

-(void)pressedLogin:(id)sender{
    [self.txtPassword resignFirstResponder];
    if(self.txtPassword.text.length >0 && self.txtUsername.text.length >0){
        [PFUser logInWithUsernameInBackground:self.txtUsername.text password:self.txtPassword.text block:^(PFUser *user, NSError *error) {
            if(!error){
                [self.weak_currentUser updateUserWithPFUser:user];
                [self unlockScreen:YES];
            } else {
                // TODO: Handle parse error and/or display
                NSLog(@"%@",error.localizedDescription);
            }
        }];
    }
}

-(void)pressedFacebookLogin:(id)sender{
    //[self.weak_oAuthController authenticateUserWithWebService:kFacebook];
}

-(void)pressedTwitterLogin:(id)sender{
    //[self.weak_oAuthController authenticateUserWithWebService:kTwitter];
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

#pragma mark - Delegation

-(void)didPressMap{
    [self slideViews:kRight];
}

-(void)didPressMojo{
    [self slideViews:kLeft];
}

#pragma mark - Animation

-(void)slideViews:(kDirection)direction{
    
    // kRight is 1, =+width
    CGFloat width = self.view.frame.size.width;
    CGFloat dx = direction ? width : -width;
    
    [UIView animateWithDuration:.3 animations:^{
        self.mojoVC.view.frame = CGRectOffset(self.mojoVC.view.frame, dx, 0);
        self.mapVC.view.frame = CGRectOffset(self.mapVC.view.frame, dx, 0);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)unlockScreen:(BOOL)authenticated{
    int halfScreen = self.view.frame.size.height*.5;
    int dy = authenticated ? -halfScreen : halfScreen;
    
    [UIView animateWithDuration:.5 animations:^{
        self.uivTopView.frame = CGRectOffset(self.uivTopView.frame, 0, dy);
        self.uivBottomView.frame = CGRectOffset(self.uivBottomView.frame, 0, -dy);
    } completion:^(BOOL finished) {

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

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
