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
        NSInteger accountType = [postObject[@"creator"][@"account_type"] integerValue];
        switch ((kAccountType)accountType) {
            case kFacebook: {
                self.user = [[CKUser alloc] initUserWithFBUser:postObject[@"creator"]];
            }
                break;
            case kEmail: {
                self.user = [[CKUser alloc] initUserWithPFUser:postObject[@"creator"]];
            }
                break;
            case kTwitter: {
                self.user = [[CKUser alloc] initUserWithTWUser:postObject[@"creator"]];
            }
                break;
        }
    
        PFGeoPoint *pfGeoPoint = postObject[@"location"];
        self.location = [[CLLocation alloc] initWithLatitude:pfGeoPoint.latitude longitude:pfGeoPoint.longitude];
        self.message = postObject[@"messageString"];
    }
    return self;
}

@end
