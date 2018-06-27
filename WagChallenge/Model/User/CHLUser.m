//
//  CHLUser.m
//  WagChallenge
//
//  Created by George Brickley on 6/26/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import "CHLUser.h"
#import "GHBJSONParser.h"



@implementation CHLUser

#pragma mark - API Key Constants

#define kUserIdKey                @"user_id"
#define kUsernameKey              @"display_name"
#define kProfileImageURLKey       @"profile_image"
#define kLocationKey              @"location"
#define kBadgeCountsKey           @"badge_counts"
#define kGoldBadgeCountKey        @"gold"
#define kSilverBadgeCountKey      @"silver"
#define kBronzeBadgeCountKey      @"bronze"
#define kLastUpdateKey            @"last_modified_date"


- (id)initWithId:(NSInteger)userId
        username:(NSString *)username
 profileImageURL:(NSURL *)profileImageURL
        location:(NSString *)location
  goldBadgeCount:(NSInteger)goldBadgeCount
silverBadgeCount:(NSInteger)silverBadgeCount
bronzeBadgeCount:(NSInteger)bronzeBadgeCount
      lastUpdate:(NSDate *)lastUpdate {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // Check for required properties
    // For now, we will require that users at least have an id, username, and last update date
    if ( !(userId && username && lastUpdate) ) {
        return nil;
    }
    
    self.userId = userId;
    self.username = username;
    self.profileImageURL = profileImageURL;
    self.location = location;
    self.goldBadgeCount = goldBadgeCount;
    self.silverBadgeCount = silverBadgeCount;
    self.bronzeBadgeCount = bronzeBadgeCount;
    self.lastUpdate = lastUpdate;
    
    return(self);
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    // Validate the passed dictionary
    if (!dictionary || [dictionary isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    GHBJSONParser *parser = [[GHBJSONParser alloc] init];
    
    NSInteger userId = [parser integerFromJSONObject:dictionary[kUserIdKey] withDefaultValue:0];
    NSString *username = [parser stringFromJSONObject:dictionary[kUsernameKey] withDefaultValue:nil];
    NSURL *profileImageURL = [parser urlFromJSONObject:dictionary[kProfileImageURLKey] withDefaultValue:nil];
    NSString *location = [parser stringFromJSONObject:dictionary[kLocationKey] withDefaultValue:nil];
    
    NSInteger gold = 0;
    NSInteger silver = 0;
    NSInteger bronze = 0;
    
    // Double check that we have an array of badges counts
    if (dictionary[kBadgeCountsKey] && [dictionary[kBadgeCountsKey] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *badges = (NSDictionary *)dictionary[kBadgeCountsKey];
        gold   = [parser integerFromJSONObject:badges[kGoldBadgeCountKey]   withDefaultValue:0];
        silver = [parser integerFromJSONObject:badges[kSilverBadgeCountKey] withDefaultValue:0];
        bronze = [parser integerFromJSONObject:badges[kBronzeBadgeCountKey] withDefaultValue:0];
    }
    
    NSDate *lastUpdate = [parser dateFromTimestampJSONObject:dictionary[kLastUpdateKey] andDefaultValue:nil];

    return [self initWithId:userId
                   username:username
            profileImageURL:profileImageURL
                   location:location
             goldBadgeCount:gold
           silverBadgeCount:silver
           bronzeBadgeCount:bronze
                 lastUpdate:lastUpdate];
}


#pragma mark - Debugging

- (void)printData {
    NSLog(@"___________________________________________________________________________");
    NSLog(@"CHLUser object:");
    NSLog(@"UserId: %ld", (long)self.userId);
    NSLog(@"Username: %@", self.username);
    NSLog(@"Profile Image URL: %@", self.profileImageURL);
    NSLog(@"Location: %@", self.location);
    NSLog(@"Gold Badges: %ld", (long)self.goldBadgeCount);
    NSLog(@"Silver Badges: %ld", (long)self.silverBadgeCount);
    NSLog(@"Bronze Badges: %ld", (long)self.bronzeBadgeCount);
    NSLog(@"___________________________________________________________________________");
}

@end
