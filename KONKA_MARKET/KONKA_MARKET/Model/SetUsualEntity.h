//
//  SetUsualEntity.h
//  KONKA_MARKET
//
//  Created by archon on 13-8-20.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SetUsualEntity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * user_id;

@end
