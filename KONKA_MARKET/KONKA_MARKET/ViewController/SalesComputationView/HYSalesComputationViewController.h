//
//  HYSalesComputationViewController.h
//  KONKA_MARKET
//
//  Created by archon on 13-7-17.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "TopTableViewCell.h"
#import "CKCalendarView.h"

@interface HYSalesComputationViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,TopTabelViewCell,CKCalendarDelegate>
{
}

@property (nonatomic,strong) UITableView *topTableView;

@property (nonatomic,strong) UILabel *salesNum;

@property (nonatomic,strong) UILabel *salesMoney;

@property (strong, nonatomic) IBOutlet UIButton *uiSizeBtn;
@property (strong, nonatomic) IBOutlet UIButton *uiModelBtn;
@property (strong, nonatomic) IBOutlet UIButton *uiYearsBtn;
@property (strong, nonatomic) IBOutlet UIImageView *uibgLabel;
@property (strong, nonatomic) IBOutlet UIView *chartView;

-(IBAction)sizeAction:(id)sender;

-(IBAction)modelAction:(id)sender;

-(IBAction)yearsAction:(id)sender;

@end
