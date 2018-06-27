//
//  CHLFileManager.h
//  WagChallenge
//
//  Created by George Brickley on 6/27/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CHLFileManager : NSObject

/**
 * The block called when an image download finishes.
 * @param image UIImage - The downloaded image.
 */
typedef void (^CHLDownloadCompletionBlock)(UIImage *image);

/**
 * Retrieves an image from a remote URL.  If the image is already downloaded locally, that image will be
 *  returned right away.  If not, the image will download from url.
 * @param imageURL NSURL   - The url of the image.
 * @param saveLocally BOOL - Whether or not to save the downloaded image locally.
 * @param callback CHLDownloadCompletionBlock - The block called when the download finishes.
 */
- (void)retrieveImageAtURL:(NSURL *)imageURL andSaveLocally:(BOOL)saveLocally withCallback:(CHLDownloadCompletionBlock)callback;

@end
