//
//  CHLFileManager.m
//  WagChallenge
//
//  Created by George Brickley on 6/27/18.
//  Copyright © 2018 George Brickley. All rights reserved.
//


#import "CHLFileManager.h"
#import <AFNetworking/AFNetworking.h>


@implementation CHLFileManager

- (void)retrieveImageAtURL:(NSURL *)imageURL andSaveLocally:(BOOL)saveLocally withCallback:(CHLDownloadCompletionBlock)callback {
    
    if (!callback) {
        return;
    }
    
    if (!imageURL) {
        callback(nil);
    }

    // First check if the image is already downloaded
    NSString *localDownloadPath = [self localDownloadPathForImageAtURL:imageURL];
    UIImage *downloadedImage = [UIImage imageWithContentsOfFile:localDownloadPath];
    if (downloadedImage) {
        callback(downloadedImage);
        return;
    }
    
    // Download the image from the URL
    [self retrieveFileAtURL:imageURL andSaveLocally:saveLocally withCallback:callback];
}

- (void)retrieveFileAtURL:(NSURL *)imageURL andSaveLocally:(BOOL)saveLocally withCallback:(CHLDownloadCompletionBlock)callback {
    
    NSString *fileName = [self fileNameForImageAtURL:imageURL];
    NSString *localDownloadPath = [self localDownloadPathForImageAtURL:imageURL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    NSURLSessionDownloadTask *downloadTask = [sessionManager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSString *localDownloadPath = [self cacheStoragePathForFileWithName:fileName];
        NSURL *url = [NSURL fileURLWithPath:localDownloadPath];
        return url;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            callback(nil);
            return;
        }
        
        NSData *fileData = [NSData dataWithContentsOfURL:filePath];
        UIImage *downloadedImage = [UIImage imageWithData:fileData];
        
        // If we requested to save the downloaded image locally, do so now
        if (saveLocally) {
            [self saveImage:downloadedImage toLocalDownloadPath:localDownloadPath];
        }
        
        callback(downloadedImage);
    }];
    
    [downloadTask resume];
}

- (void)saveImage:(UIImage *)image toLocalDownloadPath:(NSString *)localPath {
    NSData *pngData = UIImagePNGRepresentation(image);
    [pngData writeToFile:localPath atomically:YES];
}

- (NSString *)fileNameForImageAtURL:(NSURL *)imageURL {
    return [imageURL lastPathComponent];
}

- (NSString *)localDownloadPathForImageAtURL:(NSURL *)imageURL {
    
    NSString *fileDirectory = [self localFileStorageDirectory];
    NSString *fileName = [self fileNameForImageAtURL:imageURL];
    return [fileDirectory stringByAppendingPathComponent:fileName];
}

- (NSString *)localFileStorageDirectory {
    
    NSString *path = [NSString stringWithFormat:@"~/Documents/%@", @"downloadedFiles"];
    path = [path stringByExpandingTildeInPath];
    
    // If the directory doesn't exist yet, create it now.
    if (![self fileExistsAtPath:path]) {
        [self createDirectoryAtPath:path];
    }
    
    return path;
}

- (NSString *)cacheStoragePathForFileWithName:(NSString *)fileName {
    
    NSString *fileDirectory = [self localCacheFileStorageDirectory];
    NSString *fullPath = [fileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    return fullPath;
    
}

- (NSString *)localCacheFileStorageDirectory {
    return NSTemporaryDirectory();
}

- (BOOL)fileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (BOOL)createDirectoryAtPath:(NSString *)path {
    
    NSError * error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (error != nil) {
        NSLog(@"Error creating directory at path: %@  Error: %@", path, error);
        return FALSE;
    }
    
    return TRUE;
}

@end
