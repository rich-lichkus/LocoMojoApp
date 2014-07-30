//
//  CKOAuthController.m
//  GitHubClient
//
//  Created by Richard Lichkus on 7/15/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

#import "CKAppDelegate.h"
#import "CKOAuthController.h"
#import <Parse/Parse.h>

// ! Parse Dependent Format: //key=value!key=value...key=value?
#define GENERIC_CALLBACK_URI @"igithub://web_service=%zd!call_back=%zd"
#define GENERIC_ACCESS_KEY @"web_service=%zd!asset=%zd"

//// Facebook

//// Twitter

@interface CKOAuthController () <NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (weak, nonatomic) CKUser *weak_currentUser;
@property (strong, nonatomic) NSString *gitHubAccessToken;

@end

@implementation CKOAuthController

-(instancetype)initWithCurrentUser:(CKUser*)currentUser{
    self = [super init];
    if(self){
        self.weak_currentUser = currentUser;
    }
    return self;
}

-(void)authenticateUserWithWebService:(kOAuthService)name{
    
    NSString *requestAuthenticationURL;
    BOOL authenticated = NO;
    
    switch (name) {
        case kFacebookOAuth: {
        
        }
            break;
        case kTwitterOAuth: {
        
        }
            break;
    }
    if(!authenticated){
        // Open request authentication url in safari
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestAuthenticationURL]];
        // Redirect will call method in app delegate
    }
}

-(void)processWebServiceCallback:(NSURL*)url {
    
    NSMutableDictionary *callBackComponents = [self parseCallBackComponents:url];
    
    switch ([[callBackComponents objectForKey:@"web_service"] integerValue]) {
        case kFacebook: {
            
        }
            break;
        case kTwitter: {
            
        }
            break;
    }
}

#pragma mark - Session Delegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    NSLog(@"%lu", (unsigned long)dataTask.taskIdentifier);
    NSLog(@"%@", dataTask.taskDescription);
    NSLog(@"Delegate Called.");
}

#pragma mark - Data Delegate 
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *))completionHandler{
    NSLog(@"%@",proposedResponse);
}

#pragma mark - Parsing Functions
-(NSMutableDictionary*)parseCallBackComponents:(NSURL*)callback{
    
    NSArray *callBackComponents = [callback.host componentsSeparatedByString:@"!"];
    NSMutableDictionary *callbackParams = [[NSMutableDictionary alloc] init];
    
    for (NSString *component in callBackComponents) {
        NSArray *params = [component componentsSeparatedByString:@"="];
        [callbackParams setObject:[NSNumber numberWithInteger:[params[1] integerValue]] forKey:params[0]];
    }
    return callbackParams;
}


@end
