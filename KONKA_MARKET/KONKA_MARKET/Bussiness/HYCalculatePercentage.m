//
//  HYCalculatePercentage.m
//  KONKA_MARKET
//
//  Created by archon on 13-8-6.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYCalculatePercentage.h"

@implementation HYCalculatePercentage
@synthesize allnum;
@synthesize allprice;
@synthesize salesList;

@synthesize percentList;
@synthesize percentPrice;

-(void)cal
{
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    for (NSDictionary *dic in salesList) {
        NSNumber *num = [dic objectForKey:@"num"];
        NSLog(@"[num intValue] %d" , [num intValue]);
        NSNumber *price = [dic objectForKey:@"all_price"];
        NSLog(@"[all_price intValue] %.2f" , [price doubleValue]);
        self.allnum = [NSNumber numberWithInt:[self.allnum intValue] + [num intValue]];
        NSString *strPrice = [nf stringFromNumber:price];
        NSDecimalNumber *tempPrice = [NSDecimalNumber decimalNumberWithString:strPrice];
        self.allprice = [self.allprice decimalNumberByAdding:tempPrice];
        [self calPercentPrice:[dic objectForKey:@"model_name"] AndNum:[dic objectForKey:@"num"] AndPrice:[dic objectForKey:@"all_price"]];
    }
    NSLog(@"asdas %d",[self.allnum intValue]);
    NSLog(@"asdas %.2f",[self.allprice doubleValue]);

}

-(void)calPercentPrice:(NSString *)modelname AndNum:(NSNumber *)num AndPrice:(NSNumber *)price
{
    for(NSDictionary *dic in self.percentList)
    {
        if([[dic objectForKey:@"modelname"] isEqualToString:modelname])
        {
            if([[dic objectForKey:@"percentStyle"] isEqualToString:@"0"])
            {
                NSDecimalNumber *temppercent = [NSDecimalNumber decimalNumberWithString:[dic objectForKey:@"percent"]];
                NSDecimalNumber *tempnum = [NSDecimalNumber decimalNumberWithString:[num stringValue]];
                self.percentPrice = [self.percentPrice decimalNumberByAdding:[temppercent decimalNumberByMultiplyingBy:tempnum]];
            }else
            {
                NSDecimalNumber *temppercent = [NSDecimalNumber decimalNumberWithString:[dic objectForKey:@"percent"]];
                NSDecimalNumber *tempprice = [NSDecimalNumber decimalNumberWithString:[price stringValue]];
                self.percentPrice = [self.percentPrice decimalNumberByAdding:[tempprice decimalNumberByMultiplyingBy:[temppercent decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]]]];
            }
        }
    }
}

@end
