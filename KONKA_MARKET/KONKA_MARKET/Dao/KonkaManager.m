//
//  KonkaManager.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-23.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "KonkaManager.h"

@interface KonkaManager()

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation KonkaManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (id)init
{
    self = [super init];
    if (self) {
        //        init code
    }
    return self;
}

#pragma mark -
#pragma mark Application's documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];;
}

- (void)saveContext
{
    NSError *error;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark -
#pragma mark Core Data stack

/*
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KonkaModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


/*
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created ,and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory]URLByAppendingPathComponent:@"konkaModel.sqlite"];
    
    NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}


//数据操作
-(void) insertUserDataByParems:(NSMutableDictionary *)dic
{   
    if ([self managedObjectContext] == nil) {
        return ;
    }
    
    UserEntity *userEntity = (UserEntity *) [NSEntityDescription insertNewObjectForEntityForName:@"UserEntity" inManagedObjectContext:self.managedObjectContext];
    
    
    for (id akey in [dic allKeys]) {
        if (userEntity)
        [userEntity setValue:[dic objectForKey:akey] forKey:akey];
    }
    
    [self saveContext];
    
}

-(void) insertBaseDataByParems:(NSMutableDictionary *)dic
{
    if ([self managedObjectContext] == nil) {
        return ;
    }
    
    BaseDataEntity *baseDataEntity = (BaseDataEntity *) [NSEntityDescription insertNewObjectForEntityForName:@"BaseDataEntity" inManagedObjectContext:self.managedObjectContext];
    
    for (id akey in [dic allKeys]) {
        [baseDataEntity setValue:[dic objectForKey:akey] forKey:akey];
    }
    
    [self saveContext];
}

-(Boolean) isExistUserDataByID:(NSNumber *)user_id
{
    if ([self managedObjectContext] == nil) {
        return false;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %d", [user_id intValue]];
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if ([result count] == 0){
        return false;
    }
        
    return true;
}

-(void) updateDataPatch:(NSString *)dataPatch ByUserID:(NSNumber *)user_id
{
    if ([self managedObjectContext] == nil) {
        return ;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %d", [user_id intValue]];
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    UserEntity *userEntity = [result objectAtIndex:0];
    userEntity.dataPatch = dataPatch;
    
    [self saveContext];
}

-(NSString *) selectDataPatchByUserID:(NSNumber *)user_id
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %d", [user_id intValue]];
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    UserEntity *userEntity = [result objectAtIndex:0];
    return userEntity.dataPatch;
}

-(NSString *)findModelNameByID:(NSNumber *)user_id ByName:(NSString *)addon2
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"list_type == %@ AND user_id == %d AND base_id == %@", @"modelList", [user_id intValue], addon2];
    //predicate = [NSPredicate predicateWithFormat:@"list_type == %@ AND user_id == %d", @"peList", [user_id intValue]];

    
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    BaseDataEntity *en = [result objectAtIndex:0];
    
    return en.name;

}

-(NSMutableArray *) getPeListByUserID:(NSNumber *)user_id ByType:(NSString *)type ByFlag:(NSNumber *)flag
{
    return [self getStoreListByUserID:user_id ByType:type ByFlag:flag];
}

-(NSMutableArray *) getStoreListByUserID:(NSNumber *)user_id ByType:(NSString *)type ByFlag:(NSNumber *)flag
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"list_type == %@ AND user_id == %d AND flag = %d", type, [user_id intValue], [flag intValue]];

    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *result1 = [[NSMutableArray alloc] init];
    
    for (BaseDataEntity *en in result) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:en.addon1 forKey:@"addon1"];
        [dic setObject:en.addon2 forKey:@"addon2"];
        [dic setObject:en.name forKey:@"name"];
        [dic setObject:en.base_id forKey:@"base_id"];
        [dic setObject:en.user_id forKey:@"user_id"];
        [dic setObject:en.list_type forKey:@"list_type"];
        [result1 addObject:dic];
    }
    return result1;
}


-(NSMutableArray *) getAllModelNameListByUserID:(NSNumber *)user_id ByFlag:(NSNumber *)flag
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"list_type == %@ AND user_id == %d AND flag = %d", @"modelList", [user_id intValue], [flag intValue]];
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *result1 = [[NSMutableArray alloc] init];
    
    for (BaseDataEntity *en in result) {
        [result1 addObject:en.name];
    }
    return result1;
}

-(NSMutableArray *) getModelListByUserID:(NSNumber *)user_id ByType:(NSString *)type ByFlag:(NSNumber *)flag ByName:(NSString *)name ByPage:(int)page
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:20];
    [fetchRequest setFetchOffset:page * 20];
    NSPredicate * predicate = nil;
    if (name == nil)
    {
        NSLog(@"111");
        predicate = [NSPredicate predicateWithFormat:@"list_type == %@ AND user_id == %d AND flag = %d", type, [user_id intValue], [flag intValue]];
    }else
    {
        NSLog(@"222");
        predicate = [NSPredicate predicateWithFormat:@"list_type == %@ AND user_id == %d AND flag = %d AND name like %@", type, [user_id intValue], [flag intValue], name];
    }
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *result1 = [[NSMutableArray alloc] init];
    
    for (BaseDataEntity *en in result) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:en.addon1 forKey:@"addon1"];
        [dic setObject:en.addon2 forKey:@"addon2"];
        [dic setObject:en.name forKey:@"name"];
        [dic setObject:en.base_id forKey:@"base_id"];
        [dic setObject:en.user_id forKey:@"user_id"];
        [dic setObject:en.list_type forKey:@"list_type"];
        [result1 addObject:dic];
    }
    return result1;
}

-(void) updateModelListFlag:(NSNumber *)flag ByName:(NSString *)name ByUserID:(NSNumber *)user_id
{
    
    if ([self managedObjectContext] == nil) {
        return ;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %d AND name = %@ AND list_type == %@", [user_id intValue], name,@"modelList"];
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    BaseDataEntity *base = [result objectAtIndex:0];
    base.flag = flag;
    [self saveContext];
}

@end
