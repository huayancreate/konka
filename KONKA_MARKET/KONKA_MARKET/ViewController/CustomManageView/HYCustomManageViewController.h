//
//  HYCustomManageViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-8-16.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYCustomManageViewController : HYBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelStoreName;
@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelTime;
@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelModelName;
@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelNum;
@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelPrice;
@property (nonatomic, retain) HYUserLoginModel *userlogin;
@property (strong, nonatomic) NSMutableArray *customList;

@property (weak, nonatomic) IBOutlet UITableView *uiTableView;

@end
