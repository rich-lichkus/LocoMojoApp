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

-(void)updateUserWithPFUser:(PFUser *)pfUser{
    self.name = pfUser[@"name"];
    self.username = pfUser.username;
    self.userId = pfUser.objectId;
    self.accountType = (kAccountType)pfUser[@"account_type"];
    self.email = pfUser.email;
}

@end
