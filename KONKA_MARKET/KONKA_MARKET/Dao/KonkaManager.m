//
//  KonkaManager.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-23.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "KonkaManager.h"
#import "JSONKit.h"

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
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
//{
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
//    
//    NSURL *storeURL = [[self applicationDocumentsDirectory]URLByAppendingPathComponent:@"konkaModel.sqlite"];
//    
//    NSError *error;
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    return _persistentStoreCoordinator;
//}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory]URLByAppendingPathComponent:@"konkaModel.sqlite"];
    
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Handle error
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

-(void)updateUserInfoByUserID:(NSNumber *)user_id UserName:(NSString *)user_name RealName:(NSString *)real_name Sid:(NSString *)sid department:(NSString *)department
{
    if ([self managedObjectContext] == nil) {
        return;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %d", [user_id intValue]];
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    UserEntity *en = [result objectAtIndex:0];
    
    en.real_name = real_name;
    en.user_name = user_name;
    en.sid = sid;
    en.department = department;
    
    [self saveContext];
    
}

-(void)insertPercentData:(NSNumber *)user_id ModelName:(NSString *)modeName Percent:(NSString *)percent PercentStyle:(NSString *)percentStyle
{
    if ([self managedObjectContext] == nil) {
        return ;
    }
    
    PercentEntity *userEntity = (PercentEntity *) [NSEntityDescription insertNewObjectForEntityForName:@"PercentEntity" inManagedObjectContext:self.managedObjectContext];
    
    NSLog(@"percent ,%@",percent);
    NSLog(@"modeName ,%@",modeName);
    NSLog(@"percent ,%@",percent);
    NSLog(@"percentStyle ,%@",percentStyle);
    [userEntity setValue:user_id forKey:@"user_id"];
    [userEntity setValue:modeName forKey:@"model_name"];
    [userEntity setValue:percentStyle forKey:@"percent_stype"];
    [userEntity setValue:percent forKey:@"percent"];
    [self saveContext];
}

-(void)deletePercentData:(NSNumber *)user_id ModelName:(NSString *)modeName
{
    if ([self managedObjectContext] == nil) {
        return;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PercentEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %d AND model_name == %@", [user_id intValue], modeName];
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (PercentEntity *en in result)
    {
        [self.managedObjectContext deleteObject:en];
    }
    
    [self saveContext];
}

-(NSMutableArray *)getAllPercentByUserID:(NSNumber *)user_id
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PercentEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"user_id == %d", [user_id intValue]];
    
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *result1 = [[NSMutableArray alloc] init];
    
    for (PercentEntity *en in result) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:en.model_name forKey:@"model_name"];
        [dic setObject:en.percent_stype forKey:@"percent_style"];
        [dic setObject:en.percent forKey:@"percent"];
        [result1 addObject:dic];
    }
    return result1;
}

-(Boolean)getPercentDataByModelName:(NSString *)modelname ByUserID:(NSNumber *)user_id
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PercentEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"user_id == %d AND model_name == %@", [user_id intValue], modelname];
    
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if ([result count] > 0)
    {
        return true;
    }
    return false;
}


//TODO 重构
-(void) insertBaseDataByJson:(NSString *)json ByUserID:(NSNumber *)user_id
{
    if ([self managedObjectContext] == nil) {
        return ;
    }
    
    BaseDataJSONEntity *basedatajson = (BaseDataJSONEntity *) [NSEntityDescription insertNewObjectForEntityForName:@"BaseDataJSONEntity" inManagedObjectContext:self.managedObjectContext];
    basedatajson.user_id = user_id;
    basedatajson.json = json;
    
    [self saveContext];
}

-(void) insertSetUsual:(NSString *)name ByUserID:(NSNumber *)user_id
{
    if ([self managedObjectContext] == nil) {
        return ;
    }
    
    SetUsualEntity *basedatajson = (SetUsualEntity *) [NSEntityDescription insertNewObjectForEntityForName:@"SetUsualEntity" inManagedObjectContext:self.managedObjectContext];
    basedatajson.user_id = user_id;
    basedatajson.name = name;
    
    [self saveContext];
}

