//
//  BaseDataJSONEntity.h
//  KONKA_MARKET
//
//  Created by archon on 13-8-19.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BaseDataJSONEntity : NSManagedObject

@property (nonatomic, retain) NSString * json;
@property (nonatomic, retain) NSNumber * user_id;

@end
