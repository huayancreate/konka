//
//  HYBaseViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-3.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HYSeverContUrl.h"
#import "SDWebDataManager.h"
#import "DataProcessing.h"
#import "HYConstants.h"
#import "ZBarSDK.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "HYAppUtily.h"
#import "HYUserLoginModel.h"

@interface HYBaseViewController : UIViewController<SDWebDataManagerDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate>
{
    NSString *title;
    MBProgressHUD *HUD;
    
	long long expectedLength;
	long long currentLength;
    HYBaseViewController *parentView;
    
    CLLocationManager *locManager;
}

@property (nonatomic, retain) CLLocationManager *locManager;
@property (nonatomic, retain)  NSString *titlename;
@property (nonatomic, retain) HYBaseViewController *parentView;
@property (nonatomic, strong) HYUserLoginModel *userLogin;
@property (nonatomic, strong) NSString *newpassword;

-(void) endRequest:(NSString *)msg;
-(void) cancelButtonClick:(id)sender;
-(void) setResizeForKeyboard;
-(void) alertMsg:(NSString *)msg forTittle:(NSString *)tittle;
-(NSString *) getNowDate;
-(NSString *) getUpMonthDate:(NSString *) currentDate;
-(NSString *) getDownMonthDate:(NSString *) currentDate;

@end
