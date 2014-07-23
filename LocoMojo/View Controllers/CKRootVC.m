//
//  CKRootVC.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKRootVC.h"
#import "CKMapVC.h"
#import "CKMessageVC.h"
#import "CKMojoVC.h"

@interface CKRootVC ()

@property (strong, nonatomic) CKMapVC *mapVC;
@property (strong, nonatomic) CKMessageVC *messageVC;
@property (strong, nonatomic) CKMojoVC *mojoVC;
 
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
}

#pragma mark - Configuration
-(void)configureChildViews{
    // Mojo VC
    [self addChildViewController:self.mojoVC];
    [self.mojoVC didMoveToParentViewController:self];
    [self.view addSubview:self.mojoVC.view];

    // Map VC
    [self addChildViewController:self.mapVC];
    [self.mapVC didMoveToParentViewController:self];
    [self.view addSubview:self.mapVC.view];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
