//
//  HYSystemConfigViewController.m
//  KONKA_MARKET
//
//  Created by archon on 13-7-9.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYSystemConfigViewController.h"
#import "HYModelConfigViewController.h"
#import "HYPercentageConfigViewController.h"
#import "HYPasswordConfigViewController.h"
#import "HYAboutViewController.h"
#import "WZGuideViewController.h"
#import "HYLoginViewController.h"

@interface HYSystemConfigViewController ()

@end

@implementation HYSystemConfigViewController
@synthesize uibgLabel;

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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SystemConfigList" ofType:@"plist"];
    
    NSDictionary *dir = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    self.resource = dir;
    
    NSArray *arr = [[self.resource allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.mykey = arr;
    
    UIView *tempView = [[UIView alloc] init];
    [self.tableViewGroup setBackgroundView:tempView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark Table View Group

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //返回（向系统发送）分区个数,在这里有多少键就会有多少分区。
    return  [self.mykey count];
}

//所在分区所占的行数。
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //获取当前分区所对应的键(key)。在这里键就是分区的标示。
    NSString *key=[self.mykey objectAtIndex:section];
    //获取键所对应的值（数组）。
    NSArray *nameSec=[self.resource objectForKey:key];
    //返回所在分区所占多少行。
    return  [nameSec count];
}
//向屏幕显示。
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    NSInteger section=[indexPath section];
    NSString *key=[self.mykey objectAtIndex:section];
    NSArray *MySectionArr=[self.resource objectForKey:key];
    static NSString *SectionTableMyTag=@"dong";
    UITableViewCell *cell = nil;
    cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SectionTableMyTag];
    cell.textLabel.text=[MySectionArr objectAtIndex:row];
    UIImage *image = nil;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    image = [UIImage imageNamed:@"switchuser.png"];
                    cell.imageView.image = image;
                    break;
            }

            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    image = [UIImage imageNamed:@"setting.png"];
                    cell.imageView.image = image;
                    break;
                case 1:
                    image = [UIImage imageNamed:@"setting.png"];
                    cell.imageView.image = image;
                    break;
            }

            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    image = [UIImage imageNamed:@"menu_refresh.png"];
                    cell.imageView.image = image;
                    break;
                case 1:
                    image = [UIImage imageNamed:@"about.png"];
                    cell.imageView.image = image;
                    break;
            }
            break;
        case 3:
            switch (indexPath.row) {
                case 0:
                    image = nil;
                    cell.imageView.image = image;
                    break;
                case 1:
                    image = nil;
                    cell.imageView.image = image;
                    break;
                case 2:
                    image = nil;
                    cell.imageView.image = image;
                    break;
            }
            break;
    }
    
    return  cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableViewGroup cellForRowAtIndexPath:indexPath];
    if([cell.textLabel.text isEqualToString:@"账号管理"]){
        HYPasswordConfigViewController *formTableView = [[HYPasswordConfigViewController alloc]init];
        formTableView.title = @"账户管理";
        NSLog(@"系统设置 self.userLogin.user_name %@",self.userLogin.user_name);
        formTableView.userLogin = self.userLogin;
        [self.navigationController pushViewController:formTableView animated:YES];
    }
    
    if([cell.textLabel.text isEqualToString:@"型号设定"]){
        HYModelConfigViewController *modelConfigView = [[HYModelConfigViewController alloc] init];
        modelConfigView.userLogin = self.userLogin;
        modelConfigView.title = @"型号设定";
        
        [self.navigationController pushViewController:modelConfigView animated:YES];
    }
    
    if([cell.textLabel.text isEqualToString:@"产品销售提成设定"]){
        HYPercentageConfigViewController *modelView = [[HYPercentageConfigViewController alloc]init];
        modelView.title = @"提成设定";
        modelView.userLogin = self.userLogin;
        [self.navigationController pushViewController:modelView animated:YES];
    }
    
    if([cell.textLabel.text isEqualToString:@"关于"]){
        HYAboutViewController *aboutView = [[HYAboutViewController alloc]init];
        aboutView.title = @"关于";
        [self.navigationController pushViewController:aboutView animated:YES];
    }
    
    if([cell.textLabel.text isEqualToString:@"退出"]){
        exit(0);
    }
    
    if([cell.textLabel.text isEqualToString:@"重新登录"]){
        HYLoginViewController *loginView = [[HYLoginViewController alloc] init];
        [self.navigationController pushViewController:loginView animated:YES];
    }
    
    if([cell.textLabel.text isEqualToString:@"新手上路"]){
        [WZGuideViewController show];
    }
    
    if([cell.textLabel.text isEqualToString:@"新版本检测"]){
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3];
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

static float progress = 0.0f;

- (void)increaseProgress {
    progress+=0.1f;
    [SVProgressHUD showProgress:progress status:@"正在检查版本..."];
    
    if(progress < 1.0f)
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3];
    else
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.4f];
}

-(void)dismiss{
    [SVProgressHUD dismiss];
    [super successMsg:@"已经是最新版本"];
}

@end
