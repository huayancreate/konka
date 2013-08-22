//
//  HYCustomDetailViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-8-21.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYCustomDetailViewController : HYBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *uiTableView;
@property (strong, nonatomic) IBOutlet UILabel *lblR3Name;
@property (strong, nonatomic) IBOutlet UILabel *lblMonth;
@property (strong, nonatomic) IBOutlet UILabel *lblR3Code;
@property (strong, nonatomic) IBOutlet UILabel *lblR3SaleCount;
@property (strong, nonatomic) IBOutlet UILabel *lblR3SaleMoney;
@property (strong, nonatomic) IBOutlet UILabel *lblSaleCount;
@property (strong, nonatomic) IBOutlet UILabel *lblSaleMoney;
@property (strong, nonatomic) IBOutlet UILabel *lblBackMoney;

@end
