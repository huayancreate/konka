//
//  HYMobileDataSubmitViewController.h
//  KONKA_MARKET
//
//  Created by andychen on 13-11-14.
//  Copyright (c) 2013年 archon. All rights reserved.
//

#import "HYBaseViewController.h"
#import "HYTableViewCell.h"
#import "AutocompletionTableView.h"
#import "ZBarSDK.h"

@interface HYMobileDataSubmitViewController : HYBaseViewController<UITableViewDelegate,UITableViewDataSource,HYTableViewCell,AutocompletionTableViewDelegate,ZBarReaderDelegate,UITextFieldDelegate>{
    
}

@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic, strong) UITableView *dropTableView;
@property (nonatomic, strong) UITableView *dropDownTableView;
@property (strong, nonatomic) IBOutlet UIImageView *uibgLabel;

- (IBAction)hisAction:(id)sender;

@property(nonatomic, strong) NSString *is_up;
@end