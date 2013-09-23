//
//  HYDecisionSalesViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-9-23.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYDecisionSalesViewController.h"

@interface HYDecisionSalesViewController ()
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@property(nonatomic, strong) NSString *currentDate;

@end

@implementation HYDecisionSalesViewController
@synthesize topTableView;
@synthesize dateBtn;
@synthesize tableViewCell;
@synthesize currentDate;
@synthesize dateLabel;
@synthesize uiTableView;

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
    self.modelList = [[NSMutableArray alloc] init];
    
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
    
    UIView *tempView = [[UIView alloc] init];
    uiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 320, [super screenHeight]-60) style:UITableViewStyleGrouped];
    uiTableView.scrollEnabled = YES;
    uiTableView.delegate = self;
    uiTableView.dataSource = self;
    [uiTableView setBackgroundView:tempView];
    [self.view addSubview:uiTableView];
    
    [self loadModel];
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
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYDecisionSalesTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        NSDictionary *dic = [self.modelList objectAtIndex:indexPath.row];
        self.lblModelName.text =[dic objectForKey:@"model_name"];
        self.lblAllPrice.text = [dic objectForKey:@"all_price"];
        self.lblAvgPrice.text= [dic objectForKey:@"price"];
        self.lblAllNum.text= [dic objectForKey:@"all_num"];
        NSString *stringInt = [NSString stringWithFormat:@"%d",indexPath.row+1];
        self.lblOrder.text = stringInt;
        self.lblOrder.textColor = [UIColor redColor];
        return cell;
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
        return 80;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)loadModel
{
    NSString *date = @"";
    NSLog(@"currentDate %@",self.currentDate);
    if([self.currentDate length] == 0){
        date = [super getNowDate];
    }
    else{
        date = self.currentDate;
    }
    NSString *firstDay = [super getFirstDayFromMoth:date];
    NSString *lastDay = [super getLastDayFromMoth:date];
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name, @"user_name",self.userLogin.password, @"password", firstDay, @"sell_date_start", lastDay, @"sell_date_end", @"1", @"tj_type", @"KonkaSellRankToJsonForModelNameForCx", @"method", nil];
    
    NSLog(@"username %@",self.userLogin.user_name);
    NSLog(@"userpass %@",self.userLogin.password);
    
    NSLog(@"%@,,,,,",[HYAppUtily stringOutputForDictionary:param]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:DecisionModelApi]];
    
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
    [self.modelList removeAllObjects];
    for (NSDictionary *dic in [json objectForKey:@"list"]) {
        [self.modelList addObject:dic];
    }
    
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
        return [self.modelList count];
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
    [self loadModel];
}

-(IBAction)downMoth:(id)sender
{
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = [super getDownMonthDate:self.dateLabel.text];
    self.dateLabel.text = [super getDownMonthDate:self.dateLabel.text];
    [self loadModel];
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


@end
