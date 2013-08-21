//
//  HYCustomR3ViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-8-20.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYCustomR3ViewController.h"

@interface HYCustomR3ViewController ()

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

@synthesize txtMonth;
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
    // Do any additional setup after loading the view from its nib.
    self.customR3List = [[NSMutableArray alloc] init];
    self.uiTableView.scrollEnabled = YES;
    self.uiTableView.delegate = self;
    self.uiTableView.dataSource = self;
    self.mykey = [NSArray arrayWithObjects:@"查询", @"查询月份：", @"客户名称：", @"业务员：", @"", nil];
    
    UIView *tempView = [[UIView alloc] init];
    [self.uiTableView setBackgroundView:tempView];

    [self loadCustomR3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 2;
    //return [self.customR3List count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 1) {
        static NSString *SectionTableMyTag=@"CellCustomR3Identifier";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:SectionTableMyTag];
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SectionTableMyTag];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYCustomR3TableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        NSDictionary *dic = [self.customR3List objectAtIndex:indexPath.row];
        //NSLog(@"[dic objectForKey:@c_name] = %@",[dic objectForKey:@"c_name"]);
        lblR3TotalMoney.text = [dic objectForKey:@"pd_total_money"];
        lblCustomName.text = [dic objectForKey:@"customer_name"];
        lblR3TotalCount.text = [dic objectForKey:@"pd_count"];
        lblAvgMlMoney.text = [dic objectForKey:@"pj_ml_money"];
        lblAvgUnitPrice.text = [dic objectForKey:@"pj_unitprice"];
        lblTbMlMoney.text = [dic objectForKey:@"tb_ml_money"];
        lblTbUnitPrice.text = [dic objectForKey:@"tb_unitprice"];
        
        return cell;    
    }
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [self.mykey objectAtIndex: 0];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                break;
            case 1:
                cell.textLabel.text = [self.mykey objectAtIndex: 1];
                self.txtMonth = [[UITextField alloc] initWithFrame:CGRectMake(100, 1, 150, 24)];
                [self.txtMonth setBorderStyle:UITextBorderStyleLine];
                [cell addSubview:self.txtMonth];
                break;
            case 2:
                cell.textLabel.text = [self.mykey objectAtIndex: 2];
                self.txtCustomName = [[UITextField alloc] initWithFrame:CGRectMake(100, 1, 150, 24)];
                [self.txtCustomName setBorderStyle:UITextBorderStyleLine];
                [cell addSubview:self.txtCustomName];
                break;
            case 3:
                cell.textLabel.text = [self.mykey objectAtIndex: 3];
                self.txtYwyName = [[UITextField alloc] initWithFrame:CGRectMake(100, 1, 150, 24)];
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
    if (indexPath.section == 1)
    {
        return 100;
    }
    if(indexPath.section == 0)
    {
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
    
}

-(void)loadCustomR3
{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name, @"user_name",self.userLogin.password, @"password", @"8", @"month", @"2012", @"year", @"getR3MarginListToJson", @"method", nil];
    
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
    //for (NSDictionary *dic in json) {
    [self.customR3List addObject:[json objectForKey:@"list"]];
    //}
    UIView *tempView = [[UIView alloc] init];
    [self.uiTableView setBackgroundView:tempView];
    [self.uiTableView reloadData];
    [SVProgressHUD dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return [self.customR3List count];
            break;
    }
}

-(void) endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    [super errorMsg:msg];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}


@end
