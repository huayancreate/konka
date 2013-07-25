//
//  HYUIDevice+Help.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-3.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UIDevice (Help)


/*
 *根据mac地址和设备信息获取设备唯一标示（ios5以后的系统中已经停止使用设备标示uniqueIdentifier）
 */
- (NSString *) uniqueDeviceIdentifier;

/*
 *根据mac地址获取设备唯一标示（ios5以后的系统中已经停止使用设备标示uniqueIdentifier）
 */
- (NSString *) uniqueGlobalDeviceIdentifier;

/*
 *判断设备是否越狱
 */
- (BOOL)isJailbroken;


@end
