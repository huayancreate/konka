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

- (IBAction)dataSubmit:(id)sender
{
    HYDataSubmitViewController *dataSubmit = [[HYDataSubmitViewController alloc]init];
    dataSubmit.userLogin = self.userLogin;
    dataSubmit.title = @"数据上报";
    
    [self.navigationController pushViewController:dataSubmit animated:YES];
}

- (IBAction)salesSubmit:(id)sender
{

    HYSalesRegistrationViewController *salesSubmit = [[HYSalesRegistrationViewController alloc] init];
    salesSubmit.userLogin = self.userLogin;
    salesSubmit.title = @"上报历史";
    
    [self.navigationController pushViewController:salesSubmit animated:YES];
}

- (IBAction)competitionsSales:(id)sender
{
    
    HYCompetitionSalesViewController *csalesView = [[HYCompetitionSalesViewController alloc] init];
    csalesView.userLogin = self.userLogin;
    csalesView.title = @"竞品信息";
    
    [self.navigationController pushViewController:csalesView animated:YES];
}

- (IBAction)salesComputations:(id)sender
{
    
    HYSalesComputationViewController *salesComputationView = [[HYSalesComputationViewController alloc] init];
    salesComputationView.userLogin = self.userLogin;
    salesComputationView.title = @"销售分析";
    
    [self.navigationController pushViewController:salesComputationView animated:YES];
}

- (IBAction)percentageAction:(id)sender
{
    
    HYPercentageCompetitionViewController *percentageView = [[HYPercentageCompetitionViewController alloc] init];
    percentageView.userLogin = self.userLogin;
    percentageView.title = @"提成预算";
    
    [self.navigationController pushViewController:percentageView animated:YES];
}

- (IBAction)modelConfigAction:(id)sender{
    HYModelConfigViewController *modelConfigView = [[HYModelConfigViewController alloc] init];
    modelConfigView.userLogin = self.userLogin;
    modelConfigView.title = @"型号设定";
    
    [self.navigationController pushViewController:modelConfigView animated:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}


@end
