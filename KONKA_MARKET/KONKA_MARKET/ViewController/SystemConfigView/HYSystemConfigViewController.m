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

@interface HYSystemConfigViewController ()

@end

@implementation HYSystemConfigViewController

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
    UIColor *color = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"lst_bg.png"]];
    [tempView setBackgroundColor:color];
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
    //获得所在分区的行数
    NSInteger row=[indexPath row];
    //获得分区值
    NSInteger section=[indexPath section];
    //利用分区获得键值
    NSString *key=[self.mykey objectAtIndex:section];
    //利用键值获得其所对应的值
    NSArray *MySectionArr=[self.resource objectForKey:key];
    //定义标记，用于标记单元格
    static NSString *SectionTableMyTag=@"dong";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:SectionTableMyTag];
    //如果当前cell没被实例(程序一开始就会运行下面的循环，直到屏幕上所显示的单元格格全被实例化了为止，没有显示在屏幕上的单元格将会根据定义好的标记去寻找可以重用的空间来存放自己的值)
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SectionTableMyTag];
    }
    cell.textLabel.text=[MySectionArr objectAtIndex:row];
    
    return  cell;
    
}
//把每个分区打上标记key
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *key=[self.mykey objectAtIndex:section];
    return key;
}
//在单元格最右放添加索引
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.mykey;
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
        modelView.title = @"型号设定";
        [self.navigationController pushViewController:modelView animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
