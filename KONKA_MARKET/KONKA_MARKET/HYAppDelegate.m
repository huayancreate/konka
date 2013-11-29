//
//  HYAppDelegate.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-3.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYAppDelegate.h"
#import "HYLoginViewController.h"
#import "WZGuideViewController.h"
#import "MobClick.h"
#import "Harpy.h"
#import "DataProcessing.h"
#import "SDImageView+SDWebCache.h"

@implementation HYAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize defaultView;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Harpy checkVersion];
    [MobClick startWithAppkey:@"52103a0156240b648f012643"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window makeKeyAndVisible];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    
//    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"getJson",@"method",@"1103",@"type_id",nil];
//    
//    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:HomeImageApi]];
//    
//    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
    
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:HomeImageApi]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    NSString *str = @"method=getJson&type_id=1103";//设置参数
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    NSLog(@"str1 %@",str1);
    
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    
    NSData *resdata = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *json = [decoder objectWithData:resdata];
    NSDictionary *dic = [json objectAtIndex:0];
    NSString *strUrl = [dic objectForKey:@"image_path"];
    NSLog(@"strUrl: %@", strUrl);
    NSURL *urlimg = [[NSURL alloc] initWithString:strUrl];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    defaultView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, screenBounds.size.width, screenBounds.size.height)];
    
    [defaultView setImageWithURL:urlimg refreshCache:YES];
    
    [self.window addSubview:defaultView];
    [self.window bringSubviewToFront:defaultView];
    
    
    
    [NSThread sleepForTimeInterval:7];
    
    NSLog(@"strUrl: %d", 1);
    HYLoginViewController *loginView = [[HYLoginViewController alloc]initWithNibName:@"HYLoginViewController" bundle:nil];
    self.navController = [[UINavigationController alloc]initWithRootViewController:loginView];
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navController;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [WZGuideViewController show];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    NSLog(@"strUrl: %d", 2);
    // Override point for customization after application launch.

    //HYLoginViewController *loginView = [[HYLoginViewController alloc]initWithNibName:@"HYLoginViewController" bundle:nil];
    
//    HYScrollPageViewController *scrollView = [[HYScrollPageViewController alloc]initWithNibName:@"HYScrollPageViewController" bundle:nil];
    
    //self.navController = [[UINavigationController alloc]initWithRootViewController:loginView];
    
    
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KONKA_MARKET" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KONKA_MARKET.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -
#pragma mark DataProcesse
- (void) requestFinished:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endRequest:) withObject:responsestring waitUntilDone:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败";
    [self performSelectorOnMainThread:@selector(endFailedRequest:) withObject:responsestring waitUntilDone:YES];
}

-(void) endFailedRequest:(NSString *)msg
{
    NSLog(@"msg %@", msg);
}

-(void) endRequest:(NSString *)msg
{
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *json = [decoder objectWithData:data];
    NSDictionary *dic = [json objectAtIndex:0];
    NSString *strUrl = [dic objectForKey:@"image_path"];
    NSLog(@"strUrl: %@", strUrl);
    NSURL *url = [[NSURL alloc] initWithString:strUrl];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    defaultView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, screenBounds.size.width, screenBounds.size.height)];
    
    [defaultView setImageWithURL:url];
    
    [self.window addSubview:defaultView];
    [self.window bringSubviewToFront:defaultView];
}

@end
