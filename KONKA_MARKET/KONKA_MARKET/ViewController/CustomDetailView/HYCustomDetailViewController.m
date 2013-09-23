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
@synthesize txtR3Code;
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
    self.customDetailList = [[NSMutableArray alloc] init];
    self.uiTableView.scrollEnabled = YES;
    self.uiTableView.delegate = self;
    self.uiTableView.dataSource = self;
    self.uiTableViewSearch.dataSource = self;
    self.uiTableViewSearch.delegate = self;
    self.mykey = [NSArray arrayWithObjects:@"查询", @"客户名称：", @"R3编码：", @"业务员：", @"", nil];
    
    UIView *tempView = [[UIView alloc] init];
    [self.uiTableView setBackgroundView:tempView];
    
    UIView *tempView1 = [[UIView alloc] init];
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
    if (tableView == self.uiTableView) {
        UITableViewCell *cell = nil;
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYCustomManageDetailTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        NSDictionary *dic = [self.customDetailList objectAtIndex:indexPath.row];
        self.lblCustomerName.text  = [dic objectForKey:@"r3_name"];
        self.lblR3Code.text = [dic objectForKey:@"r3_code"];
        self.lblCustomerType.text  = [dic objectForKey:@"c_name"];
        self.lblDeptName.text  = [dic objectForKey:@"dept_name"];
        self.lblLegalName.text  = [dic objectForKey:@"host_name"];
        self.lblLinkManName.text  = [dic objectForKey:@"link_man_name"];
        self.lblLinkManAddr.text  = [dic objectForKey:@"link_man_addr"];
        self.lblLinkManMobile.text  = [dic objectForKey:@"link_man_mobile"];
        self.lblLinkManPost.text  = [dic objectForKey:@"link_man_post"];
        self.lblLinkManTel.text  = [dic objectForKey:@"link_man_tel"];
        self.lblywyName.text  = [dic objectForKey:@"ywy_name"];
        
        return cell;
    }
    if (tableView == self.uiTableViewSearch) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UIImage *image = nil;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [self.mykey objectAtIndex: 0];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                break;
            case 1:
                image = [UIImage imageNamed:@"sys_icon_key.png"];
                cell.imageView.image = image;
                
                cell.textLabel.text = [self.mykey objectAtIndex: 1];
                self.txtCustomName = [[UITextField alloc] initWithFrame:CGRectMake(130, 1, 150, 24)];
                [self.txtCustomName setBorderStyle:UITextBorderStyleLine];
                self.txtCustomName.text = self.customer_name;
                [cell addSubview:self.txtCustomName];
                break;
            case 2:
                image = [UIImage imageNamed:@"sys_icon_key.png"];
                cell.imageView.image = image;
                
                cell.textLabel.text = [self.mykey objectAtIndex: 2];
                self.txtR3Code = [[UITextField alloc] initWithFrame:CGRectMake(130, 1, 150, 24)];
                [self.txtR3Code setBorderStyle:UITextBorderStyleLine];
                self.txtR3Code.text = self.r3_code;
                [cell addSubview:self.txtR3Code];
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
        return 170;
    }
    if(tableView == self.uiTableViewSearch)
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
    [self.uiTableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)loadCustomR3
{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name, @"username",self.userLogin.password, @"userpass",self.customer_name,@"customer_name",self.r3_code,
                           @"r3_code",self.txtYwyName.text,@"ywy_user_name", nil];
//    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name, @"username",self.userLogin.password, @"userpass", nil];
    
    NSLog(@"username %@",self.userLogin.user_name);
    NSLog(@"userpass %@",self.userLogin.password);
    
    NSLog(@"%@,,,,,",[HYAppUtily stringOutputForDictionary:param]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:CustomManageDetailApi]];
    
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
    [self.customDetailList removeAllObjects];
    for (NSDictionary *dic in json) {
        [self.customDetailList addObject:dic];
    }
    [self.uiTableView reloadData];
    [SVProgressHUD dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.uiTableView){
        return [self.customDetailList count];
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
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name, @"username",self.userLogin.password, @"userpass",self.txtCustomName.text,@"customer_name",self.txtR3Code.text,
                           @"r3_code",self.txtYwyName.text,@"ywy_user_name", nil];
    
    NSLog(@"username %@",self.userLogin.user_name);
    NSLog(@"userpass %@",self.userLogin.password);
    
    NSLog(@"%@,,,,,",[HYAppUtily stringOutputForDictionary:param]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:CustomManageDetailApi]];
    
    NSLog(@"url %@", url.absoluteString);
    [[[DataProcessing alloc] init] sentRequest:url Parem:param Target:self];

}

@end
