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

@property (strong, nonatomic) IBOutlet UIButton *unRegistrationBtn;

@property (strong, nonatomic) IBOutlet UIButton *registrationBtn;

@property(nonatomic, strong) NSString *status;

@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelStoreName;
@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelTime;
@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelModelName;
@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelNum;
@property (strong, nonatomic) IBOutlet UILabel *uiCellLabelPrice;

@property (strong, nonatomic) IBOutlet UILabel *uiCellAllLabelStoreName;
@property (strong, nonatomic) IBOutlet UILabel *uiCellAllLabelTime;
@property (strong, nonatomic) IBOutlet UILabel *uiCellAllLabelModelName;
@property (strong, nonatomic) IBOutlet UILabel *uiCellAllLabelNum;
@property (strong, nonatomic) IBOutlet UILabel *uiCellAllLabelPrice;
@property (strong, nonatomic) IBOutlet UIImageView *uibgLabel;
@property(nonatomic, strong) UILabel *dateLabel;

-(IBAction)unRegistrationAction:(id)sender;

-(IBAction)registrationAction:(id)sender;

-(void)getHisDataByStartTime:(NSString *)starttime endTime:(NSString *)starttime;
@end
