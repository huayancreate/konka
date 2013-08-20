//
//  HYCustomR3ViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-8-20.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYCustomR3ViewController : HYBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblR3TotalMoney;
@property (strong, nonatomic) IBOutlet UILabel *lblR3TotalCount;
@property (strong, nonatomic) IBOutlet UILabel *lblAvgMlMoney;
@property (strong, nonatomic) IBOutlet UILabel *lblAvgUnitPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblTbMlMoney;
@property (strong, nonatomic) IBOutlet UILabel *lblTbUnitPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblCustomName;

@property (strong, nonatomic) NSMutableArray *customR3List;
@property (nonatomic, retain) HYUserLoginModel *userlogin;
@property (weak, nonatomic) IBOutlet UITableView *uiTableView;

@end