//
//  HYAppUtily.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-3.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYAppUtily.h"

@implementation HYAppUtily

+ (NSString *)stringOutputForDictionary:(NSDictionary *)inputDict {
    NSMutableString * outputString = [NSMutableString stringWithCapacity:256];
    
    NSArray * allKeys = [inputDict allKeys];
    
    for (NSString * key in allKeys) {
        if ([[inputDict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            [outputString appendString: [self stringOutputForDictionary: (NSDictionary *)inputDict]];
        }
        else {
            [outputString appendString: key];
            [outputString appendString: @": "];
            [outputString appendString: [[inputDict objectForKey: key] description]];
        }
        [outputString appendString: @"\n"];
    }
    
    return [NSString stringWithString: outputString];
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end

