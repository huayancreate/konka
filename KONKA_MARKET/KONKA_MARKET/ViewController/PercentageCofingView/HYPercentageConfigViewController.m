//
//  HYPercentageConfigViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-18.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYPercentageConfigViewController.h"

@interface HYPercentageConfigViewController ()

@end

@implementation HYPercentageConfigViewController
@synthesize mainTableView;
@synthesize dyArray;
@synthesize uiModelLabel;
@synthesize uiPercentLabel;
@synthesize uiPercentCellLabel;
@synthesize percentString;

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
    [mainTableView setBackgroundView:tempView];
    
    
    [self.uiFixed setBackgroundColor:[UIColor blueColor]];
    [self.uiPercent setBackgroundColor:[UIColor clearColor]];
    
    [self.uiFixed.titleLabel setTextColor:[UIColor blackColor]];
    [self.uiPercent.titleLabel setTextColor:[UIColor blackColor]];
    
    dyArray = [[NSMutableArray alloc] init];
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    [self.uiModelTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.uiPercentTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    self.percentString = @"固定提成";
}

- (IBAction)textFieldFinished:(id)sender {
    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [dyArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CustomCellIdentifier =@"PercentCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    if (cell ==nil) {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYpercentTabelViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.uiModelLabel.text = self.uiModelTextField.text;
    self.uiPercentCellLabel.text = self.uiPercentTextField.text;
    self.uiPercentLabel.text = self.percentString;
    return  cell;
}


-(IBAction)fixedAction:(id)sender
{
    [self.uiFixed setBackgroundColor:[UIColor blueColor]];
    [self.uiPercent setBackgroundColor:[UIColor clearColor]];
    self.percentString = @"固定提成";
    [self.uiFixed.titleLabel setTextColor:[UIColor blackColor]];
    [self.uiPercent.titleLabel setTextColor:[UIColor blackColor]];

}

-(IBAction)percentAction:(id)sender
{
    [self.uiFixed setBackgroundColor:[UIColor clearColor]];
    [self.uiPercent setBackgroundColor:[UIColor blueColor]];
     self.percentString = @"按比例提成";
    [self.uiFixed.titleLabel setTextColor:[UIColor blackColor]];
    [self.uiPercent.titleLabel setTextColor:[UIColor blackColor]];
    
}

-(IBAction)saveAction:(id)sender
{
    
    if (![self checkTextisNull])
    {
        return;
    }
    
    [self.mainTableView beginUpdates];
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [indexPaths addObject: indexPath];
    
    [dyArray addObject:@"111"];
    
    
    
    [self.mainTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    
    [self.mainTableView endUpdates];
    
}

-(BOOL) checkTextisNull
{
    if( self.uiModelTextField.text.length == 0){
        //TOD 弹出警告
        NSString *msg = @"型号不能为空！";
        [super alertMsg:msg forTittle:@"输入错误"];
        return false;
    }
    if( self.uiPercentTextField.text.length == 0){
        //TOD 弹出警告
        NSString *msg = @"提成不能为空！";
        [super alertMsg:msg forTittle:@"输入错误"];
        return false;
    }
    return true;
}


@end
