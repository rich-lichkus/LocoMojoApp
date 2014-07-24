//
//  CKPost.h
//  LocoMojo
//
//  Created by Richard Lichkus on 7/24/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKUser.h"
@class CKUser;

@interface CKPost : NSObject

@property (strong, nonatomic) NSString *iD;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) CKUser *user;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSDate *createdAt;

-(instancetype)initWithPfPost:(PFObject*)postObject;

@end