-(void) deleteSetUsualByUserID:(NSNumber *)user_id AndName:(NSString *)name
{
    if ([self managedObjectContext] == nil) {
        return;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SetUsualEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %d And name =  %@", [user_id intValue], name];
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (SetUsualEntity *en in result)
    {
        [self.managedObjectContext deleteObject:en];
    }
    
    [self saveContext];
}


-(void) deleteBaseDataByUserID:(NSNumber *)user_id
{
    if ([self managedObjectContext] == nil) {
        return;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataJSONEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %d", [user_id intValue]];
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (BaseDataJSONEntity *en in result)
    {
        [self.managedObjectContext deleteObject:en];
    }
    
    [self saveContext];
}

-(NSMutableArray *) getStoreListByUserID:(NSNumber *)user_id
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataJSONEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"user_id == %d",[user_id intValue]];
    
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    
    NSMutableArray *result1 = [[NSMutableArray alloc] init];
    if ([result count] == 0)
    {
        return result1;
    }
    BaseDataJSONEntity *jsonentity = [result objectAtIndex:0];
    NSString *jsonstr = jsonentity.json;
    
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [decoder objectWithData:data];
    NSArray *storelist = [json objectForKey:@"storeList"];
    
    for (NSDictionary *dic in storelist)
    {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
        [temp setObject:[dic objectForKey:@"addon1"] forKey:@"addon1"];
        [temp setObject:[dic objectForKey:@"addon2"] forKey:@"addon2"];
        [temp setObject:[dic objectForKey:@"name"] forKey:@"name"];
        [temp setObject:[dic objectForKey:@"id"] forKey:@"base_id"];
        [result1 addObject:temp];
    }
    return result1;
}

-(NSMutableArray *) getBrandListByUserID:(NSNumber *)user_id
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataJSONEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"user_id == %d", [user_id intValue]];
    
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    
    NSMutableArray *result1 = [[NSMutableArray alloc] init];
    if ([result count] == 0)
    {
        return result1;
    }
    BaseDataJSONEntity *jsonentity = [result objectAtIndex:0];
    NSString *jsonstr = jsonentity.json;
    
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [decoder objectWithData:data];
    NSArray *brandlist = [json objectForKey:@"brandList"];
    
    
    for (NSDictionary *dic in brandlist)
    {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
        [temp setObject:[dic objectForKey:@"addon2"] forKey:@"addon2"];
        [result1 addObject:temp];
    }
    
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [result1 count]; i++){
        if ([categoryArray containsObject:[[result1 objectAtIndex:i] objectForKey:@"addon2"]] == NO){
            [categoryArray addObject:[[result1 objectAtIndex:i] objectForKey:@"addon2"]];
        }
    }
    return categoryArray;
    
}

-(NSMutableArray *)getBrandNameListByUserID:(NSNumber *)user_id ByName:(NSString *)brandName
{
    NSLog(@"brandName %@", brandName);
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataJSONEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"user_id == %d" ,[user_id intValue]];
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *result1 = [[NSMutableArray alloc] init];
    if ([result count] == 0)
    {
        return result1;
    }
    BaseDataJSONEntity *jsonentity = [result objectAtIndex:0];
    NSString *jsonstr = jsonentity.json;
    
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [decoder objectWithData:data];
    NSArray *brandlist = [json objectForKey:@"brandList"];
    
    for (NSDictionary *dic in brandlist)
    {
        NSString *brand = [dic objectForKey:@"addon2"];
        NSLog(@"brandname %@" ,brand);
        NSLog(@"brandname %@" ,brandName);
        if ([brand isEqualToString:brandName])
        {
            [result1 addObject:[dic objectForKey:@"name"]];
        }
    }
    return result1;
    
}

