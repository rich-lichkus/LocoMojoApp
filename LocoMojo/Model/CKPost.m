//
//  CKPost.m
//  LocoMojo
//
//  Created by Richard Lichkus on 7/24/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKPost.h"

@interface CKPost()

@end

@implementation CKPost

-(instancetype)initWithPfPost:(PFObject *)postObject{
    self = [super init];
    if(self){
        self.iD = postObject.objectId;
        self.createdAt = postObject.createdAt;
        self.user = [[CKUser alloc] initUserWithPFUser:postObject[@"creator"]];
        PFGeoPoint *pfGeoPoint = postObject[@"location"];
        self.location = [[CLLocation alloc] initWithLatitude:pfGeoPoint.latitude longitude:pfGeoPoint.longitude];
        self.message = postObject[@"messageString"];
    }
    return self;
}

@end
