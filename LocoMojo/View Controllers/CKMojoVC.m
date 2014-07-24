//
//  CKMojoVC.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKMojoVC.h"
#import "CKMessageVC.h"
#import "CKPost.h"

@interface CKMojoVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *openPosts;

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
    return self.openPosts.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mojoCell" forIndexPath:indexPath];
    
    CKPost *post = self.openPosts[indexPath.row];
    cell.textLabel.text = post.message;
    cell.detailTextLabel.text = post.user.name;
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
        case 1:
        {
            [self.delegate didPressNote];
        }
            break;
    }
}

#pragma mark - Methods
-(void)updateOpenPosts:(NSMutableArray *)posts{
    _openPosts = posts;
    [self.tblFeed reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

#pragma mark - Lazy

-(NSMutableArray*)openPosts{
    if(!_openPosts){
        _openPosts = [[NSMutableArray alloc] init];
    }
    return _openPosts;
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
