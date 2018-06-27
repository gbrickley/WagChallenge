//
//  CHLUserCell.h
//  WagChallenge
//
//  Created by George Brickley on 6/26/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface CHLUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *silverCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *bronzeCountLabel;

/**
 * Sets the profile image using an image url.
 * @param imageURL NSURL           - The url of the image.
 * @param placeholderImage UIImage - The image to use in case we can't load the image from the url.
 */
- (void)loadProfileImageAtURL:(NSURL *)imageURL withPlaceholder:(UIImage *)placeholderImage;

@end
