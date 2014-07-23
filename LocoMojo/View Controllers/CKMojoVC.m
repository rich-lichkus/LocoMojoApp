//
//  CKMojoVC.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKMojoVC.h"

@interface CKMojoVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblFeed;

@end

@implementation CKMojoVC

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
    
    [self configureTableView];
}

#pragma mark - Configuration

-(void)configureTableView{
    self.tblFeed.delegate = self;
    self.tblFeed.dataSource = self;
}

#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mojoCell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"Post";
    return cell;
}

#pragma mark - Target Actions

-(IBAction)pressedBarButton:(id)sender{
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    switch (button.tag) {
        case 0:
        {
            [self.delegate didPressMap];
        }
            break;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
