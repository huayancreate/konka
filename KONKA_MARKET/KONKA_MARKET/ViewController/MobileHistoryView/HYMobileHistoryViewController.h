//
//  HYMobileHistoryViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-11-14.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "TopTableViewCell.h"
#import "CKCalendarView.h"

@interface HYMobileHistoryViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,TopTabelViewCell,CKCalendarDelegate>

@property (nonatomic,strong) UITableView *topTableView;

@property (nonatomic,strong) UITableView *downTableView;

@property (nonatomic,strong) UILabel *salesNum;

@property (nonatomic,strong) UILabel *salesMoney;

@property (strong, nonatomic) IBOutlet UIButton *unRegistrationBtn;

@property (strong, nonatomic) IBOutlet UIButton *registrationBtn;

@property(nonatomic, strong) NSString *status;

@property (weak, nonatomic) IBOutlet UILabel *lblStoreName;
@property (weak, nonatomic) IBOutlet UILabel *lblModelName;
@property (weak, nonatomic) IBOutlet UILabel *lblUpDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDownDate;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UILabel *btnDown;

@property(nonatomic, strong) NSString *is_up;

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
