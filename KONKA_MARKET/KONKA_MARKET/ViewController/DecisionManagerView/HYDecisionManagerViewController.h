//
//  HYDecisionManagerViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-9-23.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "TopTableViewCell.h"
#import "CKCalendarView.h"

@interface HYDecisionManagerViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,TopTabelViewCell,CKCalendarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *topTableView;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UITableView *displayTableView;
@property (nonatomic, strong) IBOutlet UITableView *totalTableView;

@property (weak, nonatomic) IBOutlet UILabel *lblDeptName;
@property (weak, nonatomic) IBOutlet UILabel *lblSale;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *lblAllPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblRwMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblOrder;

@property (strong, nonatomic) NSMutableArray *taskCompleteList;
@property (strong, nonatomic) NSMutableDictionary *taskComplete;

@property (strong, nonatomic) IBOutlet UIProgressView *uiProgressView;
@property (strong, nonatomic) IBOutlet UILabel * lblSalesMsg;
@property (strong, nonatomic) IBOutlet UILabel * lblSales;
@property (strong, nonatomic) IBOutlet UILabel * lblAllPricesMsg;
@property (strong, nonatomic) IBOutlet UILabel * lblAllPrices;
@property (strong, nonatomic) IBOutlet UILabel * lblRwMoneysMsg;
@property (strong, nonatomic) IBOutlet UILabel * lblRwMoneys;

@end
