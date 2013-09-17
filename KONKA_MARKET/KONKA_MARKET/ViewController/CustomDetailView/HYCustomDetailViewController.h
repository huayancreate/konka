//
//  HYCustomDetailViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-8-21.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYCustomDetailViewController : HYBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *uiTableView;
@property (weak, nonatomic) IBOutlet UITableView *uiTableViewSearch;

@property (strong, nonatomic) NSMutableArray *customDetailList;
@property (nonatomic,retain) NSArray *mykey;
@property (nonatomic, retain) HYUserLoginModel *userlogin;

@property (weak, nonatomic) IBOutlet UILabel *lblCustomerName;
@property (weak, nonatomic) IBOutlet UILabel *lblR3Code;
@property (weak, nonatomic) IBOutlet UILabel *lblCustomerType;
@property (weak, nonatomic) IBOutlet UILabel *lblywyName;
@property (weak, nonatomic) IBOutlet UILabel *lblDeptName;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkManName;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkManTel;
@property (weak, nonatomic) IBOutlet UILabel *lblLegalName;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkManMobile;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkManAddr;
@property (weak, nonatomic) IBOutlet UILabel *lblLinkManPost;

@property (strong, nonatomic) IBOutlet UITextField *txtR3Code;
@property (strong, nonatomic) IBOutlet UITextField *txtCustomName;
@property (strong, nonatomic) IBOutlet UITextField *txtYwyName;
@property (strong, nonatomic) IBOutlet UIButton *btnSearch;

@property (strong, nonatomic) NSString *customer_name;
@property (strong, nonatomic) NSString *r3_code;

@end
