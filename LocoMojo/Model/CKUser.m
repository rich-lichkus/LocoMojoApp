//
//  CKUser.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKUser.h"

@interface CKUser()

@end

@implementation CKUser

-(instancetype)initUserWithPFUser:(PFUser*)pfUser{
    self = [super init];
    if(self){
        self.firstName = pfUser[@"first_name"];
        self.lastName = pfUser[@"last_name"];
        self.username = pfUser.username;
        self.userId = pfUser.objectId;
        self.accountType = (kAccountType)pfUser[@"account_type"];
        self.email = pfUser.email;
    }
    return self;
}

-(instancetype)initUserWithFBUser:(PFUser*)fbUser{
    self = [super init];
    if(self){
        self.firstName = fbUser[@"first_name"];
        self.lastName = fbUser[@"last_name"];
        self.accountType = kFacebook;
        self.userId = fbUser.objectId;
        self.username = fbUser[@"name"];
        self.avatarLocation = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", fbUser[@"id"]];
    }
    return self;
}

-(instancetype)initUserWithTWUser:(PFUser*)twUser{
    self = [super init];
    if (self){
        self.firstName = twUser[@"first_name"];
        self.lastName = twUser[@"last_name"];
        self.accountType = kTwitter;
        self.userId = twUser.objectId;
        self.username = [[PFTwitterUtils twitter] screenName];
        self.avatarLocation = twUser[@"avatar_location"];
    }
    return self;
}

-(void)updateUserWithPFUser:(PFUser *)pfUser{
    self.firstName = pfUser[@"first_name"];
    self.lastName = pfUser[@"last_name"];
    self.username = pfUser.username;
    self.userId = pfUser.objectId;
    self.accountType = (kAccountType)pfUser[@"account_type"];
    self.email = pfUser.email;
}

-(void)updateUserWithFBUser:(PFUser*)fbUser{
    self.firstName = fbUser[@"first_name"];
    self.lastName = fbUser[@"last_name"];
    self.accountType = kFacebook;
    self.userId = fbUser.objectId;
    self.username = fbUser[@"name"];
    self.avatarLocation = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", fbUser[@"id"]];
}

-(void)updateUserWithTWUser:(PFUser*)twUser{
    self.firstName = twUser[@"first_name"];
    self.lastName = twUser[@"last_name"];
    self.accountType = kTwitter;
    self.userId = twUser.objectId;
    self.username = [[PFTwitterUtils twitter] screenName];
    self.avatarLocation = twUser[@"avatar_location"];
}

#pragma mark - Posts

-(void)setRegionalPostsWithArrayofPfPosts:(NSArray*)pfPosts{
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    for (PFObject *pfPost in pfPosts)
    {
        CKPost *post = [[CKPost alloc] initWithPfPost:pfPost];
        [posts addObject:post];
    }
    _regionalPosts = posts;
}

-(void)addRegionalPostWithPfPost:(PFObject*)pfPost{
    CKPost *post = [[CKPost alloc] initWithPfPost:pfPost];
    [self.regionalPosts addObject:post];
}    

@end
