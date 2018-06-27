//
//  CHLUser.h
//  WagChallenge
//
//  Created by George Brickley on 6/26/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface CHLUser : NSObject

/** The designated initializer */
- (id)initWithId:(NSInteger)userId
        username:(NSString *)username
 profileImageURL:(NSURL *)profileImageURL
        location:(NSString *)location
  goldBadgeCount:(NSInteger)goldBadgeCount
silverBadgeCount:(NSInteger)silverBadgeCount
bronzeBadgeCount:(NSInteger)bronzeBadgeCount
      lastUpdate:(NSDate *)lastUpdate;

/** Convenience initializer */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/** Default init is not allowed */
- (id) init __attribute__((unavailable("Must use initWithID: or initWithDictionary:")));


#pragma mark - Public Properties

/** The users unique identifier */
@property NSInteger userId;

/** The users username */
@property NSString *username;

/** The url of the users profile image */
@property NSURL *profileImageURL;

/** A description of the users location */
@property NSString *location;

/** The number of gold badges the user has earned */
@property NSInteger goldBadgeCount;

/** The number of silver badges the user has earned */
@property NSInteger silverBadgeCount;

/** The number of bronze badges the user has earned */
@property NSInteger bronzeBadgeCount;

/** The last time the users profile was updated */
@property NSDate *lastUpdate;


#pragma mark - Debugging

/** Convenience method to print all of the objects properties to the debugger */
- (void)printData;

@end
