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
        self.name = pfUser[@"name"];
        self.username = pfUser.username;
        self.userId = pfUser.objectId;
        self.accountType = (kAccountType)pfUser[@"account_type"];
        self.email = pfUser.email;
    }
    return self;
}

-(void)updateUserWithPFUser:(PFUser *)pfUser{
    self.name = pfUser[@"name"];
    self.username = pfUser.username;
    self.userId = pfUser.objectId;
    self.accountType = (kAccountType)pfUser[@"account_type"];
    self.email = pfUser.email;
}

#pragma mark

-(void)setRegionalPostsWithArrayofPfPosts:(NSArray*)pfPosts{
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    for (PFObject *pfPost in pfPosts)
    {
        CKPost *post = [[CKPost alloc] initWithPfPost:pfPost];
        [posts addObject:post];
    }
    _regionalPosts = posts;
}

@end