-(NSMutableArray *) getPeListByUserID:(NSNumber *)user_id
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataJSONEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"user_id == %d",[user_id intValue]];
    
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    
    NSMutableArray *result1 = [[NSMutableArray alloc] init];
    if ([result count] == 0)
    {
        return result1;
    }
    BaseDataJSONEntity *jsonentity = [result objectAtIndex:0];
    NSString *jsonstr = jsonentity.json;
    
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [decoder objectWithData:data];
    NSArray *storelist = [json objectForKey:@"peList"];
    
    for (NSDictionary *dic in storelist)
    {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
        [temp setObject:[dic objectForKey:@"addon1"] forKey:@"addon1"];
        [temp setObject:[dic objectForKey:@"addon2"] forKey:@"addon2"];
        [temp setObject:[dic objectForKey:@"name"] forKey:@"name"];
        [temp setObject:[dic objectForKey:@"id"] forKey:@"base_id"];
        [result1 addObject:temp];
    }
    return result1;
}

-(NSString *)findModelNameByID:(NSNumber *)user_id ByID:(NSString *)_name
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataJSONEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"user_id == %d",[user_id intValue]];
    
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if ([result count] == 0)
    {
        return nil;
    }
    BaseDataJSONEntity *jsonentity = [result objectAtIndex:0];
    NSString *jsonstr = jsonentity.json;
    
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [decoder objectWithData:data];
    NSArray *modelList = [json objectForKey:@"modelList"];
    
    for (NSDictionary *dic in modelList) {
        NSString *modelid = [dic objectForKey:@"id"];
        if ([modelid isEqualToString:_name])
        {
            return [dic objectForKey:@"name"];
        }
    }
    return nil;
}

-(NSString *)findModelID:(NSNumber *)user_id ByName:(NSString *)_name
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataJSONEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"user_id == %d",[user_id intValue]];
    
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if ([result count] == 0)
    {
        return nil;
    }
    BaseDataJSONEntity *jsonentity = [result objectAtIndex:0];
    NSString *jsonstr = jsonentity.json;
    
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [decoder objectWithData:data];
    NSArray *modelList = [json objectForKey:@"modelList"];
    
    for (NSDictionary *dic in modelList) {
        NSString *modelid = [dic objectForKey:@"name"];
        if ([modelid isEqualToString:_name])
        {
            return [dic objectForKey:@"id"];
        }
    }
    return nil;
}

-(NSString *)findBrandID:(NSNumber *)user_id ByName:(NSString *)_name
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataJSONEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"user_id == %d",[user_id intValue]];
    
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if ([result count] == 0)
    {
        return nil;
    }
    BaseDataJSONEntity *jsonentity = [result objectAtIndex:0];
    NSString *jsonstr = jsonentity.json;
    
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [decoder objectWithData:data];
    NSArray *modelList = [json objectForKey:@"brandList"];
    
    for (NSDictionary *dic in modelList) {
        NSString *modelid = [dic objectForKey:@"name"];
        if ([modelid isEqualToString:_name])
        {
            return [dic objectForKey:@"id"];
        }
    }
    return nil;
}

-(NSString *)findStoreID:(NSNumber *)user_id ByName:(NSString *)_name
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataJSONEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"user_id == %d",[user_id intValue]];
    
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    if ([result count] == 0)
    {
        return nil;
    }
    BaseDataJSONEntity *jsonentity = [result objectAtIndex:0];
    NSString *jsonstr = jsonentity.json;
    
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [decoder objectWithData:data];
    NSArray *modelList = [json objectForKey:@"storeList"];
    
    for (NSDictionary *dic in modelList) {
        NSString *modelid = [dic objectForKey:@"name"];
        if ([modelid isEqualToString:_name])
        {
            return [dic objectForKey:@"id"];
        }
    }
    return nil;
}

-(NSMutableArray *) getUsualModelListByUserID:(NSNumber *)user_id ByName:(NSString *)name ByPage:(int)page
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SetUsualEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:20];
    [fetchRequest setFetchOffset:page * 20];
    NSPredicate * predicate = nil;
    if (name == nil)
    {
        predicate = [NSPredicate predicateWithFormat:@"user_id == %d",[user_id intValue]];
    }else
    {
        predicate = [NSPredicate predicateWithFormat:@"user_id == %d AND name like %@", [user_id intValue], name];
    }
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *result1 = [[NSMutableArray alloc] init];
    
    for (SetUsualEntity *en in result) {
        [result1 addObject:en.name];
    }
    return result1;
}

