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
#import "HYAppUtily.h"
#import "HYUserLoginModel.h"
#import "UIKeyboardViewController.h"
#import "SVProgressHUD.h"

@interface HYBaseViewController : UIViewController<SDWebDataManagerDelegate,CLLocationManagerDelegate,UIKeyboardViewControllerDelegate,UIGestureRecognizerDelegate>
{
    NSString *title;
    
	long long expectedLength;
	long long currentLength;
    HYBaseViewController *parentView;
    
    CLLocationManager *locManager;
    
    UIKeyboardViewController *keyBoardController;
}

-(IBAction)textFieldDoneEditing:(id)sender;

@property (nonatomic, retain) CLLocationManager *locManager;
@property (nonatomic, retain)  NSString *titlename;
@property (nonatomic, retain) HYBaseViewController *parentView;
@property (nonatomic, strong) HYUserLoginModel *userLogin;
@property (nonatomic, strong) NSString *newpassword;
@property (nonatomic, strong) KonkaManager *kkM;

-(void) endRequest:(NSString *)msg;
-(void) cancelButtonClick:(id)sender;
-(void) alertMsg:(NSString *)msg forTittle:(NSString *)tittle;
-(NSString *) getNowDate;
-(NSString *) getNowDateYYYYMMDD;
-(NSString *) getUpMonthDate:(NSString *) currentDate;
-(NSString *) getDownMonthDate:(NSString *) currentDate;
-(NSString *) getFirstDayFromMoth:(NSString *)date;
-(NSString *) getLastDayFromMoth:(NSString *)date;
@end
