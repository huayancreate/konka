//
//  HYDecisionRetailViewController.m
//  KONKA_MARKET
//
//  Created by andychen on 13-9-22.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYDecisionRetailViewController.h"
#import "HYDecisionCompleteViewController.h"
#import "HYDecisionManagerViewController.h"
#import "HYDecisionSalesViewController.h"

@interface HYDecisionRetailViewController ()

@end

@implementation HYDecisionRetailViewController
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
    [[super someButton] addTarget:self action:@selector(backButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
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
            cell = [self createTabelViewCellForIndentifier:@"RetailsIdentifier" NibNamed:@"HYDecisionRetailTableViewCell" tableView:tableView index:0];
            return cell;
            break;
        case 1:
            cell = [self createTabelViewCellForIndentifier:@"RetailsIdentifier" NibNamed:@"HYDecisionRetailTableViewCell" tableView:tableView index:1];
            return cell;
            break;
        case 2:
            cell = [self createTabelViewCellForIndentifier:@"RetailsIdentifier" NibNamed:@"HYDecisionRetailTableViewCell" tableView:tableView index:2];
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
    
    HYDecisionCompleteViewController *completeSubmit = nil;
    HYDecisionManagerViewController *managerSubmit = nil;
    HYDecisionSalesViewController *salesSubmit = nil;
    switch (indexPath.row) {
        case 0:
            completeSubmit = [[HYDecisionCompleteViewController alloc] init];
            completeSubmit.userLogin = self.userLogin;
            completeSubmit.title = @"任务完成情况";
            [self.navigationController pushViewController:completeSubmit animated:YES];
            break;
        case 1:
            salesSubmit = [[HYDecisionSalesViewController alloc] init];
            salesSubmit.userLogin = self.userLogin;
            salesSubmit.title = @"零售畅销型号";
            [self.navigationController pushViewController:salesSubmit animated:YES];
            break;
        case 2:
            managerSubmit = [[HYDecisionManagerViewController alloc] init];
            managerSubmit.userLogin = self.userLogin;
            managerSubmit.title = @"任务完成情况-经办";
            [self.navigationController pushViewController:managerSubmit animated:YES];
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
