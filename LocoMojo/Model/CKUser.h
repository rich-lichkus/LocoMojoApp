//
//  CKUser.h
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *iD;
@property (nonatomic) kAccountType accountType;

@end
