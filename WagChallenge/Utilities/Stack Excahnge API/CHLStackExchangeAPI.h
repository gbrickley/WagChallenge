//
//  CHLStackExchangeAPI.h
//  WagChallenge
//
//  Created by George Brickley on 6/26/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface CHLStackExchangeAPI : NSObject

#pragma mark - Retrieving Users

/**
 * General block used to return data from the Stack Exchange API.
 * @param object id - The data that you were attempting to fetch. May be an individual object or an array of
 *   objects.  See individual API requests for info on the expected return type.
 * @param error NSError - If there was an error in the request, this will be set to tell why.  If not, nil.
 */
typedef void (^StackExchangeRequestCallback)(id object, NSError *error);


/**
 * Retrieves users from a specific site.
 * @param site     NSString  - The site to grab the users from (i.e. stackoverflow)
 * @param page     NSInteger - The page of users to grab (offset).
 * @param pageSize NSInteger - The number of users to retrieve.
 * @param callback StackExchangeRequestCallback - The block to execute when the process completes.
 * If successful, the callback block will pass an array of CHLUser objects.  If there was an error, the error
 *   object will be set to tell why.
 */
- (void)retrieveUsersFromSite:(NSString *)site
                       onPage:(NSInteger)page
                     withSize:(NSInteger)pageSize
             andCallbackBlock:(StackExchangeRequestCallback)callback;

@end
