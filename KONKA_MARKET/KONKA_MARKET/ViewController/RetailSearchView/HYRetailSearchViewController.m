//
//  HYRetailSearchViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-12-4.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYRetailSearchViewController.h"
#import "HYRetailDetailsViewController.h"

@interface HYRetailSearchViewController ()

@end

@implementation HYRetailSearchViewController
@synthesize btnSearch;
@synthesize btnBack;
@synthesize btnStartTime;
@synthesize btnEndTime;
@synthesize flagTag;

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
    //self.uiSearch.delegate = self;
    //self.uiSearch.dataSource = self;
    
    UIView *tempView = [[UIView alloc] init];
    [self.uiSearch setBackgroundView:tempView];
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
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"起始日期";
            btnStartTime = [[UIButton alloc] initWithFrame:CGRectMake(120, 1, 150, 24)];
            [btnStartTime setTitle:[super getNowDateYYYYMMDD] forState:UIControlStateNormal];
            [btnStartTime addTarget:self action:@selector(dataPick:) forControlEvents:UIControlEventTouchUpInside];
            [btnStartTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnStartTime.tag = 0;
            [cell addSubview:btnStartTime];
            break;
        case 1:
            cell.textLabel.text = @"截止日期";
            btnEndTime = [[UIButton alloc] initWithFrame:CGRectMake(120, 1, 150, 24)];
            [btnEndTime setTitle:[super getNowDateYYYYMMDD] forState:UIControlStateNormal];
            [btnEndTime addTarget:self action:@selector(dataPick:) forControlEvents:UIControlEventTouchUpInside];
            [btnEndTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnEndTime.tag =1;
            [cell addSubview:btnEndTime];
            break;
        case 2:
            self.btnSearch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btnSearch.frame = CGRectMake(25, 1, 100, 24);
            [btnSearch setBackgroundImage:[UIImage imageNamed:@"sales_reg_foot"] forState:UIControlStateNormal];
            [btnSearch setTitle:@"查询" forState:UIControlStateNormal];
            [btnSearch setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnSearch addTarget:self action:@selector(Search:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:self.btnSearch];
            
            btnBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btnBack.frame = CGRectMake(180, 1, 100, 24);
            [btnBack setBackgroundImage:[UIImage imageNamed:@"sales_reg_foot"] forState:UIControlStateNormal];
            [btnBack setTitle:@"返回" forState:UIControlStateNormal];
            [btnBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnBack addTarget:self action:@selector(Back:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:self.btnBack];
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 28;
    //    if(tableView == self.uiTableView)
    //    {
    //        return 60;
    //    }
    //    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    HYRetailDetailsContentViewController *contentView = [[HYRetailDetailsContentViewController alloc] init];
    //    contentView.title = @"零售明细";
    //    contentView.userLogin = self.userLogin;
    //    //self.userLogin.dataSubmit = resultList;
    //    [self.navigationController pushViewController:contentView animated:YES];
    //
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)loadRetail
{
    //    NSString *date = @"";
    //    NSLog(@"currentDate %@",self.currentDate);
    //    if([self.currentDate length] == 0){
    //        date = [super getNowDate];
    //    }
    //    else{
    //        date = self.currentDate;
    //    }
    //
    //    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    //    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name, @"user_name",self.userLogin.user_id, @"user_id",self.userLogin.password,@"userpass", @"1", @"pager.requestPage", @"10000", @"pager.pageSize", @"3", @"type_value",startTime,@"startime",endTime, @"endtime",nil];
    //
    //    NSLog(@"username %@",self.userLogin.user_name);
    //    NSLog(@"userpass %@",self.userLogin.password);
    //
    //    NSLog(@"%@,,,,,",[HYAppUtily stringOutputForDictionary:param]);
    //
    //    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:RetailDetailsApi]];
    //
    //    NSLog(@"url %@", url.absoluteString);
    //    [[[DataProcessing alloc] init] sentRequest:url Parem:param Target:self];
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
    //    [resultList removeAllObjects];
    //    for (NSDictionary *dic in json) {
    //        [resultList addObject:dic];
    //    }
    //
    //    UIView *tempView = [[UIView alloc] init];
    //    [self.uiTableView setBackgroundView:tempView];
    //    [self.uiTableView reloadData];
    [SVProgressHUD dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    //return [resultList count];
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
    [btnStartTime setTitle:[super getNowDateYYYYMMDD] forState:UIControlStateNormal];
    
    //[SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    //currentDate = [super getUpMonthDate:self.dateLabel.text];
    //self.dateLabel.text = [super getUpMonthDate:self.dateLabel.text];
    [self loadRetail];
}

-(IBAction)downMoth:(id)sender
{
    [btnEndTime setTitle:[super getNowDateYYYYMMDD] forState:UIControlStateNormal];
    
    //[SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    //currentDate = [super getDownMonthDate:self.dateLabel.text];
    //self.dateLabel.text = [super getDownMonthDate:self.dateLabel.text];
    [self loadRetail];
}

-(IBAction)dataPick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    flagTag = button.tag;
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.minimumDate = [self.dateFormatter dateFromString:@"2012-12-1"];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 10, 300, 320);
    [self.view addSubview:calendar];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    NSString *backStr = [[NSString alloc] initWithFormat:[self.dateFormatter stringFromDate:date]];
    if(flagTag == 0){
        [self.btnStartTime setTitle:backStr forState:UIControlStateNormal];
    }else{
        [self.btnEndTime setTitle:backStr forState:UIControlStateNormal];
    }
    [calendar removeFromSuperview];
}


-(void)Search:(id)sender{
    HYRetailDetailsViewController *searchView = [[HYRetailDetailsViewController alloc] init];
    searchView.title = @"零售明细查询";
    searchView.userLogin = self.userLogin;
    searchView.startTime = btnStartTime.titleLabel.text;
    searchView.endTime = btnEndTime.titleLabel.text;
    [self.navigationController pushViewController:searchView animated:YES];
    
}

-(void)Back:(id)sender{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2] animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return 0;
}

@end
