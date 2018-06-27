//
//  CHLUsersListView.m
//  WagChallenge
//
//  Created by George Brickley on 6/26/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import "CHLUsersListView.h"
#import "CHLStackExchangeAPI.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "CHLUser.h"
#import "Constants.h"
#import "UIViewController+CHL.h"
#import "UITableView+CHL.h"
#import "CHLUserCell.h"
#import "CHLLoadingCell.h"


@interface CHLUsersListView ()

// The StackExchange API wrapper we'll use to fetch users
@property CHLStackExchangeAPI *stackExchangeAPI;

// This array will hold all of the users we've loaded so far
@property NSMutableArray *users;

// Keep track of what page of users we're on
@property NSInteger currentPage;

// If we had an error loading users, we'll keep a record of it here in case we need to alert the user
@property NSError *loadError;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property MBProgressHUD *progressHUD;

@end


@implementation CHLUsersListView

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Hide any empty cells in the table view
    [self.tableView hideEmptyCells];
    
    // Set the views initial values
    // In future versions, we may persist users locally, but for now we will always start fresh
    self.users = [[NSMutableArray alloc] init];
    self.stackExchangeAPI = [[CHLStackExchangeAPI alloc] init];
    
    // We start the page counter at 0 so that when we call 'loadNextPageOfUsers()' the first page will be 1
    self.currentPage = 0;
    
    // Load the users
    [self loadNextPageOfUsers];
}


#pragma mark - Loading Users

- (void)loadNextPageOfUsers {
    
    // If this is the initial load of users, show an activity indicator so the user knows we're working
    if (self.users.count == 0 && !self.loadError) {
        [self showLoadingIndicator];
    }
    
    // Increment the current page value
    self.currentPage++;
    
    // Remove any previous loading error
    self.loadError = nil;
    
    [self.stackExchangeAPI retrieveUsersFromSite:STACK_EXCHANGE_SITE_NAME onPage:self.currentPage withSize:RESULTS_PER_PAGE andCallbackBlock:^(NSArray *users, NSError *error) {
        
        // Check for an error
        if (error) {
            self.loadError = error;
            [self reloadTableView];
            return;
        }
        
        // Add the users to our list and reload the table
        [self.users addObjectsFromArray:users];
        [self reloadTableView];
    }];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // If we have at least a full page of users, add the 'loading cell' to show the user we're fetching more
    if (self.users.count >= RESULTS_PER_PAGE) {
        return self.users.count + 1;
    } else {
        return self.users.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // If this is our extra table row, show the loading cell
    if (indexPath.row == self.users.count) {
        CHLLoadingCell *cell = (CHLLoadingCell *)[tableView dequeueReusableCellWithIdentifier:@"loadingCell" forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.view.frame.size.width);
        [cell.activityIndicator startAnimating];
        return cell;
    }
    
    CHLUserCell *cell = (CHLUserCell *)[tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];

    CHLUser *user = self.users[indexPath.row];
    cell.usernameLabel.text = user.username;
    
    UIImage *fallbackImage = [UIImage imageNamed:@"user-empty-set-icon"];
    [cell loadProfileImageAtURL:user.profileImageURL withPlaceholder:fallbackImage];
    
    // Format the badge counts as localized numbers (with commas)
    cell.goldCountLabel.text   = [NSString localizedStringWithFormat:@"%@", @(user.goldBadgeCount)];
    cell.silverCountLabel.text = [NSString localizedStringWithFormat:@"%@", @(user.silverBadgeCount)];
    cell.bronzeCountLabel.text = [NSString localizedStringWithFormat:@"%@", @(user.bronzeBadgeCount)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CHLUser *user = self.users[indexPath.row];
    [self didSelectUser:user];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // If the user scrolls to the last cell, load the next page of results
    if (indexPath.row == self.users.count) {
        [self loadNextPageOfUsers];
    }
}


#pragma mark - Empty Data Set Delegate

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *str;
    if (self.loadError) {
        str = [NSString stringWithFormat:@"Could not load users. %@", self.loadError.localizedDescription];
    } else {
        str = @"No users loaded yet.";
    }
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;

    UIFont *font = [UIFont systemFontOfSize:14];
    UIColor *textColor = [UIColor grayColor];
    
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:textColor,
                                 NSParagraphStyleAttributeName:paragraph};
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:str attributes:attributes];
    return attStr;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"user-empty-set-icon"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    NSString *str;
    if (self.loadError) {
        str = @"Retry";
    } else {
        str = @"Load Users";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
    return [[NSAttributedString alloc] initWithString:str attributes:attributes];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    UIImage *image = [UIImage imageNamed:@"empty-set-btn-bg"];
    UIEdgeInsets capInsets = UIEdgeInsetsMake(12.0, 12.0, 12.0, 12.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(-19.0, -61.0, -19.0, -61.0);
    
    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    
    [self showLoadingIndicator];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self loadNextPageOfUsers];
    });
}


#pragma mark - User More Info

- (void)didSelectUser:(CHLUser *)user {
    [self presentAlertWithTitle:user.username andMessage:@"In the future, maybe we push a user detail view when you tap a row."];
}


#pragma mark - Loading Indicator

- (void)showLoadingIndicator {
    self.tableView.hidden = TRUE;
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progressHUD.label.text = @"Loading Users...";
}

- (void)hideLoadingIndicator {
    [self.progressHUD hideAnimated:YES];
    self.tableView.hidden = FALSE;
}


#pragma mark - Helper Methods

- (void)reloadTableView {
    [self.tableView reloadData];
    [self hideLoadingIndicator];
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
