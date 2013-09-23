//
//  HYDecisionManagerViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-9-23.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYDecisionManagerViewController.h"

@interface HYDecisionManagerViewController ()
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@property(nonatomic, strong) NSString *currentDate;

@end

@implementation HYDecisionManagerViewController
@synthesize topTableView;
@synthesize dateBtn;
@synthesize tableViewCell;
@synthesize currentDate;
@synthesize dateLabel;
@synthesize displayTableView;
@synthesize totalTableView;

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
    displayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, 320, [super screenHeight]-140) style:UITableViewStyleGrouped];
    displayTableView.scrollEnabled = YES;
    displayTableView.delegate = self;
    displayTableView.dataSource = self;
    [displayTableView setBackgroundView:tempView];
    [self.view addSubview:displayTableView];
    
    UIView *tempView2 = [[UIView alloc] init];
    totalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45, 320, 140) style:UITableViewStyleGrouped];
    totalTableView.scrollEnabled = NO;
    totalTableView.delegate = self;
    totalTableView.dataSource = self;
    [totalTableView setBackgroundView:tempView2];
    [self.view addSubview:totalTableView];
    
    [self loadTaskManager];
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
    UIColor *progressColor = [UIColor colorWithRed:255/255.0 green:130/255.0 blue:5/255.0 alpha:1];
    UIColor *trackColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    UIColor *saleColor = [UIColor colorWithRed:173/255.0 green:53/255.0 blue:53/255.0 alpha:1];
    
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
    if(tableView == self.displayTableView)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYDecisionManagerTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        NSDictionary *dic = [self.taskCompleteList objectAtIndex:indexPath.row];
        self.lblDeptName.text =[[[dic objectForKey:@"l4_dept_name"] stringByAppendingString:@"-"] stringByAppendingString:[dic objectForKey:@"dept_name"]];
        self.lblSale.text = [[dic objectForKey:@"sale"] stringByAppendingString:@"%"];
        self.lblSale.textColor = saleColor;
        float sale = [[dic objectForKey:@"sale"] floatValue];
        self.progressView.progress = sale/100;
        self.progressView.progressTintColor = progressColor;
        self.progressView.trackTintColor = trackColor;
        float allPrice = [[dic objectForKey:@"all_price"] floatValue];
        float rwMoney = [[dic objectForKey:@"rw_money"] floatValue];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"###,##0.00;"];
        NSString *formatAllPrice = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:allPrice]];
        NSString *formatRwMoney = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:rwMoney]];
        self.lblAllPrice.text = formatAllPrice;
        self.lblRwMoney.text = formatRwMoney;
        UIImage *image = nil;
        if(indexPath.row <3){
            switch (indexPath.row) {
                case 0:
                    image = [UIImage imageNamed:@"top1.jpg"];
                    break;
                case 1:
                    image = [UIImage imageNamed:@"top2.jpg"];
                    break;
                case 2:
                    image = [UIImage imageNamed:@"top3.jpg"];
                    break;
            }
            self.lblOrder.text = @"";
            cell.imageView.image = image;
        }else{
            NSString *stringInt = [NSString stringWithFormat:@"%d",indexPath.row+1];
            self.lblOrder.text = stringInt;
        }
        return cell;
    }
    if(tableView == totalTableView){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        NSMutableDictionary *dic1 = self.taskComplete;
        float sale = [[dic1 objectForKey:@"rw_sale"] floatValue];
        
        float allPrice = [[dic1 objectForKey:@"total_price"] floatValue];
        float rwMoney = [[dic1 objectForKey:@"rw_money"] floatValue];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"###,##0.00;"];
        NSString *formatAllPrice = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:allPrice]];
        NSString *formatRwMoney = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:rwMoney]];
        
        self.uiProgressView =[[UIProgressView alloc] initWithFrame:CGRectMake(13, 5, 295, 9)];
        self.uiProgressView.progress = sale/100;
        self.uiProgressView.progressTintColor = progressColor;
        self.uiProgressView.trackTintColor = trackColor;
        [cell addSubview:self.uiProgressView];
        
        self.lblSalesMsg =[[UILabel alloc] initWithFrame:CGRectMake(13, 15, 100, 21)];
        self.lblSalesMsg.text = @"总进度:";
        self.lblSalesMsg.backgroundColor = [UIColor clearColor];
        self.lblSalesMsg.font = [UIFont fontWithName:@"Helvetica" size:12];
        [cell addSubview:self.lblSalesMsg];
        
        self.lblSales =[[UILabel alloc] initWithFrame:CGRectMake(260, 15, 60, 21)];
        self.lblSales.text = [[dic1 objectForKey:@"rw_sale"]
                              stringByAppendingString:@"%"];
        self.lblSales.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.lblSales.backgroundColor = [UIColor clearColor];
        self.lblSales.textColor = saleColor;
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
        
        self.lblRwMoneys =[[UILabel alloc] initWithFrame:CGRectMake(245, 30, 120, 21)];
        self.lblRwMoneys.text = formatRwMoney;
        self.lblRwMoneys.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.lblRwMoneys.backgroundColor = [UIColor clearColor];
        self.lblRwMoneys.textColor = [UIColor redColor];
        [cell addSubview:self.lblRwMoneys];
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
    if(tableView == self.displayTableView)
    {
        return 80;
    }
    if(tableView == totalTableView)
    {
        return 50;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)loadTaskManager
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
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name, @"user_name",self.userLogin.password, @"password", month, @"month_start", month, @"month_end", year, @"year", @"getKonkaR3OrderRankToJsonForJb", @"method", nil];
    
    NSLog(@"username %@",self.userLogin.user_name);
    NSLog(@"userpass %@",self.userLogin.password);
    
    NSLog(@"%@,,,,,",[HYAppUtily stringOutputForDictionary:param]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:TaskManagerApi]];
    
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
    [self.displayTableView setBackgroundView:tempView];
    [self.displayTableView reloadData];
    [self.totalTableView reloadData];
    [SVProgressHUD dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == topTableView || tableView == totalTableView)
    {
        return 1;
    }
    else
    {
        return [self.taskCompleteList count];
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
    [self loadTaskManager];
}

-(IBAction)downMoth:(id)sender
{
    
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    currentDate = [super getDownMonthDate:self.dateLabel.text];
    self.dateLabel.text = [super getDownMonthDate:self.dateLabel.text];
    [self loadTaskManager];
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
