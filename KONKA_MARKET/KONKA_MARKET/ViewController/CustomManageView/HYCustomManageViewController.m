//
//  HYCustomManageViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-8-16.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYCustomManageViewController.h"
#import "HYCustomDetailViewController.h"

@interface HYCustomManageViewController ()
//@property(nonatomic, strong) JSONDecoder* decoder;
@end

@implementation HYCustomManageViewController
//@synthesize decoder;
@synthesize lblR3Name;
@synthesize lblR3Code;
@synthesize lblDeptName;
@synthesize lblYwyName;
@synthesize lblType;

@synthesize lblHostName;
@synthesize lblLinkManAddr;
@synthesize lblLinkManPost;
@synthesize lblLinkManMobile;
@synthesize lblLinkManName;
@synthesize lbllinkManTel;

@synthesize userlogin;
@synthesize customList;

@synthesize txtMonth;
@synthesize txtCustomName;
@synthesize txtR3Code;
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
    [self loadCustom];
    UIView *tempView = [[UIView alloc] init];
    [self.uiTableView setBackgroundView:tempView];
    
    self.customList = [[NSMutableArray alloc] init];
    self.uiTableView.delegate = self;
    self.uiTableView.dataSource = self;
    self.mykey = [NSArray arrayWithObjects:@"查询", @"查询月份：", @"客户名称：", @"R3编码：", @"业务员：", @"", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 2;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if(tableView == self.uiTableView){
        if (indexPath.section == 1)
        {
            static NSString *SectionTableMyTag=@"CellCustomManageIdentifier";
            cell=[tableView dequeueReusableCellWithIdentifier:SectionTableMyTag];
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SectionTableMyTag];
            NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYCustomManageTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            NSDictionary *dic = [self.customList objectAtIndex:indexPath.row];
            NSLog(@"[dic objectForKey:@c_name] = %@",[dic objectForKey:@"c_name"]);
            lblR3Name.text = [dic objectForKey:@"r3_name"];
            lblDeptName.text = [dic objectForKey:@"dept_name"];
            lblR3Code.text = [dic objectForKey:@"r3_code"];
            lblType.text = [dic objectForKey:@"c_name"];
            lblYwyName.text = [dic objectForKey:@"ywy_name"];
            lblHostName.text = [dic objectForKey:@"host_name"];
            lblLinkManAddr.text = [dic objectForKey:@"link_man_addr"];
            lblLinkManPost.text = [dic objectForKey:@"link_man_post"];
            //lblLinkManMobile.text = [dic objectForKey:@"link_man_mobile"];
            lblLinkManName.text = [dic objectForKey:@"link_man_name"];
            //lbllinkManTel.text = [dic objectForKey:@"link_man_tel"];
            return cell;
        }
        if (indexPath.section == 0)
        {
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
                    self.txtR3Code = [[UITextField alloc] initWithFrame:CGRectMake(100, 1, 150, 24)];
                    [self.txtR3Code setBorderStyle:UITextBorderStyleLine];
                    [cell addSubview:self.txtR3Code];
                    break;
                case 4:
                    cell.textLabel.text = [self.mykey objectAtIndex: 4];
                    self.txtYwyName = [[UITextField alloc] initWithFrame:CGRectMake(100, 1, 150, 24)];
                    [self.txtYwyName setBorderStyle:UITextBorderStyleLine];
                    [cell addSubview:self.txtYwyName];
                    break;
                case 5:
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
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //indexPath.row
    if (indexPath.section == 1)
    {
        return 170;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//        NSDictionary *dic = [self.userLogin.salesRegisterList objectAtIndex:indexPath.row];
        //NSLog(@"1111 %@", [dic objectForKey:@"memo"]);
        HYCustomDetailViewController *dataSubmit = [[HYCustomDetailViewController alloc]init];
        dataSubmit.userLogin = self.userLogin;
        dataSubmit.title = @"R3客户详细信息";
        
        [self.navigationController pushViewController:dataSubmit animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)loadCustom
{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name, @"username",self.userLogin.password, @"userpass", nil];
    
    NSLog(@"username %@",self.userLogin.user_name);
    NSLog(@"userpass %@",self.userLogin.password);
    
    NSLog(@"%@,,,,,",[HYAppUtily stringOutputForDictionary:param]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:CustomManageApi]];
    
    NSLog(@"url %@", url.absoluteString);
    [[[DataProcessing alloc] init] sentRequest:url Parem:param Target:self];
}

-(void)endRequest:(NSString *)msg
{
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *json = [decoder objectWithData:data];
    NSLog(@"json count %d",json.count);
    if ( [json count] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"数据获取失败"];
        return;
    }
    [self.customList removeAllObjects];
    for (NSDictionary *dic in json) {
        [self.customList addObject:dic];
    }
    [self.uiTableView reloadData];
    [SVProgressHUD dismiss];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 6;
            break;
        case 1:
            return [self.customList count];
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

//查询
-(void)Search:(id)sender
{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:self.userLogin.user_name, @"username",self.userLogin.password, @"userpass", nil];
    
    NSLog(@"username %@",self.userLogin.user_name);
    NSLog(@"userpass %@",self.userLogin.password);
    
    NSLog(@"%@,,,,,",[HYAppUtily stringOutputForDictionary:param]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:CustomManageApi]];
    
    NSLog(@"url %@", url.absoluteString);
    [[[DataProcessing alloc] init] sentRequest:url Parem:param Target:self];

    //NSLog(@"点击查询按钮才会出现的");
}


@end
