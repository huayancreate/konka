//
//  HYUserLoginModel.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-24.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KonkaManager.h"

@interface HYUserLoginModel : NSObject

@property (nonatomic, retain) NSString *user_name;
@property (nonatomic, retain) NSString *real_name;
@property (nonatomic, retain) NSNumber *user_id;
@property (nonatomic, retain) NSArray *storeList;
@property (nonatomic, retain) NSArray *brandList;
@property (nonatomic, retain) NSString *department;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSArray *modelList;
@property (nonatomic, retain) NSMutableArray *modelNameList;
@property (nonatomic, retain) NSMutableArray *modelNameCopyList;
@property (nonatomic, retain) NSMutableArray *modelNameStoreList;
@property (nonatomic, retain) NSArray *peList;
@property (nonatomic, retain) NSMutableArray *salesRegisterList;
@property (nonatomic, retain) NSString *salesAllNum;
@property (nonatomic, retain) NSString *salesAllPrice;
@property (nonatomic, retain) NSMutableArray *brandNameList;
@property (nonatomic, retain) NSDictionary *dataSubmit;
@property (nonatomic, retain) NSMutableArray *percentList;
@property (nonatomic, strong) NSMutableDictionary *nameandidList;
@property (nonatomic, strong) NSDictionary *allDataSubmit;
@end
