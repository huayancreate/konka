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
@synthesize uiCellLabelModelName;
@synthesize uiCellLabelNum;
@synthesize uiCellLabelPrice;
@synthesize uiCellLabelStoreName;
@synthesize uiCellLabelTime;
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
    self.customList = [[NSMutableArray alloc] init];
    self.uiTableView.delegate = self;
    self.uiTableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
    [self loadCustom];
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
    uiCellLabelStoreName.text = [dic objectForKey:@"c_name"];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    uiCellLabelNum.text = [numberFormatter stringFromNumber:[dic objectForKey:@"dept_name"]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSize:0];
    uiCellLabelPrice.text = [numberFormatter stringFromNumber:[dic objectForKey:@"r3_code"]];
    uiCellLabelTime.text = [dic objectForKey:@"r3_name"];
    uiCellLabelModelName.text = [dic objectForKey:@""];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 70;
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
    NSString *msg1=@"[{\"c_name\":\"其它1\",\"dept_name\":\"内江\",\"map\":{},\"r3_code\":\"F1621XYGHB\",\"r3_name\":\"叙永县光宏电器有限公司(白电）\",\"row\":{},\"ywy_name\":\"\"},{\"c_name\":\"乡镇客户\",\"dept_name\":\"成都\",\"map\":{},\"r3_code\":\"F1053L26BD\",\"r3_name\":\"乐山市金口河区金拓家电白电\",\"row\":{},\"ywy_name\":\"\"}]";
    NSLog(@"mgs %@",msg1);
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [msg1 dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *json = [decoder objectWithData:data];
    NSLog(@"json count %d",json.count);
    if ( [json count] == 0)
    {
        return;
    }
    [self.customList removeAllObjects];
    [self.customList addObject:[json objectAtIndex:0]];
    [self.uiTableView reloadData];
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

@end
