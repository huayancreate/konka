//
//  HYRetailViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-4.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYRetailViewController.h"
#import "HYDataSubmitViewController.h"
#import "HYSalesRegistrationViewController.h"
#import "HYCompetitionSalesViewController.h"
#import "HYSalesComputationViewController.h"
#import "HYPercentageCompetitionViewController.h"
#import "HYModelConfigViewController.h"

@interface HYRetailViewController ()

@end

@implementation HYRetailViewController
@synthesize mainTableView;

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
    
    
    UIImage *backButtonImage = [UIImage imageNamed:@"back.png"];
    CGRect frameimg = CGRectMake(0, 20, 20, 30);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    
    [someButton addTarget:self action:@selector(backButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.leftBarButtonItem  = leftButton;
    
    UIView *temp = [[UIView alloc] init];
    [mainTableView setBackgroundView:temp];

    
}

#pragma mark -
#pragma mark Table view data source

-(UITableViewCell *) createTabelViewCellForIndentifier: (NSString *) indentifier NibNamed: (NSString *) nibName tableView:(UITableView *)tableView index:(int) index{
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier: indentifier];
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:nibName owner:self options:nil];
    cell = [nib objectAtIndex:index];
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:
            cell = [self createTabelViewCellForIndentifier:@"RetailsIdentifier" NibNamed:@"HYRetailsTableViewCell" tableView:tableView index:0];
            return cell;
            break;
        case 1:
            cell = [self createTabelViewCellForIndentifier:@"RetailsIdentifier" NibNamed:@"HYRetailsTableViewCell" tableView:tableView index:1];
            return cell;
            break;
        case 2:
            cell = [self createTabelViewCellForIndentifier:@"RetailsIdentifier" NibNamed:@"HYRetailsTableViewCell" tableView:tableView index:2];
            return cell;
            break;
        case 3:
            cell = [self createTabelViewCellForIndentifier:@"RetailsIdentifier" NibNamed:@"HYRetailsTableViewCell" tableView:tableView index:3];
            return cell;
            break;
        case 4:
            cell = [self createTabelViewCellForIndentifier:@"RetailsIdentifier" NibNamed:@"HYRetailsTableViewCell" tableView:tableView index:4];
            return cell;
            break;
        case 5:
            cell = [self createTabelViewCellForIndentifier:@"RetailsIdentifier" NibNamed:@"HYRetailsTableViewCell" tableView:tableView index:5];
            return cell;
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HYDataSubmitViewController *dataSubmit = nil;
    HYSalesRegistrationViewController *salesSubmit = nil;
    HYCompetitionSalesViewController *csalesView = nil;
    HYSalesComputationViewController *salesComputationView = nil;
    HYPercentageCompetitionViewController *percentageView = nil;
    HYModelConfigViewController *modelConfigView = nil;
    switch (indexPath.row) {
        case 0:
            dataSubmit = [[HYDataSubmitViewController alloc]init];
            dataSubmit.userLogin = self.userLogin;
            self.userLogin.dataSubmit = nil;
            dataSubmit.title = @"数据上报";
            [self.navigationController pushViewController:dataSubmit animated:YES];
            break;
        case 1:
            
            salesSubmit = [[HYSalesRegistrationViewController alloc] init];
            salesSubmit.userLogin = self.userLogin;
            salesSubmit.title = @"上报历史";
            
            [self.navigationController pushViewController:salesSubmit animated:YES];

            break;
        case 2:
            csalesView = [[HYCompetitionSalesViewController alloc] init];
            csalesView.userLogin = self.userLogin;
            csalesView.title = @"竞品信息";
            
            [self.navigationController pushViewController:csalesView animated:YES];
            break;
        case 3:
            salesComputationView = [[HYSalesComputationViewController alloc] init];
            salesComputationView.userLogin = self.userLogin;
            salesComputationView.title = @"销售分析";
            
            [self.navigationController pushViewController:salesComputationView animated:YES];
            break;
        case 4:
            percentageView = [[HYPercentageCompetitionViewController alloc] init];
            percentageView.userLogin = self.userLogin;
            percentageView.title = @"提成预算";
            
            [self.navigationController pushViewController:percentageView animated:YES];
            break;
        case 5:
            modelConfigView = [[HYModelConfigViewController alloc] init];
            modelConfigView.userLogin = self.userLogin;
            modelConfigView.title = @"型号设定";
            
            [self.navigationController pushViewController:modelConfigView animated:YES];
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)backButtonAction:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]- 2] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}


@end
