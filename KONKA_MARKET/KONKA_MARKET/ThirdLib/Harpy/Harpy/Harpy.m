//
//  Harpy.m
//  Harpy
//
//  Created by Arthur Ariel Sabintsev on 11/14/12.
//  Copyright (c) 2012 Arthur Ariel Sabintsev. All rights reserved.
//

#import "Harpy.h"
#import "HarpyConstants.h"
#import "HYAppUtily.h"
#import "HYSeverContUrl.h"

#define kHarpyCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]

@interface Harpy ()

+ (void)showAlertWithAppStoreVersion:(NSString*)appStoreVersion;


@end

@implementation Harpy

#pragma mark - Public Methods
+ (void)checkVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // CFShow(infoDictionary);
    // app名称
    //NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    //NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    //NSString *info = @"";
    
    // Asynchronously query iTunes AppStore for publically available version
    //NSString *storeString = [NSString stringWithFormat:CheckVersionApi];
    //NSURL *storeURL = [NSURL URLWithString:storeString];
    NSURL *storeURL = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:CheckVersionApi]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // All versions that have been uploaded to the AppStore
                NSString *versionsInAppStore = [appData valueForKey:@"version"];
                //info =
                NSString *info = [appData valueForKey:@"info"];
                NSString *download = [appData valueForKey:@"download"];
                
                if(![versionsInAppStore isEqualToString:app_build])
                {
                    [Harpy showAlertWithVersion:versionsInAppStore info:info download:download];
                    //[Harpy showAlertWithAppStoreVersion:app_build];
                }
                //NSLog(versionsInAppStore);
                //                if ( ![versionsInAppStore count] ) { // No versions of app in AppStore
                //
                //                    return;
                //
                //                } else {
                //
                //                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                //
                //                    if ([kHarpyCurrentVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
                //
                //                        [Harpy showAlertWithAppStoreVersion:currentAppStoreVersion];
                //
                //                    }
                //                    else {
                //
                //                        // Current installed version is the newest public version or newer
                //
                //                    }
                //
                //                }
                
            });
        }
        
    }];
}

#pragma mark - Private Methods
+ (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion
{
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    if ( harpyForceUpdate ) { // Force user to update app
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                            message:[NSString stringWithFormat:@"%@ 有新版本。 请现在更新到新版本%@。", appName, currentAppStoreVersion]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyUpdateButtonTitle
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
        
    } else { // Allow user option to update next time user launches your app
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                            message:[NSString stringWithFormat:@"%@ 有新版本。 请现在更新到新版本%@。", appName, currentAppStoreVersion]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyCancelButtonTitle
                                                  otherButtonTitles:kHarpyUpdateButtonTitle, nil];
        
        [alertView show];
        
    }
    
}

#pragma mark - Private Methods
+ (void)showAlertWithVersion:(NSString *)currentAppStoreVersion info:(NSString *)info download:(NSString *)url
{
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    if ( harpyForceUpdate ) { // Force user to update app
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                            message:[NSString stringWithFormat:@"[%@] 有新版本。 请现在更新到新版本%@。版本更新内容:%@", appName, currentAppStoreVersion,info]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyUpdateButtonTitle
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
        
    } else { // Allow user option to update next time user launches your app
        
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kHarpyAlertViewTitle
                                                            message:[NSString stringWithFormat:@"[%@] 有新版本。 请现在更新到新版本%@。版本更新内容:%@", appName, currentAppStoreVersion,info]
                                                           delegate:self
                                                  cancelButtonTitle:kHarpyCancelButtonTitle
                                                  otherButtonTitles:kHarpyUpdateButtonTitle, nil];
        
        [alertView show];
        
    }
    
}

#pragma mark - UIAlertViewDelegate Methods
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:VersionApi]];
    if ( harpyForceUpdate ) {
        
        //NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
        //NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
        [[UIApplication sharedApplication] openURL:url];
        
    } else {
        
        switch ( buttonIndex ) {
                
            case 0:{ // Cancel / Not now
                
                // Do nothing
                
            } break;
                
            case 1:{ // Update
                
                //NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kHarpyAppID];
                //NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                [[UIApplication sharedApplication] openURL:url];
                
            } break;
                
            default:
                break;
        }
        
    }
    
    
}

@end
