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

@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *real_name;
@property (nonatomic, strong) NSNumber *user_id;
@property (nonatomic, strong) NSArray *storeList;
@property (nonatomic, strong) NSArray *brandList;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSArray *modelList;
@property (nonatomic, strong) NSMutableArray *modelNameList;
@property (nonatomic, strong) NSMutableArray *modelNameCopyList;
@property (nonatomic, strong) NSMutableArray *modelNameStoreList;
@property (nonatomic, strong) NSArray *peList;
@property (nonatomic, strong) NSMutableArray *salesRegisterList;
@property (nonatomic, strong) NSString *salesAllNum;
@property (nonatomic, strong) NSString *salesAllPrice;
@property (nonatomic, strong) NSMutableArray *brandNameList;
@property (nonatomic, strong) NSDictionary *dataSubmit;
@property (nonatomic, strong) NSMutableArray *percentList;
@property (nonatomic, strong) NSMutableDictionary *nameandidList;
@property (nonatomic, strong) NSDictionary *allDataSubmit;
@property (nonatomic, strong) NSNumber *mobile_user_type;
@property (nonatomic, strong) NSDictionary *customManageList;
@property (nonatomic, strong) NSMutableArray *mobileHistoryList;

@end
