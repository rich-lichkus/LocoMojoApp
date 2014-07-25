//
//  CKConstants.h
//  LocoMojo
//
//  Created by Richard Lichkus on 7/23/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//


typedef NS_ENUM (NSInteger, kAccountType){
    kFacebook=0,
    kTwitter,
    kEmail
};

typedef NS_ENUM (NSInteger, kDirection){
    kLeft=0,
    kRight,
    kUp,
    kDown
};

typedef NS_ENUM (NSInteger, kLoginElementTags){
    kLoginUsernameTxtTag = 0,
    kLoginPasswordTxtTag
};

typedef NS_ENUM (NSInteger, kOAuthService){
    kFacebookOAuth=0,
    kTwitterOAuth
};

typedef NS_ENUM (NSInteger, kPinType){
    kVisible=0,
    kReadable
};