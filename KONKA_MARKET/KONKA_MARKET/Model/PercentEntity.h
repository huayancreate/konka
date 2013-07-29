//
//  PercentEntity.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-29.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PercentEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * model_name;
@property (nonatomic, retain) NSString * percent_stype;
@property (nonatomic, retain) NSString * percent;

@end
