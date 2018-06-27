//
//  NSError+CHL.h
//  WagChallenge
//
//  Created by George Brickley on 6/26/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSError (CHL)

/** Convenience method for creating an error object with just a description and code */
+ (NSError *)errorWithDescription:(NSString *)description andCode:(NSInteger)code;

@end
