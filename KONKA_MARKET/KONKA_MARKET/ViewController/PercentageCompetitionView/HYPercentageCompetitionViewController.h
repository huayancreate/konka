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

-(IBAction)percentageConfigAction:(id)sender;

@end
