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
@property (nonatomic) float lattitude;
@property (nonatomic) float longitude;
@property (nonatomic) int flagcount;


@end

@implementation HYBaseViewController
@synthesize titlename;
@synthesize parentView;
@synthesize locManager;
@synthesize userLogin;
@synthesize newpassword;
@synthesize kkM;
@synthesize title;
@synthesize lattitude;
@synthesize longitude;
@synthesize flagcount;
@synthesize screenHeight;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.userLogin = [[HYUserLoginModel alloc] init];
        self.flagcount = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenRect.size;
    self.screenHeight = screenSize.height;
    
    
    self.kkM = [[KonkaManager alloc] init];
    UIImage *backButtonImage = [UIImage imageNamed:@"back"];
    CGRect frameimg = CGRectMake(0, 0, 20, 24);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    
    [someButton addTarget:self action:@selector(backButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.leftBarButtonItem  = leftButton;

    UIImage *formulaImage = [UIImage imageNamed:@"headbg@2x.png"];
    
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

-(void)firstHandle:(UIGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:TRUE]; 
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
    if (self._timer == nil)
    {
        self._timer = [NSTimer scheduledTimerWithTimeInterval:GPSUpdateTimer target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
}

- (void)onTimer
{
    //[self stopTimer];
    [self updateGPS];
}

-(void) updateGPS
{
    NSLog(@"%f,%f" ,lattitude,longitude);
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name,@"username",self.userLogin.password,@"userpass",@"SaveGPSInfo",@"method",[NSString stringWithFormat:@"%f", lattitude],@"X",[NSString stringWithFormat:@"%f", longitude],@"Y",nil];
    
    [HYAppUtily stringOutputForDictionary:params];
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:DataGPSUpdateApi]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    if (params) {
        NSArray *array = [params allKeys];
        for (int i= 0; i <[array count]; i++) {
            [request setPostValue:[params objectForKey:[array objectAtIndex:i]] forKey:[array objectAtIndex:i]];
        }
        
    }
    [request setDidFinishSelector:@selector(endGPSFin:)];
    [request setDidFailSelector:@selector(endGPSFail:)];
    [request setPersistentConnectionTimeoutSeconds:15];
    [request setNumberOfTimesToRetryOnTimeout:1];
    [request startAsynchronous];
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
    NSLog(@"msg %@", msg);
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

-(void) successMsg:(NSString *)msg{
    [SVProgressHUD showSuccessWithStatus:msg];
}

-(void) errorMsg:(NSString *)msg{
    [SVProgressHUD showErrorWithStatus:msg];
}



-(NSString *) getNowDate{
    NSDate *dateTime = [[NSDate alloc] init];
    NSLog(@"datetime ,%@", [self.dateFormatter stringFromDate:dateTime]);
    self.components = [self.cal components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:dateTime];
    [self.components setHour:-[self.components hour]];
    [self.components setMinute:-[self.components minute]];
    [self.components setSecond:-[self.components second]];
    [self.components setMonth:([self.components month])];
    NSDate *date = [self.cal dateFromComponents:self.components];
    NSString * s = [self.dateFormatter stringFromDate:date];
    NSLog(@"getNowDate s %@", s);
    return s;
}

-(NSString *) getNowYear{
    NSDate *dateTime = [[NSDate alloc] init];
    NSLog(@"datetime ,%@", [self.dateFormatter stringFromDate:dateTime]);
    self.components = [self.cal components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:dateTime];
    [self.components setHour:-[self.components hour]];
    [self.components setMinute:-[self.components minute]];
    [self.components setSecond:-[self.components second]];
    [self.components setMonth:([self.components month])];
    NSDate *date = [self.cal dateFromComponents:self.components];
    [self.dateFormatter setDateFormat:@"yyyy年"];
    NSString * s = [self.dateFormatter stringFromDate:date];
    [self.dateFormatter setDateFormat:@"yyyy年MM月"];
    NSLog(@"getNowDate s %@", s);
    return s;
}

-(NSString *) getNowDateYYYYMMDD{
    NSDate *dateTime = [[NSDate alloc] init];
    NSLog(@"datetime ,%@", [self.dateFormatter stringFromDate:dateTime]);
    self.components = [self.cal components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:dateTime];
    [self.components setHour:-[self.components hour]];
    [self.components setMinute:-[self.components minute]];
    [self.components setSecond:-[self.components second]];
    [self.components setMonth:([self.components month])];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [self.cal dateFromComponents:self.components];
    NSString * s = [self.dateFormatter stringFromDate:date];
    NSLog(@"getNowDateYYYYMMDD s %@", s);
    [self.dateFormatter setDateFormat:@"yyyy年MM月"];
    return s;
}

-(NSData *) getIntervalDateByDays:(int) days ByDate:(NSString *) currentDate
{
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateTime = [self.dateFormatter dateFromString:currentDate];
    self.components = [self.cal components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:dateTime];
    [self.components setYear:[self.components year]];
    [self.components setMonth:[self.components month]];
    [self.components setDay:([self.components day] + days)];
    NSDate *date = [self.cal dateFromComponents:self.components];
    //NSString * s = [self.dateFormatter stringFromDate:date];
    //[self.dateFormatter setDateFormat:@"yyyy年MM月"];
    //NSLog(@"getIntervalDateByDays %@",s);
    return date;
}


-(NSString *) getUpMonthDate:(NSString *) currentDate{
    
    NSDate *dateTime = [self.dateFormatter dateFromString:currentDate];
    self.components = [self.cal components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:dateTime];
    [self.components setMonth:([self.components month] - 1)];
    NSDate *date = [self.cal dateFromComponents:self.components];
    NSString * s = [self.dateFormatter stringFromDate:date];
    NSLog(@"getUpMonthDate %@", s);
    return s;
}

-(NSString *) getDownMonthDate:(NSString *) currentDate{
    NSDate *dateTime = [self.dateFormatter dateFromString:currentDate];
    
    self.components = [self.cal components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:dateTime];
    [self.components setHour:-[self.components hour]];
    [self.components setMinute:-[self.components minute]];
    [self.components setSecond:-[self.components second]];
    [self.components setMonth:([self.components month] + 1)];
    NSDate *date = [self.cal dateFromComponents:self.components];
    NSString * s = [self.dateFormatter stringFromDate:date];
    NSLog(@"getDownMonthDate %@", s);
    return s;
}

-(NSString *) getUpYear:(NSString *) currentDate{
    NSLog(@"currentDate %@", currentDate);
    [self.dateFormatter setDateFormat:@"yyyy年"];
    NSDate *dateTime = [self.dateFormatter dateFromString:currentDate];
    self.components = [self.cal components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:dateTime];
    [self.components setYear:([self.components year] - 1)];
    NSDate *date = [self.cal dateFromComponents:self.components];
    NSString * s = [self.dateFormatter stringFromDate:date];
    [self.dateFormatter setDateFormat:@"yyyy年MM月"];
    NSLog(@"currentDate S, %@", s);
    return s;
}

-(NSString *) getDownYear:(NSString *) currentDate{
    NSLog(@"currentDate %@", currentDate);
    [self.dateFormatter setDateFormat:@"yyyy年"];
    NSDate *dateTime = [self.dateFormatter dateFromString:currentDate];
    self.components = [self.cal components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:dateTime];
    [self.components setHour:-[self.components hour]];
    [self.components setMinute:-[self.components minute]];
    [self.components setSecond:-[self.components second]];
    [self.components setYear:([self.components year] + 1)];
    NSDate *date = [self.cal dateFromComponents:self.components];
    NSString * s = [self.dateFormatter stringFromDate:date];
    [self.dateFormatter setDateFormat:@"yyyy年MM月"];
    return s;
}

#pragma mark CoreLocation Delegate Methods
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D locat = [newLocation coordinate];
    self.lattitude = locat.latitude;
    self.longitude = locat.longitude;
    
    if (self.flagcount == 0)
    {
        [self updateGPS];
        self.flagcount = self.flagcount + 1;
    }
    
    //TODO 提交
//    NSLog(@"经纬度 %@",strShow);
}


- (void) endGPSFin:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endGPSFinString:) withObject:responsestring waitUntilDone:YES];
    
    // 存储basedata
    
}

