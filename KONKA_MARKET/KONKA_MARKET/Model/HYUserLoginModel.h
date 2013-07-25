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
@property (nonatomic, retain) NSString *department;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSArray *modelList;
@property (nonatomic, retain) NSMutableArray *modelNameList;

@end
