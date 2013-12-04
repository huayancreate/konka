//
//  HYRetailDetailsViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-12-4.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYRetailDetailsViewController.h"
#import "HYRetailDetailsContentViewController.h"
#import "HYRetailSearchViewController.h"
#import "HYDecisionRetailViewController.h"

@interface HYRetailDetailsViewController ()
@end

@implementation HYRetailDetailsViewController
@synthesize uiTableView;
@synthesize currentDate;
@synthesize resultList;
@synthesize lblSaleCount;
@synthesize lblSaleMoney;
@synthesize lblStoreName;
@synthesize dateLabel;
@synthesize startTime;
@synthesize endTime;
@synthesize salesNum;
@synthesize salesMoney;

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
    
    self.resultList = [[NSMutableArray alloc] init];
    UIImage *backButtonImage = [UIImage imageNamed:@"right.png"];
    CGRect frameimg = CGRectMake(0, 0, 32, 24);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(search:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem  = rightButton;
    
    
    UIImage *backButtonImage1 = [UIImage imageNamed:@"back"];
    CGRect frameimg1 = CGRectMake(0, 0, 20, 24);
    UIButton *someButton1 = [[UIButton alloc] initWithFrame:frameimg1];
    [someButton1 setBackgroundImage:backButtonImage1 forState:UIControlStateNormal];
    [someButton1 addTarget:self action:@selector(Back:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton1 setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:someButton1];
    self.navigationItem.leftBarButtonItem  = leftButton;
    
    UIView *tempView = [[UIView alloc] init];
    uiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,65, 320, [super screenHeight]-140) style:UITableViewStyleGrouped];
    uiTableView.scrollEnabled = YES;
    uiTableView.delegate = self;
    uiTableView.dataSource = self;
    [uiTableView setBackgroundView:tempView];
    [self.view addSubview:uiTableView];
    
    
    salesNum = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 145, 40)];
    salesNum.text = @"销售数量台:0";
    salesNum.font = [UIFont boldSystemFontOfSize:12];
    salesNum.backgroundColor = [UIColor clearColor];
    [self.view addSubview:salesNum];
    
    salesMoney = [[UILabel alloc] initWithFrame:CGRectMake(150, 25, 160, 40)];
    salesMoney.text = @"销售金额元:0";
    salesMoney.font = [UIFont boldSystemFontOfSize:12];
    salesMoney.backgroundColor = [UIColor clearColor];
    [self.view addSubview:salesMoney];
    
    if(startTime.length <= 0 && endTime.length <= 0){
        dateLabel = [[UIButton alloc] initWithFrame:CGRectMake(105, 5, 115, 25)];
        [dateLabel setTitle:@"日期：当天" forState:UIControlStateNormal];
        startTime = [[super getNowDateYYYYMMDD] stringByAppendingString:@" 00:00:00"];
        endTime = [[super getNowDateYYYYMMDD] stringByAppendingString:@" 23:59:59"];
        
    }else{
        dateLabel = [[UIButton alloc] initWithFrame:CGRectMake(36, 5, 250, 25)];
        NSString *content = [@"日期:" stringByAppendingString: startTime];
        content = [content stringByAppendingString:@"至"];
        content = [content stringByAppendingString:endTime];
        startTime = [startTime stringByAppendingString:@" 00:00:00"];
        endTime = [endTime stringByAppendingString:@" 23:59:59"];
        [dateLabel setTitle:content forState:UIControlStateNormal];
    }
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dateLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [self.view addSubview:dateLabel];
    
    [dateLabel addTarget:self action:@selector(search:)
        forControlEvents:UIControlEventTouchUpInside];
    [self loadRetail];
    
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
    if(tableView == self.uiTableView)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYRetailDetailsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        NSDictionary *dic = [self.resultList objectAtIndex:indexPath.row];
        NSLog(@"sail_num %@",[dic objectForKey:@"sail_num"]);
        NSLog(@"sail_price %@",[dic objectForKey:@"sail_price"]);
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        self.lblStoreName.text = [dic objectForKey:@"store_name"];
        self.lblSaleMoney.text = [formatter stringFromNumber: [dic objectForKey:@"sail_price"]];
        self.lblSaleCount.text = [formatter stringFromNumber: [dic objectForKey:@"sail_num"]];
        //self.lblSaleMoney.text = [dic objectForKey:@"sail_price"];
        //self.lblSaleCount.text = [dic objectForKey:@"sail_num"];
        return cell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.uiTableView)
    {
        return 60;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYRetailDetailsContentViewController *contentView = [[HYRetailDetailsContentViewController alloc] init];
    contentView.title = @"零售明细";
    contentView.userLogin = self.userLogin;
    contentView.startTime = startTime;
    contentView.endTime = endTime;
    [self.navigationController pushViewController:contentView animated:YES];
    
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
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name, @"user_name",self.userLogin.user_id, @"user_id",self.userLogin.password,@"userpass", @"1", @"pager.requestPage", @"10000", @"pager.pageSize", @"3", @"type_value",startTime,@"startime",endTime, @"endtime",nil];
    
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
    int count = 0;
    double price = 0.0;
    
    [resultList removeAllObjects];
    for (NSDictionary *dic in json) {
        [resultList addObject:dic];
        NSLog(@"sail_num %@",[dic objectForKey:@"sail_num"]);
        NSNumber *_count = [dic objectForKey:@"sail_num"];
        NSNumber *_price = [dic objectForKey:@"sail_price"];
        count = count + [_count intValue];
        price = price +[_price doubleValue];
    }

    NSString *preNum = @"销售数量(台):";
    NSString *prePrice = @"销售金额(元):";
    preNum = [preNum stringByAppendingString:[NSString stringWithFormat:@"%d",count]];
    prePrice = [prePrice stringByAppendingString:[NSString stringWithFormat:@"%.2f",price]];
    salesNum.text = preNum;
    salesMoney.text = prePrice;
    
    UIView *tempView = [[UIView alloc] init];
    [self.uiTableView setBackgroundView:tempView];
    [self.uiTableView reloadData];
    [SVProgressHUD dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

-(void)Back:(id)sender{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:3] animated:YES];
}

@end

