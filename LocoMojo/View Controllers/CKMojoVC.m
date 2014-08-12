//
//  CKMojoVC.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKMojoVC.h"
#import "CKMessageVC.h"
#import "CKUser.h"
#import "PCLocoMojo.h"
#import "CKMessageCell.h"
#import "CKLeftMessageBubbleView.h"

@interface CKMojoVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *openPosts;
@property (weak, nonatomic) IBOutlet UITableView *tblFeed;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiAddMessage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbiMap;

@property (nonatomic) CGRect cellRect;

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
    self.bbiAddMessage.image = [PCLocoMojo imageOfChat];
    self.bbiMap.image = [PCLocoMojo imageOfPin];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tblFeed addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(updatePosts:) forControlEvents:UIControlEventValueChanged];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,50,30)];
    titleLabel.text = @"LocoMojo";
    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0f]];
    self.navBar.topItem.titleView = titleLabel;
}

#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.openPosts.count==0){
        return 1;
    }else{
        return self.openPosts.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(self.openPosts.count ==0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
        cell.textLabel.text = @"Add the first pin in this region!";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        return cell;
    } else{
        CKMessageCell *bubbleCell = [tableView dequeueReusableCellWithIdentifier:@"mojoCell" forIndexPath:indexPath];
        
        CKPost *post = self.openPosts[indexPath.row];
        //if ([post.user.userId isEqualToString: [PFUser currentUser].objectId]){
            [bubbleCell updateRightFrame:bubbleCell.bounds];
        //}else{
        //  [bubbleCell updateLeftFrame:bubbleCell.bounds];
        //}
        bubbleCell.lblTitle.text = post.message;
        bubbleCell.lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
        bubbleCell.lblTitle.numberOfLines = 0;
        bubbleCell.lblName.text = [[post.user.firstName stringByAppendingString:@" "] stringByAppendingString:post.user.lastName];
        
        return bubbleCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(self.openPosts.count !=0){
        NSString *cellText = ((CKPost*)self.openPosts[indexPath.row]).message;

        UIFont *FONT = [UIFont systemFontOfSize:16];
        NSAttributedString *attributedText =[[NSAttributedString alloc]  initWithString:cellText
                                                                             attributes:@{NSFontAttributeName:FONT}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){300, MAXFLOAT}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        self.cellRect = rect;
        return rect.size.height+40;
    }
    return 50;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    if(self.openPosts.count !=0){
        if([self.openPosts[indexPath.row] isKindOfClass: CKPost.class]){
            CKPost *post = (CKPost*)self.openPosts[indexPath.row];
            if ([post.user.userId isEqualToString: [PFUser currentUser].objectId])
            {
                return YES;
            }
        }
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if([self.openPosts[indexPath.row] isKindOfClass: CKPost.class]){
            CKPost *post = (CKPost*)self.openPosts[indexPath.row];
            PFQuery *query = [PFQuery queryWithClassName:@"post"];
            [query whereKey:@"objectId" equalTo:post.iD];
            
            [tableView beginUpdates];
            [self.openPosts removeObjectAtIndex:indexPath.row];
            [self.tblFeed deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
            
            [self.delegate removeRegionalPost:post];
            [tableView reloadData];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(objects.count > 0) {
                    [objects[0] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) { 
                    }];
                }
            }];
        }
    }
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

-(void)updatePosts:(id)sender{
    [self.delegate updatePosts];
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
