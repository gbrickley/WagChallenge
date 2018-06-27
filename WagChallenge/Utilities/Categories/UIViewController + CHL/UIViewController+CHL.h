//
//  UIViewController+CHL.h
//  WagChallenge
//
//  Created by George Brickley on 6/26/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIViewController (CHL)

/** Present an alert with the given title and message */
- (void)presentAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

@end
