//
//  RootScrollView.h
//  SlideSwitchDemo
//
//  Created by liulian on 13-4-23.
//  Copyright (c) 2013年 liulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYUserLoginModel.h"
#import "DataProcessing.h"

@interface RootScrollView : UIScrollView <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *viewNameArray;
    CGFloat userContentOffsetX;
    BOOL isLeftScroll;
}
@property (nonatomic, retain) NSArray *viewNameArray;
@property (nonatomic, retain) UITableView *mainTableView;
@property (nonatomic, retain) NSString *topScrollViewTittle;
@property (nonatomic, retain) UITableView *tabelViewAll;
@property (nonatomic, retain) UITableView *tabelViewImportNews;
@property (nonatomic, retain) UITableView *tabelViewDym;
@property (nonatomic, retain) UITableView *tabelViewNewProduct;
@property (nonatomic, retain) UITableView *tabelViewComp;
@property (nonatomic, retain) UITableView *tabelViewOther;
@property (nonatomic, retain) NSString *tittle_id;
@property (nonatomic, retain) HYUserLoginModel *userlogin;
@property (strong, nonatomic) IBOutlet UILabel *uiLabelTittle;
@property (strong, nonatomic) IBOutlet UILabel *uiLabelSummary;
@property (strong, nonatomic) IBOutlet UIImageView *uiImagePath;
@property (strong, nonatomic) NSMutableArray *tittleList;
@property (strong, nonatomic) NSMutableArray *imageList;
@property (strong, nonatomic) NSMutableArray *summaryList;
@property (strong, nonatomic) NSMutableArray *linkList;
@property (strong, nonatomic) UINavigationController *linkNav;

-(void)start;
-(void)end;

+ (RootScrollView *)shareInstance:(NSString *)username Password:(NSString *)password Nav:(UINavigationController *)navController;

@end
