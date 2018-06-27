//
//  CHLStackExchangeAPI.m
//  WagChallenge
//
//  Created by George Brickley on 6/26/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import "CHLStackExchangeAPI.h"
#import <AFNetworking/AFNetworking.h>
#import "CHLUser.h"
#import "NSError+CHL.h"


/** StackExchange API Constants */
#define kStackExchangeAPIBaseURL  @"https://api.stackexchange.com"
#define kStackExchangeAPIVersion  @"2.2"


@implementation CHLStackExchangeAPI

- (void)retrieveUsersFromSite:(NSString *)site
                       onPage:(NSInteger)page
                     withSize:(NSInteger)pageSize
             andCallbackBlock:(StackExchangeRequestCallback)callback {
    
    // If there's no callback, don't go any further
    if (!callback) {
        return;
    }
    
    // Make sure we have a site to fetch from
    if (!site) {
        NSString *errMessage = @"No site parameter passed to the Stack Overflow API.";
        NSError *error = [NSError errorWithDescription:errMessage andCode:600];
        callback(nil,error);
        return;
    }
    
    // Page and page size cannot be 0
    if (!page || !pageSize) {
        NSString *errMessage = @"Invalid page values.";
        NSError *error = [NSError errorWithDescription:errMessage andCode:601];
        callback(nil,error);
        return;
    }
    
    NSString *url = [self apiRequestForEndpoint:@"users"];
    
    NSDictionary *params = @{ @"site"     : site,
                              @"page"     : [NSNumber numberWithInteger:page],
                              @"pagesize" : [NSNumber numberWithInteger:pageSize] };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        NSDictionary *response = (NSDictionary *)responseObject;

        // See if we have an error
        if (response[@"error_message"]) {
            NSString *errMessage = response[@"error_message"];
            NSInteger errorCode = [response[@"error_id"] integerValue];
            NSError *error = [NSError errorWithDescription:errMessage andCode:errorCode];
            callback(nil,error);
            return;
        }
        
        // Double check that we have an items array
        if (!response[@"items"] || ![response[@"items"] isKindOfClass:[NSArray class]]) {
            NSString *errMessage = @"Unknown error";
            NSError *error = [NSError errorWithDescription:errMessage andCode:603];
            callback(nil,error);
            return;
        }
        
        // This array will hold our CHLUser objects
        NSMutableArray *mutableUsers = [[NSMutableArray alloc] init];
        
        // Itterate through the response and create CHLUser objects for each item
        NSArray *items = (NSArray *)response[@"items"];
        
        for (NSDictionary *userDictionary in items) {
            CHLUser *user = [[CHLUser alloc] initWithDictionary:userDictionary];
            if (user) {
                [mutableUsers addObject:user];
            }
        }
        
        // Make the array of users we return immutable to match the documentation
        NSArray *users = [NSArray arrayWithArray:mutableUsers];
        callback(users,nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(nil,error);
    }];
}

- (NSString *)apiRequestForEndpoint:(NSString *)endpoint {
    return [NSString stringWithFormat:@"%@/%@/%@", kStackExchangeAPIBaseURL,kStackExchangeAPIVersion,endpoint];
}

@end
