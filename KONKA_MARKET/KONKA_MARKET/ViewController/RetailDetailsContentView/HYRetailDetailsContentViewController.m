//
//  HYRetailDetailsContentViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-12-4.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYRetailDetailsContentViewController.h"
#import "HYRetailSearchViewController.h"

@interface HYRetailDetailsContentViewController ()

@end

@implementation HYRetailDetailsContentViewController
@synthesize uiTableView;
@synthesize currentDate;
@synthesize resultList;
@synthesize lblSaleCount;
@synthesize lblSaleMoney;
@synthesize lblModelName;
@synthesize endTime;
@synthesize startTime;
@synthesize dateLabel;
@synthesize store_id;
@synthesize heardTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[super someButton] addTarget:self action:@selector(backButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *backButtonImage = [UIImage imageNamed:@"btn_search"];
    CGRect frameimg = CGRectMake(0, 0, 32, 24);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(search:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem  = rightButton;
    
    self.resultList = [[NSMutableArray alloc] init];
    UIView *tempView = [[UIView alloc] init];
    
    heardTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 320, 120)
                                                style:UITableViewStyleGrouped];
    heardTableView.delegate = self;
    heardTableView.dataSource = self;
    
    uiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, 320, [super screenHeight]-80)
                                               style:UITableViewStyleGrouped];
    uiTableView.scrollEnabled = YES;
    uiTableView.delegate = self;
    uiTableView.dataSource = self;
    
    [uiTableView setBackgroundView:tempView];
    //[heardTableView setBackgroundView:tempView];
    [self.view addSubview:uiTableView];
    [self.view addSubview:heardTableView];
    
    
    if(startTime.length <= 0 && endTime.length <= 0){
        dateLabel = [[UIButton alloc] initWithFrame:CGRectMake(105, 8, 111, 25)];
        [dateLabel setTitle:@"日期：当天" forState:UIControlStateNormal];
        startTime = [[super getNowDateYYYYMMDD] stringByAppendingString:@" 00:00:00"];
        
    }else{
        dateLabel = [[UIButton alloc] initWithFrame:CGRectMake(40, 8, 250, 25)];
        NSString *content = [@"日期:" stringByAppendingString:startTime];
        content = [content stringByAppendingString:@"至"];
        content = [content stringByAppendingString:endTime];
        NSString *temp= [content stringByReplacingOccurrencesOfString:@" 00:00:00" withString:@""];
        temp = [temp stringByReplacingOccurrencesOfString:@" 23:59:59" withString:@""];
        [dateLabel setTitle:temp forState:UIControlStateNormal];
    }
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [self.view addSubview:dateLabel];
    
    [dateLabel addTarget:self action:@selector(search:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self loadRetail];
    
}

-(UITableViewCell *) createTabelViewCellForIndentifier: (NSString *) indentifier NibNamed: (NSString *) nibName tableView:(UITableView *)tableView index:(int) index{
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier: indentifier];
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:nibName owner:self options:nil];
    cell = [nib objectAtIndex:index];
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
   
    if(tableView == self.heardTableView)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        //cell = [self createTabelViewCellForIndentifier:@"RetailsIdentifier" NibNamed:@"HYRetailDetailsContentTableViewCell" tableView:tableView index:0];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYRetailDetailsContentTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        //[tableView insertRowsAtIndexPaths:0 withRowAnimation:UITableViewRowAnimationNone];
        return cell;
    }
    if(tableView == self.uiTableView)
    {
        NSDictionary *dic = [self.resultList objectAtIndex:indexPath.row];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell = [self createTabelViewCellForIndentifier:@"RetailsIdentifier" NibNamed:@"HYRetailDetailsContentTableViewCell" tableView:tableView index:1];
        NSLog(@"indexPath.row %d",indexPath.row);
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        self.lblModelName.text = [dic objectForKey:@"md_name"];
        self.lblSaleMoney.text = [formatter stringFromNumber: [dic objectForKey:@"sail_price"]];
        self.lblSaleCount.text = [formatter stringFromNumber: [dic objectForKey:@"sail_num"]];
        return cell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)loadRetail
{
    NSString *date = @"";
    NSLog(@"currentDate %@",self.currentDate);
    if([self.currentDate length] == 0){
        date = [super getNowDate];
    }
    else{
        date = self.currentDate;
    }
    //    NSString *firstDay = [super getFirstDayFromMoth:date];
    //    NSString *lastDay = [super getLastDayFromMoth:date];
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name, @"user_name",self.userLogin.user_id, @"user_id",self.userLogin.password,@"userpass", @"1", @"pager.requestPage", @"10000", @"pager.pageSize", @"2", @"type_value",store_id,@"store_id",startTime,@"startime",endTime,@"endtime",nil];
    
    NSLog(@"username %@",self.userLogin.user_name);
    NSLog(@"userpass %@",self.userLogin.password);
    
    NSLog(@"%@,,,,,",[HYAppUtily stringOutputForDictionary:param]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:RetailDetailsApi]];
    
    NSLog(@"url %@", url.absoluteString);
    [[[DataProcessing alloc] init] sentRequest:url Parem:param Target:self];
}

-(void)endRequest:(NSString *)msg
{
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [decoder objectWithData:data];
    if (json == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"数据获取失败"];
        return;
    }
    [resultList removeAllObjects];
    for (NSDictionary *dic in json) {
        [resultList addObject:dic];
    }
    
    UIView *tempView = [[UIView alloc] init];
    [self.uiTableView setBackgroundView:tempView];
    [self.uiTableView reloadData];
    [SVProgressHUD dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.heardTableView){
        return 1;
    }
    return [resultList count];
    //return [self.modelList count];
}

-(void) endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [super errorMsg:msg];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(IBAction)upMoth:(id)sender
{
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    //currentDate = [super getUpMonthDate:self.dateLabel.text];
    //self.dateLabel.text = [super getUpMonthDate:self.dateLabel.text];
    [self loadRetail];
}

-(IBAction)downMoth:(id)sender
{
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    //currentDate = [super getDownMonthDate:self.dateLabel.text];
    //self.dateLabel.text = [super getDownMonthDate:self.dateLabel.text];
    [self loadRetail];
}

-(IBAction)dataPick:(id)sender
{
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy年MM月"];
    self.minimumDate = [self.dateFormatter dateFromString:@"2012年12月"];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 10, 300, 320);
    [self.view addSubview:calendar];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    NSString *backStr = [[NSString alloc] initWithFormat:[self.dateFormatter stringFromDate:date]];
    //self.dateLabel.text = backStr;
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = backStr;
    NSLog(@"currentDate ,%@" , currentDate);
    [calendar removeFromSuperview];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(void)search:(id)sender{
    HYRetailSearchViewController *searchView = [[HYRetailSearchViewController alloc] init];
    searchView.title = @"高级搜索";
    searchView.userLogin = self.userLogin;
    [self.navigationController pushViewController:searchView animated:YES];
}

@end
