//
//  HYBaseViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-3.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYBaseViewController ()

@property (nonatomic, strong) NSCalendar *cal;
@property (nonatomic, strong) NSDateComponents *components;
@property (nonatomic, strong) NSDateFormatter * dateFormatter;
@property (nonatomic, strong) NSTimer *_timer;


@end

@implementation HYBaseViewController
@synthesize titlename;
@synthesize parentView;
@synthesize locManager;
@synthesize userLogin;
@synthesize newpassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.userLogin = [[HYUserLoginModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *backButtonImage = [UIImage imageNamed:@"back_white.png"];
    CGRect frameimg = CGRectMake(0, 0, 20, 24);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    
    [someButton addTarget:self action:@selector(backButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.leftBarButtonItem  = leftButton;

    UIImage *formulaImage = [UIImage imageNamed:@"head_bg.png"];
    
    [self.navigationController.navigationBar setBackgroundImage:formulaImage forBarMetrics:UIBarMetricsDefault];
    
    self.cal = [NSCalendar currentCalendar];
    self.components = [self.cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    [self.components setHour:-[self.components hour]];
    [self.components setMinute:-[self.components minute]];
    [self.components setSecond:-[self.components second]];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy年MM月"];
    
    locManager = [[CLLocationManager alloc] init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    //[locManager startUpdatingLocation];
    
    newpassword = self.userLogin.password;
    
    [self startTimer];
}

- (void)stopTimer
{
    if(self._timer != nil){
        [self._timer invalidate];
        self._timer = nil;
    }
}

- (void)startTimer
{
    self._timer = [NSTimer scheduledTimerWithTimeInterval:GPSUpdateTimer target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)onTimer
{
    [self stopTimer];
    [locManager startUpdatingLocation];
}


-(void)backButtonAction:(id)sender
{
    self.userLogin.password = newpassword;
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark DataProcesse
- (void) requestFinished:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endRequest:) withObject:responsestring waitUntilDone:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败";
    [self performSelectorOnMainThread:@selector(endFailedRequest:) withObject:responsestring waitUntilDone:YES];
}

-(void) endFailedRequest:(NSString *)msg
{
    //
}

-(void) endRequest:(NSString *)msg
{
    //
}

-(void) cancelButtonClick:(id)sender
{
    @try {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    }
    
}

-(void) alertMsg:(NSString *)msg forTittle:(NSString *)tittle{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:tittle message:msg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
	[alertView show];
}

-(NSString *) getNowDate{
    NSDate *date = [self.cal dateByAddingComponents:self.components toDate:[[NSDate alloc] init] options:0];
    NSString * s = [self.dateFormatter stringFromDate:date];
    return s;
}

-(NSString *) getUpMonthDate:(NSString *) currentDate{
    NSDate *dateTime = [self.dateFormatter dateFromString:currentDate];
    
    self.components = [self.cal components:( NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit ) fromDate:dateTime];
    
    [self.components setMonth:([self.components month] - 1)];
    NSDate *date = [self.cal dateFromComponents:self.components];
    
    NSString * s = [self.dateFormatter stringFromDate:date];
    return s;
}

-(NSString *) getDownMonthDate:(NSString *) currentDate{
    NSDate *dateTime = [self.dateFormatter dateFromString:currentDate];
    
    self.components = [self.cal components:( NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit ) fromDate:dateTime];
    [self.components setHour:-[self.components hour]];
    [self.components setMinute:-[self.components minute]];
    [self.components setSecond:-[self.components second]];
    
    [self.components setMonth:([self.components month] + 1)];
    NSDate *date = [self.cal dateFromComponents:self.components];
    
    NSString * s = [self.dateFormatter stringFromDate:date];
    return s;
}

#pragma mark CoreLocation Delegate Methods
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D locat = [newLocation coordinate];
    float lattitude = locat.latitude;
    float longitude = locat.longitude;
    float horizon = newLocation.horizontalAccuracy;
    float vertical = newLocation.verticalAccuracy;
    NSString *strShow = [[NSString alloc] initWithFormat:
                         @"currentpos: 经度＝%f 维度＝%f 水平准确读＝%f 垂直准确度＝%f ",
                         lattitude, longitude, horizon, vertical];
    
    //TODO 提交
    NSLog(@"经纬度 %@",strShow);
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSString *errorMessage;
    if ([error code] == kCLErrorDenied){
        errorMessage = @"你的访问被拒绝";}
    if ([error code] == kCLErrorLocationUnknown) {
        errorMessage = @"无法定位到你的位置!";}
    NSLog(@"错误 %@",errorMessage);
}

@end
