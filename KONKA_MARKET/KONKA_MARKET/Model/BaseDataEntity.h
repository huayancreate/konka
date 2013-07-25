//
//  BaseDataEntity.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-25.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BaseDataEntity : NSManagedObject

@property (nonatomic, retain) NSString * addon1;
@property (nonatomic, retain) NSString * addon2;
@property (nonatomic, retain) NSString * base_id;
@property (nonatomic, retain) NSString * list_type;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * flag;

@end
