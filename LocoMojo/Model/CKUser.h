//
//  CKUser.h
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CKUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;
@property (nonatomic) kAccountType accountType;
@property (strong, nonatomic) NSString *email;

-(void)updateUserWithPFUser:(PFUser*)pfUser;
//TODO:-(void)updateUserWithFBUser:(*)fbUser;
//TODO:-(void)updateUserWithTWUser:(*)twUser;

@end
