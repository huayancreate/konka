//
//  HYPercentageCompetitionViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-17.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "TopTableViewCell.h"
#import "CKCalendarView.h"

@interface HYPercentageCompetitionViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,TopTabelViewCell,CKCalendarDelegate>


@property (nonatomic,strong) UITableView *topTableView;
@property (strong, nonatomic) IBOutlet UILabel *uiModelLabel;
@property (strong, nonatomic) IBOutlet UILabel *uiNumber;
@property (strong, nonatomic) IBOutlet UILabel *uiPercentage;
@property (strong, nonatomic) IBOutlet UILabel *uiNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *uiPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *uiPercentageLabel;

@property (strong, nonatomic) IBOutlet UITableView *downLoadTabelView;

-(IBAction)percentageConfigAction:(id)sender;

@end
