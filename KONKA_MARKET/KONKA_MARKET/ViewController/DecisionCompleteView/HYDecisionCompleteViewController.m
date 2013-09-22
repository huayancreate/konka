//
//  HYDecisionCompleteViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-9-22.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYDecisionCompleteViewController.h"

@interface HYDecisionCompleteViewController ()

@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@property(nonatomic, strong) UIImage *unRegisterImg;
@property(nonatomic, strong) UIImage *RegisterImg;
@property(nonatomic, strong) NSString *currentDate;

@end

@implementation HYDecisionCompleteViewController
@synthesize topTableView;
@synthesize dateBtn;
@synthesize tableViewCell;
@synthesize currentDate;
@synthesize dateLabel;

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
    self.taskCompleteList = [[NSMutableArray alloc] init];
    self.taskComplete = [[NSMutableDictionary alloc] init];
    self.uiTableView.scrollEnabled = YES;
    self.uiTableView.delegate = self;
    self.uiTableView.dataSource = self;
    
    UIView *tempView = [[UIView alloc] init];
    [self.uiTableView setBackgroundView:tempView];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 22, 111, 19)];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    
    topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -8, 320, 56) style:UITableViewStyleGrouped];
    topTableView.delegate = self;
    topTableView.dataSource = self;
    UIView *tempView1 = [[UIView alloc] init];
    [topTableView setBackgroundView:tempView1];
    topTableView.scrollEnabled = NO;
    [topTableView addSubview:dateLabel];
    [self.view addSubview:topTableView];
    [self loadTaskComplete];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if(tableView == topTableView){
        return 1;
    }
    if(tableView == self.uiTableView){
        return 2;
    }
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView == topTableView){
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"TopTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *temp = [[UIView alloc] init];
        [cell setBackgroundView:temp];
        self.dateLabel.text = [super getNowDate];
        return cell;
    }
    if(tableView == self.uiTableView)
    {
        if(indexPath.section == 1)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYDecisionCompleteTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            NSDictionary *dic = [self.taskCompleteList objectAtIndex:indexPath.row];
            self.lblDeptName.text = [dic objectForKey:@"dept_name"];
            self.lblSale.text = [[dic objectForKey:@"sale"] stringByAppendingString:@"%"];
            
            float sale = [[dic objectForKey:@"sale"] floatValue];
            self.progressView.progress = sale/100;
            
            float allPrice = [[dic objectForKey:@"all_price"] floatValue];
            float rwMoney = [[dic objectForKey:@"rw_money"] floatValue];
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setPositiveFormat:@"###,##0.00;"];
            NSString *formatAllPrice = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:allPrice]];
            NSString *formatRwMoney = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:rwMoney]];
            self.lblAllPrice.text = formatAllPrice;
            self.lblRwMoney.text = formatRwMoney;
            return cell;
        }
        if(indexPath.section == 0){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            NSMutableDictionary *dic1 = self.taskComplete;
            //NSDictionary *dic1 = [self.taskComplete objectAtIndex:indexPath.row];
            float sale = [[dic1 objectForKey:@"rw_sale"] floatValue];
            
            float allPrice = [[dic1 objectForKey:@"total_price"] floatValue];
            float rwMoney = [[dic1 objectForKey:@"rw_money"] floatValue];
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setPositiveFormat:@"###,##0.00;"];
            NSString *formatAllPrice = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:allPrice]];
            NSString *formatRwMoney = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:rwMoney]];

            self.uiProgressView =[[UIProgressView alloc] initWithFrame:CGRectMake(13, 5, 295, 9)];
            self.uiProgressView.progress = sale/100;
            [cell addSubview:self.uiProgressView];
            
            self.lblSalesMsg =[[UILabel alloc] initWithFrame:CGRectMake(13, 15, 100, 21)];
            self.lblSalesMsg.text = @"总进度:";
            self.lblSalesMsg.backgroundColor = [UIColor clearColor];
            self.lblSalesMsg.font = [UIFont fontWithName:@"Helvetica" size:12];
            [cell addSubview:self.lblSalesMsg];
            
            self.lblSales =[[UILabel alloc] initWithFrame:CGRectMake(270, 15, 60, 21)];
            self.lblSales.text = [[dic1 objectForKey:@"rw_sale"]
                                  stringByAppendingString:@"%"];
            self.lblSales.font = [UIFont fontWithName:@"Helvetica" size:12];
            self.lblSales.backgroundColor = [UIColor clearColor];
            self.lblSales.textColor = [UIColor brownColor];
            [cell addSubview:self.lblSales];
            
            self.lblAllPricesMsg =[[UILabel alloc] initWithFrame:
                                   CGRectMake(13, 30, 120, 21)];
            self.lblAllPricesMsg.text = @"结算额(万元):";
            self.lblAllPricesMsg.font = [UIFont fontWithName:@"Helvetica" size:12];
            self.lblAllPricesMsg.backgroundColor = [UIColor clearColor];
            [cell addSubview:self.lblAllPricesMsg];
            
            self.lblAllPrices =[[UILabel alloc] initWithFrame:CGRectMake(100, 30, 120, 21)];
            self.lblAllPrices.text = formatAllPrice;
            self.lblAllPrices.font = [UIFont fontWithName:@"Helvetica" size:12];
            self.lblAllPrices.backgroundColor = [UIColor clearColor];
            self.lblAllPrices.textColor = [UIColor redColor];
            [cell addSubview:self.lblAllPrices];
            
            self.lblRwMoneysMsg =[[UILabel alloc] initWithFrame:CGRectMake(160, 30, 120, 21)];
            self.lblRwMoneysMsg.text = @"任务额(万元):";
            self.lblRwMoneysMsg.font = [UIFont fontWithName:@"Helvetica" size:12];
            self.lblRwMoneysMsg.backgroundColor = [UIColor clearColor];
            [cell addSubview:self.lblRwMoneysMsg];
            
            self.lblRwMoneys =[[UILabel alloc] initWithFrame:CGRectMake(240, 30, 120, 21)];
            self.lblRwMoneys.text = formatRwMoney;
            self.lblRwMoneys.font = [UIFont fontWithName:@"Helvetica" size:12];
            self.lblRwMoneys.backgroundColor = [UIColor clearColor];
            self.lblRwMoneys.textColor = [UIColor redColor];
            [cell addSubview:self.lblRwMoneys];
            return cell;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == topTableView)
    {
        return 56;
    }
    if(tableView == self.uiTableView)
    {
        if(indexPath.section == 0){
            return 50;
        }
        if(indexPath.section == 1){
            return 80;
        }
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.uiTableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)loadTaskComplete
{
    NSString *date = @"";
    NSLog(@"currentDate %@",self.currentDate);
    if([self.currentDate length] == 0){
        date = [super getNowDate];
    }
    else{
        date = self.currentDate;
    }
    
    NSString *year = [super getCurrentYear: date];
    NSString *month = [super getCurrentMonth: date];
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name, @"user_name",self.userLogin.password, @"password", month, @"month_start", month, @"month_end", year, @"year", @"getKonkaR3OrderRankToJsonForFgs", @"method", nil];
    
    NSLog(@"username %@",self.userLogin.user_name);
    NSLog(@"userpass %@",self.userLogin.password);
    
    NSLog(@"%@,,,,,",[HYAppUtily stringOutputForDictionary:param]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:TaskCompleteApi]];
    
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
    [self.taskCompleteList removeAllObjects];
    for (NSDictionary *dic in [json objectForKey:@"list"]) {
        [self.taskCompleteList addObject:dic];
    }
    
    [self.taskComplete setValue:[json objectForKey:@"total_price"] forKey:@"total_price"];
    [self.taskComplete setValue:[json objectForKey:@"total_num"] forKey:@"total_num"];
    [self.taskComplete setValue:[json objectForKey:@"rw_sale"] forKey:@"rw_sale"];
    [self.taskComplete setValue:[json objectForKey:@"sell_money"] forKey:@"sell_money"];
    [self.taskComplete setValue:[json objectForKey:@"sell_num"] forKey:@"sell_num"];
    [self.taskComplete setValue:[json objectForKey:@"rw_money"] forKey:@"rw_money"];
    
    UIView *tempView = [[UIView alloc] init];
    [self.uiTableView setBackgroundView:tempView];
    [self.uiTableView reloadData];
    [SVProgressHUD dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == topTableView)
    {
        return 1;
    }
    else
    {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return [self.taskCompleteList count];
                break;
        }
    }
    return 0;
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
    currentDate = [super getUpMonthDate:self.dateLabel.text];
    self.dateLabel.text = [super getUpMonthDate:self.dateLabel.text];
    [self loadTaskComplete];
}

-(IBAction)downMoth:(id)sender
{
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = [super getDownMonthDate:self.dateLabel.text];
    self.dateLabel.text = [super getDownMonthDate:self.dateLabel.text];
    [self loadTaskComplete];
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
    self.dateLabel.text = backStr;
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = backStr;
//    [self getHisDataByStartTime:[super getFirstDayFromMoth:currentDate] endTime:[super getLastDayFromMoth:currentDate]];
    NSLog(@"currentDate ,%@" , currentDate);
    [calendar removeFromSuperview];
}

@end
