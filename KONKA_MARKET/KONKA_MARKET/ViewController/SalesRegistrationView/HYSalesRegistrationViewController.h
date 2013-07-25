//
//  HYSalesRegistrationViewViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-16.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "TopTableViewCell.h"
#import "CKCalendarView.h"

@interface HYSalesRegistrationViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,TopTabelViewCell,CKCalendarDelegate>

@property (nonatomic,strong) UITableView *topTableView;

@property (nonatomic,strong) UITableView *downTableView;

@property (nonatomic,strong) UILabel *salesNum;

@property (nonatomic,strong) UILabel *salesMoney;

@property (nonatomic,strong) NSMutableArray *dataItems;

@property (strong, nonatomic) IBOutlet UIButton *unRegistrationBtn;

@property (strong, nonatomic) IBOutlet UIButton *registrationBtn;

-(IBAction)unRegistrationAction:(id)sender;

-(IBAction)registrationAction:(id)sender;

@end
