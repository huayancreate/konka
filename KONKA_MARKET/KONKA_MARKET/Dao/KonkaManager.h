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
#import "PercentEntity.h"
#import "BaseDataJSONEntity.h"
#import "SetUsualEntity.h"

@interface KonkaManager : NSObject
{
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
}

-(void) insertUserDataByParems:(NSMutableDictionary *)dic;
//-(void) insertBaseDataByParems:(NSMutableDictionary *)dic;
-(Boolean) isExistUserDataByID:(NSNumber *)user_id;
-(void) updateDataPatch:(NSString *)dataPatch ByUserID:(NSNumber *)user_id;
-(NSString *) selectDataPatchByUserID:(NSNumber *)user_id;

-(void) updateModelListFlag:(NSNumber *)flag ByName:(NSString *)name ByUserID:(NSNumber *)user_id;


-(void)updateUserInfoByUserID:(NSNumber *)user_id UserName:(NSString *)user_name RealName:(NSString *)real_name Sid:(NSString *)sid department:(NSString *)department;

-(void)insertPercentData:(NSNumber *)user_id ModelName:(NSString *)modeName Percent:(NSString *)percent PercentStyle:(NSString *)percentStyle;

-(void)deletePercentData:(NSNumber *)user_id ModelName:(NSString *)modeName;

-(NSMutableArray *)getAllPercentByUserID:(NSNumber *)user_id;

-(Boolean)getPercentDataByModelName:(NSString *)modelname ByUserID:(NSNumber *)user_id;


//TODO 重构代码
-(void) insertBaseDataByJson:(NSString *)json ByUserID:(NSNumber *)user_id;
-(void) insertSetUsual:(NSString *)name ByUserID:(NSNumber *)user_id;
-(void) deleteBaseDataByUserID:(NSNumber *)user_id;
-(void) deleteSetUsualByUserID:(NSNumber *)user_id AndName:(NSString *)name;
-(NSMutableArray *) getStoreListByUserID:(NSNumber *)user_id;
-(NSMutableArray *) getBrandListByUserID:(NSNumber *)user_id;
-(NSMutableArray *) getBrandNameListByUserID:(NSNumber *)user_id ByName:(NSString *)brandName;
-(NSMutableArray *) getPeListByUserID:(NSNumber *)user_id;

-(NSString *) findModelNameByID:(NSNumber *)user_id ByID:(NSString *)addon2;

-(NSString *) findModelID:(NSNumber *)user_id ByName:(NSString *)name;

-(NSString *) findBrandID:(NSNumber *)user_id ByName:(NSString *)name;

-(NSString *) findStoreID:(NSNumber *)user_id ByName:(NSString *)name;

-(NSMutableArray *) getUsualModelListByUserID:(NSNumber *)user_id ByName:(NSString *)name ByPage:(int)page;

-(NSMutableArray *) getUnusualModelListByUserID:(NSNumber *)user_id ByName:(NSString *)name ByPage:(int)page;

-(NSMutableArray *) getAllUsualModelNameListByUserID:(NSNumber *)user_id;

-(NSMutableArray *) getAllModelNameListByUserID:(NSNumber *)user_id;

@end
