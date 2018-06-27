//
//  UIView+CHL.m
//  WagChallenge
//
//  Created by George Brickley on 6/27/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import "UIView+CHL.h"


@implementation UIView (CHL)

- (void)setBorderWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
}

@end
