//
//  KonkaManager.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-23.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UserEntity.h"
#import "BaseDataEntity.h"

@interface KonkaManager : NSObject
{
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

-(void) insertUserDataByParems:(NSMutableDictionary *)dic;
-(void) insertBaseDataByParems:(NSMutableDictionary *)dic;
-(Boolean) isExistUserDataByID:(NSNumber *)user_id;
-(void) updateDataPatch:(NSString *)dataPatch ByUserID:(NSNumber *)user_id;
-(NSString *) selectDataPatchByUserID:(NSNumber *)user_id;
-(NSMutableArray *) getStoreListByUserID:(NSNumber *)user_id ByType:(NSString *)type ByFlag:(NSNumber *)flag;
-(NSMutableArray *) getModelListByUserID:(NSNumber *)user_id ByType:(NSString *)type ByFlag:(NSNumber *)flag ByName:(NSString *)name;

-(void) updateModelListByName:(NSString *)name ByUserID:(NSNumber *)user_id;

@end
