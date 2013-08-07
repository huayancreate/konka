//
//  HYCalculatePercentage.h
//  KONKA_MARKET
//
//  Created by archon on 13-8-6.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYCalculatePercentage : NSObject

@property (nonatomic, strong) NSNumber *allnum;
@property (nonatomic, strong) NSDecimalNumber *allprice;
@property (nonatomic, strong) NSDecimalNumber *percentPrice;
@property (nonatomic, strong) NSMutableArray *percentList;
@property (nonatomic, strong) NSArray *salesList;

-(void) cal;

@end
