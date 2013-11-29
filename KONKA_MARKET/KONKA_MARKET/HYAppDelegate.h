//
//  HYAppDelegate.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-3.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIImageView *defaultView;
@property (strong, nonatomic) UIImageView *versionView;
@property (strong, nonatomic) UILabel *lblTips;
@property (strong, nonatomic) UILabel *lblVersion;

@property (nonatomic,strong) UINavigationController *navController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
