//
//  HYCustomRetailViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-8-16.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYCustomRetailViewController.h"
#import "HYCustomManageViewController.h"

@interface HYCustomRetailViewController ()

@end

@implementation HYCustomRetailViewController
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
    UIView *temp = [[UIView alloc] init];
    [mainTableView setBackgroundView:temp];
    // Do any additional setup after loading the view from its nib.
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:
            cell = [self createTabelViewCellForIndentifier:@"RetailsIdentifier" NibNamed:@"HYCustomRetailTableViewCell" tableView:tableView index:0];
            return cell;
            break;
        case 1:
            cell = [self createTabelViewCellForIndentifier:@"RetailsIdentifier" NibNamed:@"HYCustomRetailTableViewCell" tableView:tableView index:1];
            return cell;
            break;
        case 2:
            cell = [self createTabelViewCellForIndentifier:@"RetailsIdentifier" NibNamed:@"HYCustomRetailTableViewCell" tableView:tableView index:2];
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
    
    HYCustomManageViewController *customMangeSubmit = nil;
//    HYOAViewController *oaSubmit = nil;
//    HYOAApprovalListViewController *oaListSubmit = nil;
//    HYOAIssuedListViewController *issuedSubmit = nil;
    switch (indexPath.row) {
        case 0:
            customMangeSubmit = [[HYCustomManageViewController alloc]init];
            customMangeSubmit.userLogin = self.userLogin;
            self.userLogin.dataSubmit = nil;
            customMangeSubmit.title = @"客户管理";
            [self.navigationController pushViewController:customMangeSubmit animated:YES];
            break;
        case 1:
            customMangeSubmit = [[HYCustomManageViewController alloc]init];
            customMangeSubmit.userLogin = self.userLogin;
            self.userLogin.dataSubmit = nil;
            customMangeSubmit.title = @"客户管理";
            [self.navigationController pushViewController:customMangeSubmit animated:YES];
            break;
        case 2:
//            issuedSubmit = [[HYOAIssuedListViewController alloc] init];
//            issuedSubmit.userLogin = self.userLogin;
//            issuedSubmit.title = @"下发文件查询";
//            
//            [self.navigationController pushViewController:issuedSubmit animated:YES];
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
