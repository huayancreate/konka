//
//  HYRetailSearchViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-12-4.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "CKCalendarView.h"

@interface HYRetailSearchViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,CKCalendarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *uiSearch;
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) UIButton *btnSearch;
@property(nonatomic, strong) UIButton *btnBack;
@property(nonatomic, strong) UIButton *btnStartTime;
@property(nonatomic, strong) UIButton *btnEndTime;

@property (nonatomic) NSInteger *flagTag;

@end

