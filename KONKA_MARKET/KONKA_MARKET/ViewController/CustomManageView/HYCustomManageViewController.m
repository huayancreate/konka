//
//  HYCustomManageViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-8-16.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYCustomManageViewController.h"

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
    self.customList = [[NSMutableArray alloc] init];
    self.uiTableView.delegate = self;
    self.uiTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return [self.customList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SectionTableMyTag=@"CellCustomManageIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:SectionTableMyTag];
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
    lblLinkManMobile.text = [dic objectForKey:@"link_man_mobile"];
    lblLinkManName.text = [dic objectForKey:@"link_man_name"];
    lbllinkManTel.text = [dic objectForKey:@"link_man_tel"];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 170;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (tableView == downTableView){
//        NSDictionary *dic = [self.userLogin.salesRegisterList objectAtIndex:indexPath.row];
//        NSLog(@"1111 %@", [dic objectForKey:@"memo"]);
//        if ([self.status isEqualToString:@"0"])
//        {
//            self.userLogin.allDataSubmit = nil;
//            self.userLogin.dataSubmit = dic;
//        }else
//        {
//            self.userLogin.dataSubmit = nil;
//            self.userLogin.allDataSubmit = dic;
//        }
//        HYDataSubmitViewController *dataSubmit = [[HYDataSubmitViewController alloc]init];
//        dataSubmit.userLogin = self.userLogin;
//        dataSubmit.title = @"销售登记";
//        
//        [self.navigationController pushViewController:dataSubmit animated:YES];
//        [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    }
    
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
//    NSString *msg1=@"[{\"c_name\":\"其它1\",\"dept_name\":\"内江\",\"map\":{},\"r3_code\":\"F1621XYGHB\",\"r3_name\":\"叙永县光宏电器有限公司(白电）\",\"row\":{},\"ywy_name\":\"\"},{\"c_name\":\"乡镇客户\",\"dept_name\":\"成都\",\"map\":{},\"r3_code\":\"F1053L26BD\",\"r3_name\":\"乐山市金口河区金拓家电白电\",\"row\":{},\"ywy_name\":\"\"}]";
//    NSLog(@"mgs %@",msg1);
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
    return [self.customList count];
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
