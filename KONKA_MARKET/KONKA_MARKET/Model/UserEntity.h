//
//  UserEntity.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-23.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserEntity : NSManagedObject

@property (nonatomic, retain) NSString * dataPatch;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * real_name;
@property (nonatomic, retain) NSString * sid;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * user_name;

@end
