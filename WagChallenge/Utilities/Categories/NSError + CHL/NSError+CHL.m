//
//  NSError+CHL.m
//  WagChallenge
//
//  Created by George Brickley on 6/26/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import "NSError+CHL.h"


@implementation NSError (CHL)

+ (NSError *)errorWithDescription:(NSString *)description andCode:(NSInteger)code {
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey:description };
    return [NSError errorWithDomain:@"CHLErrorDomain" code:code userInfo:userInfo];
}

@end
