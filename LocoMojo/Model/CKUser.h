//
//  CKUser.h
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CKPost.h"

@interface CKUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;
@property (nonatomic) kAccountType accountType;
@property (strong, nonatomic) NSString *email;

@property (strong, nonatomic) CLLocation *regionalLocation;
@property (strong, nonatomic) NSMutableArray *regionalPosts;

-(instancetype)initUserWithPFUser:(PFUser*)pfUser;
-(void)updateUserWithPFUser:(PFUser*)pfUser;
//TODO:-(void)updateUserWithFBUser:(*)fbUser;
//TODO:-(void)updateUserWithTWUser:(*)twUser;

-(void)setRegionalPostsWithArrayofPfPosts:(NSArray*)pfPosts;

@end
