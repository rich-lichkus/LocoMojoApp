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
#import "PCLocoMojo.h"

@interface CKMojoVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *openPosts;
@property (weak, nonatomic) IBOutlet UITableView *tblFeed;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiAddMessage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiMap;

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
    
    [self configureUIElements];
}

#pragma mark - Configuration

-(void)configureTableView{
    self.tblFeed.delegate = self;
    self.tblFeed.dataSource = self;
}

-(void)configureUIElements{
    self.bbiAddMessage.image = [PCLocoMojo imageOfAdd];
    self.bbiMap.image = [PCLocoMojo imageOfMapIcon];
}

#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.openPosts.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mojoCell" forIndexPath:indexPath];
    
    CKPost *post = self.openPosts[indexPath.row];

    cell.textLabel.text = post.message;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = post.user.name;
//    cell.imageView.image = [PCLocoMojo imageOfAvatar];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellText = ((CKPost*)self.openPosts[indexPath.row]).message;

    UIFont *FONT = [UIFont systemFontOfSize:14];
    NSAttributedString *attributedText =[[NSAttributedString alloc]  initWithString:cellText
                                                                         attributes:@{NSFontAttributeName:FONT}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){300, MAXFLOAT}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size.height+40;
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
