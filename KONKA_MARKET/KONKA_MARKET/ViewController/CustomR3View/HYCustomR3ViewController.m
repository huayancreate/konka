//
//  HYCustomR3ViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-8-20.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYCustomR3ViewController.h"

@interface HYCustomR3ViewController ()
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;

@end

@implementation HYCustomR3ViewController
@synthesize lblAvgMlMoney;
@synthesize lblAvgUnitPrice;
@synthesize lblR3TotalCount;
@synthesize lblR3TotalMoney;
@synthesize lblTbMlMoney;
@synthesize lblTbUnitPrice;
@synthesize lblCustomName;

@synthesize userLogin;
@synthesize customR3List;

@synthesize btnMonth;
@synthesize txtCustomName;
@synthesize txtYwyName;
@synthesize btnSearch;

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
    self.customR3List = [[NSMutableArray alloc] init];
    self.uiTableView.scrollEnabled = YES;
    self.uiTableView.delegate = self;
    self.uiTableView.dataSource = self;
    self.uiTableViewSearch.delegate = self;
    self.uiTableViewSearch.dataSource = self;
    self.mykey = [NSArray arrayWithObjects:@"查询", @"查询月份：", @"客户名称：", @"业务员：", @"", nil];
    
    
    UIView *tempView = [[UIView alloc] init];
    [self.uiTableView setBackgroundView:tempView];
    
    UIView *tempView1 = [[UIView alloc]init];
    [self.uiTableViewSearch setBackgroundView:tempView1];

    [self loadCustomR3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if(tableView == self.uiTableView){
        UITableViewCell *cell = nil;
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYCustomR3TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        NSDictionary *dic = [self.customR3List objectAtIndex:indexPath.row];
        lblR3TotalMoney.text = [dic objectForKey:@"pd_total_money"];
        lblCustomName.text = [dic objectForKey:@"customer_name"];
        lblR3TotalCount.text = [dic objectForKey:@"pd_count"];
        lblAvgMlMoney.text = [dic objectForKey:@"pj_ml_money"];
        lblAvgUnitPrice.text = [dic objectForKey:@"pj_unitprice"];
        lblTbMlMoney.text = [dic objectForKey:@"tb_ml_money"];
        lblTbUnitPrice.text = [dic objectForKey:@"tb_unitprice"];
        
        return cell;    
    }
    if(tableView == self.uiTableViewSearch){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UIImage *image = nil;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [self.mykey objectAtIndex: 0];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                break;
            case 1:
                image = [UIImage imageNamed:@"sys_ico_date.png"];
                cell.imageView.image = image;
                
                cell.textLabel.text = [self.mykey objectAtIndex: 1];
                self.btnMonth = [[UIButton alloc] initWithFrame:CGRectMake(120, 1, 150, 24)];
                [self.btnMonth setTitle:[super getNowDate] forState:UIControlStateNormal];
                [self.btnMonth addTarget:self action:@selector(dataPick:) forControlEvents:UIControlEventTouchUpInside];
                [self.btnMonth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cell addSubview:self.btnMonth];
                break;
            case 2:
                image = [UIImage imageNamed:@"sys_icon_key.png"];
                cell.imageView.image = image;
                
                cell.textLabel.text = [self.mykey objectAtIndex: 2];
                self.txtCustomName = [[UITextField alloc] initWithFrame:CGRectMake(130, 1, 150, 24)];
                [self.txtCustomName setBorderStyle:UITextBorderStyleLine];
                [cell addSubview:self.txtCustomName];
                break;
            case 3:
                image = [UIImage imageNamed:@"sys_icon_user.png"];
                cell.imageView.image = image;
                
                cell.textLabel.text = [self.mykey objectAtIndex: 3];
                self.txtYwyName = [[UITextField alloc] initWithFrame:CGRectMake(130, 1, 150, 24)];
                [self.txtYwyName setBorderStyle:UITextBorderStyleLine];
                [cell addSubview:self.txtYwyName];
                break;
            case 4:
                self.btnSearch = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                btnSearch.frame = CGRectMake(35, 1, 250, 24);
                [btnSearch setBackgroundImage:[UIImage imageNamed:@"sales_reg_foot"] forState:UIControlStateNormal];
                //btnSearch.tag = 1234;
                [btnSearch setTitle:@"查询" forState:UIControlStateNormal];
                [btnSearch addTarget:self action:@selector(Search:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:self.btnSearch];
                break;
                
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.uiTableView){
        return 120;
    }
    if(tableView == self.uiTableViewSearch){
        if(indexPath.row == 0){
            return 35;
        }else{
            return 28;
        }
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.uiTableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)loadCustomR3
{
    NSString *date= [super getNowDate];
    NSString *year = [super getCurrentYear: date];
    NSString *month = [super getCurrentMonth: date];
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name, @"user_name",self.userLogin.password, @"password", month, @"month", year, @"year", @"getR3MarginListToJson", @"method", nil];
    
    NSLog(@"username %@",self.userLogin.user_name);
    NSLog(@"userpass %@",self.userLogin.password);
    
    NSLog(@"%@,,,,,",[HYAppUtily stringOutputForDictionary:param]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:CustomR3Api]];
    
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
    [self.customR3List removeAllObjects];
    for (NSDictionary *dic in [json objectForKey:@"list"]) {
        [self.customR3List addObject:dic];
    }
    UIView *tempView = [[UIView alloc] init];
    [self.uiTableView setBackgroundView:tempView];
    [self.uiTableView reloadData];
    [SVProgressHUD dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.uiTableView){
        return [self.customR3List count];
    }
    if(tableView == self.uiTableViewSearch){
        return 5;
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

-(IBAction)Search:(id)sender
{
    NSString *year = [super getCurrentYear: self.btnMonth.titleLabel.text];
    NSString *month = [super getCurrentMonth: self.btnMonth.titleLabel.text];
    NSString *customer_name = self.txtCustomName.text;
    NSString *ywy_user_name = self.txtYwyName.text;
    if([customer_name length] == 0){
        customer_name = @"";
    }
    if([ywy_user_name length] == 0){
        ywy_user_name = @"";
    }
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name, @"user_name",self.userLogin.password, @"password", month, @"month", year, @"year", @"getR3MarginListToJson", @"method", customer_name,@"customer_name",ywy_user_name,@"ywy_user_name", nil];
    
    NSLog(@"username %@",self.userLogin.user_name);
    NSLog(@"userpass %@",self.userLogin.password);
    NSLog(@"customer_name %@",customer_name);
    NSLog(@"ywy_user_name %@",ywy_user_name);
    
    NSLog(@"%@,,,,,",[HYAppUtily stringOutputForDictionary:param]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:CustomR3Api]];
    
    NSLog(@"url %@", url.absoluteString);
    [[[DataProcessing alloc] init] sentRequest:url Parem:param Target:self];
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
    //NSLog(@"点击日期事件");
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    NSString *backStr = [[NSString alloc] initWithFormat:[self.dateFormatter stringFromDate:date]];
    [self.btnMonth setTitle:backStr forState:UIControlStateNormal];
    [calendar removeFromSuperview];
}

@end
