//
//  HYHomeViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-3.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYHomeViewController.h"
#import "HYRetailViewController.h"
#import "HYSystemConfigViewController.h"

@interface HYHomeViewController ()

@end

@implementation HYHomeViewController

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
    
    UIImage *setConfigImage = [UIImage imageNamed:@"btn_set_white.png"];
    CGRect frameimg = CGRectMake(0, 20, 30, 30);
    UIButton *configButton = [[UIButton alloc] initWithFrame:frameimg];
    [configButton setBackgroundImage:setConfigImage forState:UIControlStateNormal];
    
    [configButton addTarget:self action:@selector(selectRightAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [configButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:configButton];
    
    
    self.navigationItem.rightBarButtonItem  = rightButton;
    
    
    
    UIButton *logoView = [[UIButton alloc] initWithFrame:CGRectMake(0,0,45,35)];
    [logoView setBackgroundImage:[UIImage imageNamed:@"logo.png"] forState:UIControlStateNormal];
    [logoView setUserInteractionEnabled:NO];
    
    self.navigationItem.titleView = logoView;
    
}

-(void)selectRightAction:(id)sender
{   
    HYSystemConfigViewController *sysconfigView = [[HYSystemConfigViewController alloc] init];
    sysconfigView.userLogin = self.userLogin;
    NSLog(@"系统设置  selectRightAction self.userLogin.user_name %@",self.userLogin.user_name);
    sysconfigView.title = @"系统设置";
    [self.navigationController pushViewController:sysconfigView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retail:(id)sender
{
    HYRetailViewController *retailView = [[HYRetailViewController alloc] init];
    retailView.userLogin = self.userLogin;
    retailView.title = @"零售通";
    
    [self.navigationController pushViewController:retailView animated:YES];
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
}

@end
