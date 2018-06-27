//
//  UITableView+CHL.m
//  WagChallenge
//
//  Created by George Brickley on 6/26/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import "UITableView+CHL.h"


@implementation UITableView (CHL)

- (void)hideEmptyCells {
    // Adding in a fake footer makes the table view hide empty cells at the bottom
    UIView *fakeFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.tableFooterView = fakeFooter;
}

@end
