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

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;
@property (nonatomic) kAccountType accountType;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *avatarLocation;

@property (strong, nonatomic) CLLocation *lastLocation;
@property (strong, nonatomic) CLLocation *regionalLocation;
@property (strong, nonatomic) NSMutableArray *regionalPosts;

-(instancetype)initUserWithPFUser:(PFUser*)pfUser;
-(instancetype)initUserWithFBUser:(PFUser*)fbUser;
-(instancetype)initUserWithTWUser:(PFUser*)twUser;
-(void)updateUserWithPFUser:(PFUser*)pfUser;
-(void)updateUserWithFBUser:(PFUser*)fbUser;
-(void)updateUserWithTWUser:(PFUser*)twUser;

-(void)setRegionalPostsWithArrayofPfPosts:(NSArray*)pfPosts;
-(void)addRegionalPostWithPfPost:(PFObject*)pfPost;

@end