- (void) endGPSFail:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败";
    [self performSelectorOnMainThread:@selector(endGPSFinString:) withObject:responsestring waitUntilDone:YES];
}

-(void)endGPSFinString:(NSString *)msg
{
    
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

-(NSString *) getFirstDayFromMoth:(NSString *)currentDate
{
    
    NSDate *dateTime = [self.dateFormatter dateFromString:currentDate];
    self.components = [self.cal components:( NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit ) fromDate:dateTime];
    [self.components setHour:-[self.components hour]];
    [self.components setMinute:-[self.components minute]];
    [self.components setSecond:-[self.components second]];
    
    [self.components setMonth:([self.components month])];
    NSDate *date = [self.cal dateFromComponents:self.components];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * s = [self.dateFormatter stringFromDate:date];
    [self.dateFormatter setDateFormat:@"yyyy年MM月"];
    NSLog(@"getFirstDayFromMoth, %@" , s);
    return s;
}

-(NSString *) getFirstDayFromYear:(NSString *)currentDate
{
    [self.dateFormatter setDateFormat:@"yyyy年"];
    NSDate *dateTime = [self.dateFormatter dateFromString:currentDate];
    self.components = [self.cal components:( NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit ) fromDate:dateTime];
    [self.components setHour:-[self.components hour]];
    [self.components setMinute:-[self.components minute]];
    [self.components setSecond:-[self.components second]];
    
    [self.components setYear:([self.components year])];
    NSDate *date = [self.cal dateFromComponents:self.components];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * s = [self.dateFormatter stringFromDate:date];
    [self.dateFormatter setDateFormat:@"yyyy年MM月"];
    NSLog(@"getFirstDayFromYear, %@" , s);
    return s;
}

-(NSString *) getLastDayFromMoth:(NSString *)currentDate
{
    NSDate *dateTime = [self.dateFormatter dateFromString:currentDate];
    self.components = [self.cal components:( NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit ) fromDate:dateTime];
    [self.components setHour:-[self.components hour]];
    [self.components setMinute:-[self.components minute]];
    [self.components setSecond:-[self.components second]];
    
    [self.components setMonth:([self.components month]) + 1];
    [self.components setDay:([self.components day]) - 1];
    NSDate *date = [self.cal dateFromComponents:self.components];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * s = [self.dateFormatter stringFromDate:date];
    [self.dateFormatter setDateFormat:@"yyyy年MM月"];
    NSLog(@"getLastDayFromMoth, %@" , s);
    return s;
}	

-(NSString *) getLastDayFromYear:(NSString *)currentDate
{
    [self.dateFormatter setDateFormat:@"yyyy年"];
    NSDate *dateTime = [self.dateFormatter dateFromString:currentDate];
    self.components = [self.cal components:( NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit ) fromDate:dateTime];
    [self.components setHour:-[self.components hour]];
    [self.components setMinute:-[self.components minute]];
    [self.components setSecond:-[self.components second]];
    
    [self.components setYear:([self.components year]) + 1];
    [self.components setDay:([self.components day]) - 1];
    NSDate *date = [self.cal dateFromComponents:self.components];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * s = [self.dateFormatter stringFromDate:date];
    [self.dateFormatter setDateFormat:@"yyyy年MM月"];
    NSLog(@"getLastDayFromYear, %@" , s);
    return s;
}

-(NSDate *) getDateNow
{
    NSDate *dateTime = [[NSDate alloc] init];
    NSLog(@"datetime ,%@", [self.dateFormatter stringFromDate:dateTime]);
    self.components = [self.cal components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate:dateTime];
    [self.components setHour:-[self.components hour]];
    [self.components setMinute:-[self.components minute]];
    [self.components setSecond:-[self.components second]];
    [self.components setMonth:([self.components month])];
    NSDate *date = [self.cal dateFromComponents:self.components];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString * s = [self.dateFormatter stringFromDate:date];
//    NSDate *date1 = [self.dateFormatter dateFromString:s];
    return date;
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
	[keyBoardController addToolbarToKeyboard];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	//MCRelease(keyBoardController);
}

- (IBAction)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

@end
