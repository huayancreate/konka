//
//  HYCustomDetailViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-8-21.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYCustomDetailViewController.h"

@interface HYCustomDetailViewController ()

@end

@implementation HYCustomDetailViewController

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
    UIView *tempView = [[UIView alloc] init];
    [self.uiTableView setBackgroundView:tempView];
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
//    static NSString *SectionTableMyTag=@"CellCustomR3Identifier";
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:SectionTableMyTag];
//    cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SectionTableMyTag];
//    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYCustomR3TableViewCell" owner:self options:nil];
//    cell = [nib objectAtIndex:0];
//    //        NSDictionary *dic = [self.customR3List objectAtIndex:indexPath.row];
//    //        //NSLog(@"[dic objectForKey:@c_name] = %@",[dic objectForKey:@"c_name"]);
//    //        lblR3TotalMoney.text = [dic objectForKey:@"pd_total_money"];
//    //        lblCustomName.text = [dic objectForKey:@"customer_name"];
//    //        lblR3TotalCount.text = [dic objectForKey:@"pd_count"];
//    //        lblAvgMlMoney.text = [dic objectForKey:@"pj_ml_money"];
//    //        lblAvgUnitPrice.text = [dic objectForKey:@"pj_unitprice"];
//    //        lblTbMlMoney.text = [dic objectForKey:@"tb_ml_money"];
//    //        lblTbUnitPrice.text = [dic objectForKey:@"tb_unitprice"];
//    
//    return cell;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
//    [self.customR3List removeAllObjects];
//    //for (NSDictionary *dic in json) {
//    [self.customR3List addObject:[json objectForKey:@"list"]];
//    //}
//    UIView *tempView = [[UIView alloc] init];
//    [self.uiTableView setBackgroundView:tempView];
//    [self.uiTableView reloadData];
//    [SVProgressHUD dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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