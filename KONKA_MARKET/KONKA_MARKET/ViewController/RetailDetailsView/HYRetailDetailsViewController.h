//
//  HYRetailDetailsViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-12-4.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "CKCalendarView.h"

@interface HYRetailDetailsViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,CKCalendarDelegate>

@property (nonatomic,strong) UITableView *uiTableView;
@property (nonatomic, strong) UIButton *dateLabel;

@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@property(nonatomic, strong) NSString *currentDate;
@property(nonatomic, strong) NSMutableArray *resultList;
@property(nonatomic, strong) NSString *startTime;
@property(nonatomic, strong) NSString * endTime;

@property (strong, nonatomic) IBOutlet UILabel *lblSaleMoney;
@property (strong, nonatomic) IBOutlet UILabel *lblStoreName;
@property (strong, nonatomic) IBOutlet UILabel *lblSaleCount;
@property (strong, nonatomic) UILabel *salesNum;
@property (strong, nonatomic) UILabel *salesMoney;

@end

