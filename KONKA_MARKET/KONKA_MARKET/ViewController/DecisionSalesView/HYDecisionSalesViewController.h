//
//  HYDecisionSalesViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-9-23.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "TopTableViewCell.h"
#import "CKCalendarView.h"

@interface HYDecisionSalesViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,TopTabelViewCell,CKCalendarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *topTableView;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UITableView *uiTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblModelName;
@property (weak, nonatomic) IBOutlet UILabel *lblAllPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblAllNum;
@property (weak, nonatomic) IBOutlet UILabel *lblAvgPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblOrder;

@property (strong, nonatomic) NSMutableArray *modelList;

@end
