//
//  CHLUserCell.m
//  WagChallenge
//
//  Created by George Brickley on 6/26/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import "CHLUserCell.h"
#import "CHLFileManager.h"
#import "UIView+CHL.h"


@interface CHLUserCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIView *goldContainerView;
@property (weak, nonatomic) IBOutlet UIView *silverContainerView;
@property (weak, nonatomic) IBOutlet UIView *bronzeContainerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *profileImageActivityIndicator;

// Helps with downloading and retrieving images
@property CHLFileManager *fileManager;

@end


@implementation CHLUserCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    CGFloat borderWidth = 0;
    CGFloat radius = 5;
    UIColor *color = [UIColor clearColor];
    
    [self.goldContainerView    setBorderWithColor:color width:borderWidth radius:radius];
    [self.silverContainerView  setBorderWithColor:color width:borderWidth radius:radius];
    [self.bronzeContainerView  setBorderWithColor:color width:borderWidth radius:radius];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadProfileImageAtURL:(NSURL *)imageURL withPlaceholder:(UIImage *)placeholderImage {
    
    // If we don't have an imageURL, just use the placeholder
    if (!imageURL) {
        [self setProfileImage:placeholderImage];
        return;
    }
    
    // Show the light user image and activity indicator as we load the image
    self.profileImageView.image = [UIImage imageNamed:@"user-loading-background"];
    [self.profileImageActivityIndicator startAnimating];
    
    // Download the image from the url
    self.fileManager = [[CHLFileManager alloc] init];
    
    [self.fileManager retrieveImageAtURL:imageURL andSaveLocally:TRUE withCallback:^(UIImage *image) {
        if (image) {
            [self setProfileImage:image];
        } else {
            [self setProfileImage:placeholderImage];
        }
    }];
}

- (void)setProfileImage:(UIImage *)image {
    [self.profileImageActivityIndicator stopAnimating];
    self.profileImageView.image = image;
}

@end