-(NSMutableArray *) getUnusualModelListByUserID:(NSNumber *)user_id ByName:(NSString *)name ByPage:(int)page
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SetUsualEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"user_id == %d", [user_id intValue]];
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *resultusual = [[NSMutableArray alloc] init];
    NSMutableArray *resultAllUnusual = [[NSMutableArray alloc] init];
    NSMutableArray *resultUnusual = [[NSMutableArray alloc] init];
    for (SetUsualEntity *en in result) {
        [resultusual addObject:en.name];
    }
    
    // 获取所有数据从JSON
    NSMutableArray *resultAllModelName = [self getAllModelNameListByUserID:user_id];
    for (NSString *_name in resultAllModelName) {
        if (name == nil)
        {
            if ([resultusual containsObject:_name] == NO)
            {
                [resultAllUnusual addObject:_name];
            }
        }else
        {
            if ([resultusual containsObject:_name] == NO && [self rangeString:_name AndName:name])
            {
                [resultAllUnusual addObject:_name];
            }
        }
    }
    
    // 分页
    NSLog(@"resultAllUnusual.count = %d, page = %d",resultAllUnusual.count,page);
    int j = 0;
    for (int i = page * 20; i < resultAllUnusual.count; i++) {
        if (j == 20)
        {
            break;
        }
        j++;
        [resultUnusual addObject:[resultAllUnusual objectAtIndex:i]];
    }
    
    return resultUnusual;
}

-(Boolean) rangeString:(NSString *)string1 AndName:(NSString *)string2
{
    NSRange range = [string1 rangeOfString:string2];
    int leight = range.length;
    if (leight == 0)
    {
        return false;
    }else
    {
        return true;
    }
}

-(NSMutableArray *) getAllUnusualModelNameListByUserID:(NSNumber *)user_id
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataJSONEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"user_id == %d", [user_id intValue]];
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *result1 = [[NSMutableArray alloc] init];
    if ([result count] == 0) {
        return result1;
    }
    
    NSMutableArray *unusualList = [[NSMutableArray alloc] init];
    
    BaseDataJSONEntity *jsonentity = [result objectAtIndex:0];
    NSString *jsonstr = jsonentity.json;
    
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [decoder objectWithData:data];
    NSArray *modelList = [json objectForKey:@"modelList"];
    
    NSMutableArray *usualList = [self getAllUsualModelNameListByUserID:user_id];
    
    for (NSDictionary *dic in modelList)
    {
        NSString *name = [dic objectForKey:@"name"];
        if (![usualList containsObject:name])
        {
            [unusualList addObject:name];
        }
    }
    return unusualList;
}


-(NSMutableArray *) getAllUsualModelNameListByUserID:(NSNumber *)user_id
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SetUsualEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"user_id == %d", [user_id intValue]];
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *result1 = [[NSMutableArray alloc] init];
    
    for (SetUsualEntity *en in result) {
        [result1 addObject:en.name];
    }
    return result1;
}

-(NSMutableArray *) getAllModelNameListByUserID:(NSNumber *)user_id
{
    if ([self managedObjectContext] == nil) {
        return nil;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BaseDataJSONEntity" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate * predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"user_id == %d", [user_id intValue]];
    [fetchRequest setPredicate:predicate];
    
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *result1 = [[NSMutableArray alloc] init];
    if ([result count] == 0) {
        return result1;
    }
    
    BaseDataJSONEntity *jsonentity = [result objectAtIndex:0];
    NSString *jsonstr = jsonentity.json;
    
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [decoder objectWithData:data];
    NSArray *modelList = [json objectForKey:@"modelList"];
    
    for (NSDictionary *dic in modelList)
    {
        [result1 addObject:[dic objectForKey:@"name"]];
    }
    return result1;
}

@end
