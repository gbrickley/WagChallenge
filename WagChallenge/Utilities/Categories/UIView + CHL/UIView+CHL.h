//
//  UIView+CHL.h
//  WagChallenge
//
//  Created by George Brickley on 6/27/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIView (CHL)

/** Sets a border on the view with the given attributes */
- (void)setBorderWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius;


@end
