//
//  HYCustomManageViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-8-16.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "CKCalendarView.h"

@interface HYCustomManageViewController : HYBaseViewController<UITableViewDataSource,UITableViewDelegate,CKCalendarDelegate>

@property (nonatomic, retain) HYUserLoginModel *userlogin;
@property (strong, nonatomic) NSMutableArray *customList;

@property (weak, nonatomic) IBOutlet UITableView *uiTableView;
@property (weak, nonatomic) IBOutlet UITableView *uiTableViewSearch;

@property (nonatomic,retain) NSArray *mykey;

@property (strong, nonatomic) IBOutlet UIButton *btnMonth;
@property (strong, nonatomic) IBOutlet UITextField *txtCustomName;
@property (strong, nonatomic) IBOutlet UITextField *txtR3Code;
@property (strong, nonatomic) IBOutlet UITextField *txtYwyName;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;

@property (weak, nonatomic) IBOutlet UILabel *lblCustomerName;
@property (weak, nonatomic) IBOutlet UILabel *lblR3Code;
@property (weak, nonatomic) IBOutlet UILabel *lblR3SaleMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblR3SaleCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCredit;
@property (weak, nonatomic) IBOutlet UILabel *lblBackMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblSaleMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblSaleCount;

@end
