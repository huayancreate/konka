//
//  HYCompetitionSalesHisViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-8-7.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "TopTableViewCell.h"
#import "CKCalendarView.h"

@interface HYCompetitionSalesHisViewController :  HYBaseViewController<UITableViewDelegate,UITableViewDataSource,TopTabelViewCell,CKCalendarDelegate>

@property (nonatomic,strong) UITableView *topTableView;

@property (nonatomic,strong) UITableView *downTableView;

@property (nonatomic,strong) UILabel *salesNum;

@property (nonatomic,strong) UILabel *salesMoney;

@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelStoreName;
@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelTime;
@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelModelName;
@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelNum;
@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelPrice;

@property (strong, nonatomic) IBOutlet UIImageView *uibgLabel;

@property(nonatomic, strong) UILabel *dateLabel;

-(void)getHisDataByStartTime:(NSString *)starttime endTime:(NSString *)starttime;
@end
