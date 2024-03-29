//
//  CKGitHubNetworkController.h
//  GitHubClient
//
//  Created by Richard Lichkus on 7/22/14.
//  Copyright (c) 2014 Richard Lichkus. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import "CKGitHubUser.h"
//

//// GitHub
//#define APPLICATION_NAME @"iGitHub"
//#define GITHUB_OAUTH_URL  @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@"
//#define GITHUB_CLIENT_ID @"b7e10d79af8fd54aae59"
//#define GITHUB_CLIENT_SECRET @"cda8f903365f93abe4f75c4d176591fdb4111895"
//#define GITHUB_POST_TOKEN_URL @"https://github.com/login/oauth/access_token"


//@protocol CKGitHubNCDataDelegate <NSObject>
//
//- (void)didDownload:(kGitHubDataType)dataType;
//
//@end
//
//@interface CKGitHubNetworkController : NSObject
//
//@property (nonatomic, unsafe_unretained) id<CKGitHubNCDataDelegate> dataDelegate;
//
//-(instancetype)initWithCurrentUser:(CKGitHubUser*)currentUser;
//
//-(void)setAccessToken:(NSString*)accessToken;
//
//-(void)retrieveAllData;
//-(void)retrieveRepos;
//-(void)retrieveUser;
//
//@end


////////////////////////////////////


//        case kGitHub: {
//            NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:GENERIC_ACCESS_KEY,kGitHub,kToken]];
//            if(accessToken){
//                self.gitHubAccessToken = accessToken;
//                NSAssert(self.gitHubAccessToken, @"Github access token is nil. Rectify.");
//                authenticated = YES;
//                [self.dataDelegate didAuthenticateUser:YES];
//
//            } else {
//                // Requesting a token with access to user info and user's public reposs
//                requestAuthenticationURL = [NSString stringWithFormat:GITHUB_OAUTH_URL,GITHUB_CLIENT_ID,[NSString stringWithFormat: GENERIC_CALLBACK_URI,kGitHub,kOAuth],@"user,public_repo"];
//                // On redirect, github will supply a temporary code in "code" parameter
//            }
//        }
//            break;


//////////////////////////////////////

//        case kGitHub: {
//            switch ([[callBackComponents objectForKey:@"call_back"] integerValue]) {
//                case kOAuth:
//                        [self gitHubRetrieveToken:url];
//                    break;
//            }
//        }
//            break;

//////////////////////////////////////

//-(NSString*)gitHubAccessToken{
//    return _gitHubAccessToken;
//}
//
//-(void)gitHubRetrieveToken:(NSURL*)url{
//    NSString *temporaryCode = [self parseGitHubTempCode:url];
//    NSString *paramsString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@&redirect_uri=%@",
//                           GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET, temporaryCode, [NSString stringWithFormat:GENERIC_CALLBACK_URI,kGitHub,kOAuth]];
//    NSData *postData = [paramsString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)paramsString.length];
//    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GITHUB_POST_TOKEN_URL]];
//    [urlRequest setHTTPMethod:@"POST"];
//    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [urlRequest setHTTPBody:postData];
//
//    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
//    NSURLSessionDataTask *retrieveAccessToken = [urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//
//        if(!error){
//            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
//
//            switch (httpResponse.statusCode) {
//                case 200: { // All good
//                    self.gitHubAccessToken = [[self dictionaryGitHubFromData:data] objectForKey:@"access_token"];
//                    NSAssert(self.gitHubAccessToken, @"Do not have access token. Rectify immediately.");
//                    [[NSUserDefaults standardUserDefaults] setObject:self.gitHubAccessToken forKey:[NSString stringWithFormat:GENERIC_ACCESS_KEY,kGitHub,kToken]];
//                    [self.dataDelegate didAuthenticateUser:YES];
//                }
//                    break;
//                default:
//                    NSLog(@"error: %ld", (long)httpResponse.statusCode);
//                    break;
//            }
//
//        } else {
//            NSLog(@"%@",error.localizedDescription);
//        }
//    }];
//
//    [retrieveAccessToken resume];
//}
//
//-(NSString*) parseGitHubTempCode:(NSURL*)url{
//    NSArray *queryComponents = [[url query] componentsSeparatedByString:@"&"];
//    return [queryComponents[0] componentsSeparatedByString:@"="][1];
//}
//
//-(NSMutableDictionary*)dictionaryGitHubFromData:(NSData*)data{
//    NSString *tokenResponse = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//
//    NSMutableDictionary *tokenParams = [[NSMutableDictionary alloc] init];
//    NSArray *tokenComponents = [tokenResponse componentsSeparatedByString:@"&"];
//
//    for (NSString *component in tokenComponents) {
//        NSArray *params = [component componentsSeparatedByString:@"="];
//        [tokenParams setObject:params[1] forKey:params[0]];
//    }
//
//    return tokenParams;
//}


