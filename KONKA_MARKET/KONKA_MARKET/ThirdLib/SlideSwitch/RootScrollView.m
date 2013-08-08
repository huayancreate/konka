//
//  RootScrollView.m
//  SlideSwitchDemo
//
//  Created by liulian on 13-4-23.
//  Copyright (c) 2013年 liulian. All rights reserved.
//

#import "RootScrollView.h"
#import "Globle.h"
#import "TopScrollView.h"
#import "HYSeverContUrl.h"
#import "DataProcessing.h"
#import "SVProgressHUD.h"
#import "JSONKit.h"
#import "SDImageView+SDWebCache.h"
#import "HYAppUtily.h"
#import "HYSeverContUrl.h"

#define POSITIONID (int)scrollView.contentOffset.x/320
@implementation RootScrollView

@synthesize viewNameArray;
@synthesize topScrollViewTittle;
@synthesize tabelViewAll;
@synthesize tabelViewComp;
@synthesize tabelViewDym;
@synthesize tabelViewImportNews;
@synthesize tabelViewNewProduct;
@synthesize tabelViewOther;
@synthesize tittle_id;
@synthesize userlogin;
@synthesize uiLabelTittle;
@synthesize uiImagePath;
@synthesize uiLabelSummary;
@synthesize linkList;

+ (RootScrollView *)shareInstance:(NSString *)username Password:(NSString *)password {
    static RootScrollView *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion=[[self alloc] initWithFrame:CGRectMake(0, 44, 320, [Globle shareInstance].globleHeight-44) Username:username Password:password];
    });
    return __singletion;
}


- (id)initWithFrame:(CGRect)frame  Username:(NSString *)username Password:(NSString *)password;
{
    self.userlogin = [[HYUserLoginModel alloc] init];
    self.userlogin.user_name = username;
    self.userlogin.password = password;
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.viewNameArray = [NSArray arrayWithObjects:@"全部", @"要闻", @"动态", @"新品", @"竞品", @"其他", nil];
        self.contentSize = CGSizeMake(320*[viewNameArray count], [Globle shareInstance].globleHeight-44);
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        userContentOffsetX = 0;
        
        topScrollViewTittle = @"全部";
        
        self.tittleList = [[NSMutableArray alloc] init];
        self.imageList = [[NSMutableArray alloc] init];
        self.summaryList = [[NSMutableArray alloc] init];
        self.linkList = [[NSMutableArray alloc] init];
        [self initWithViews];
        [self loadNewsPlat];
    }
    return self;
}

-(void)loadNewsPlat
{
    if ([topScrollViewTittle isEqualToString:@"全部"])
    {
        tittle_id = nil;
    }
    [SVProgressHUD showWithStatus:@"数据获取中..." maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.userlogin.user_name,@"username",self.userlogin.password,@"password",tittle_id,@"article_type_id",nil];
    
    NSLog(@"%@,,,,,",[HYAppUtily stringOutputForDictionary:params]);
    
    NSURL *url = [[NSURL alloc] initWithString:[BaseURL stringByAppendingFormat:ArticleInfoInterfaceApi]];
    
    [[[DataProcessing alloc] init] sentRequest:url Parem:params Target:self];
}

#pragma mark -
#pragma mark DataProcesse
- (void) requestFinished:(ASIHTTPRequest *)request
{
    NSString *responsestring = [request responseString];
    //NSLog(@"responsestring:%@",responsestring);
    [self performSelectorOnMainThread:@selector(endRequest:) withObject:responsestring waitUntilDone:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *responsestring = @"服务器连接失败";
    [self performSelectorOnMainThread:@selector(endFailedRequest:) withObject:responsestring waitUntilDone:YES];
}

-(void) endFailedRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
}

-(void) endRequest:(NSString *)msg
{
    [SVProgressHUD dismiss];
    NSLog(@"msg %@",msg);
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *json = [decoder objectWithData:data];
    if ( [json count] == 0)
    {
        return;
    }
    if ([topScrollViewTittle isEqualToString:@"全部"])
    {
        for (NSDictionary *dic in json) {
            [self.tittleList addObject:[dic objectForKey:@"title"]];
            [self.imageList addObject: [BaseURL stringByAppendingFormat:@"/%@",[dic objectForKey:@"img_path"]]];
            [self.summaryList addObject:[dic objectForKey:@"summary"]];
            [self.linkList addObject:[dic objectForKey:@"link_out_addr"]];
        }
        [tabelViewAll reloadData];
        NSLog(@"msg %@", msg);
        
    }
}



- (void)initWithViews
{
    for (int i = 0; i < [viewNameArray count]; i++) {
        UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0+320*i, 0, 320, [Globle shareInstance].globleHeight-44)];
        switch (i) {
            case 0:
                self.tabelViewAll = mainTableView;
                break;
            case 1:
                self.tabelViewImportNews = mainTableView;
                break;
            case 2:
                self.tabelViewDym = mainTableView;
                break;
            case 3:
                self.tabelViewNewProduct = mainTableView;
                break;
            case 4:
                self.tabelViewComp = mainTableView;
                break;
            case 5:
                self.tabelViewOther = mainTableView;
                break;
        }
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        //        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0+320*i, 0, 320, [Globle shareInstance].globleHeight-44)];
        //
        //        label.text = [NSString stringWithFormat:@"%@",[viewNameArray objectAtIndex:i]];
        //        label.textAlignment = NSTextAlignmentCenter;
        //        label.font = [UIFont boldSystemFontOfSize:50.0];
        [self addSubview:mainTableView];
        //[label release];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CustomCellIdentifier =@"NewsPlantCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CustomCellIdentifier];
    NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"HYNewsPlantTabelViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImage *image = nil;
    if ([topScrollViewTittle isEqualToString:@"全部"])
    {
        if ([self.tittleList count] !=0 )
        {
            self.uiLabelTittle.text = [self.tittleList objectAtIndex:indexPath.row];
            NSLog(@"[self.tittleList objectAtIndex:indexPath.row] %@",[self.tittleList objectAtIndex:indexPath.row]);
            self.uiLabelSummary.text = [self.summaryList objectAtIndex:indexPath.row];
            NSLog(@"imgPath %@",[self.imageList objectAtIndex:indexPath.row]);
            NSURL *url = [[NSURL alloc] initWithString:[self.imageList objectAtIndex:indexPath.row]];
            [self.uiImagePath setImageWithURL:url];
        }
    }
    if ([topScrollViewTittle isEqualToString:@"要闻"])
    {
        image = [UIImage imageNamed:@"setting.png"];
        cell.imageView.image = image;
    }
    if ([topScrollViewTittle isEqualToString:@"动态"])
    {
        image = [UIImage imageNamed:@"menu_refresh.png"];
        cell.imageView.image = image;
    }
    if ([topScrollViewTittle isEqualToString:@"新品"])
    {
        image = [UIImage imageNamed:@"about.png"];
        cell.imageView.image = image;
    }
    if ([topScrollViewTittle isEqualToString:@"竞品"])
    {
        image = [UIImage imageNamed:@"about.png"];
        cell.imageView.image = image;
    }
    if ([topScrollViewTittle isEqualToString:@"其他"])
    {
        image = [UIImage imageNamed:@"about.png"];
        cell.imageView.image = image;
    }
    return  cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [SVProgressHUD showSuccessWithStatus:[self.linkList objectAtIndex:indexPath.row]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tittleList count];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    userContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pagewidth = self.frame.size.width;
    int page = floor((self.contentOffset.x - pagewidth/([viewNameArray count]+2))/pagewidth)+1;
    NSLog(@"page %d", page);
    self.topScrollViewTittle = [viewNameArray objectAtIndex:page];
    switch (page) {
        case 0:
            [self.tabelViewAll reloadData];
            break;
        case 1:
            [self.tabelViewImportNews reloadData];
            break;
        case 2:
            [self.tabelViewDym reloadData];
            break;
        case 3:
            [self.tabelViewNewProduct reloadData];
            break;
        case 4:
            [self.tabelViewComp reloadData];
            break;
        case 5:
            [self.tabelViewOther reloadData];
            break;
    }
    if (userContentOffsetX < scrollView.contentOffset.x) {
        isLeftScroll = YES;
    }
    else {
        isLeftScroll = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //调整顶部滑条按钮状态
    [self adjustTopScrollViewButton:scrollView];
    
    //    if (isLeftScroll) {
    //        if (scrollView.contentOffset.x <= 320*3) {
    //            [[TopScrollView shareInstance] setContentOffset:CGPointMake(0, 0) animated:YES];
    //        }
    //        else {
    //            [[TopScrollView shareInstance] setContentOffset:CGPointMake((POSITIONID-4)*64+45, 0) animated:YES];
    //        }
    //
    //    }
    //    else {
    //        if (scrollView.contentOffset.x >= 320*3) {
    //            [[TopScrollView shareInstance] setContentOffset:CGPointMake(2*64+45, 0) animated:YES];
    //        }
    //        else {
    //            [[TopScrollView shareInstance] setContentOffset:CGPointMake(POSITIONID*64, 0) animated:YES];
    //        }
    //    }
}

- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView
{
    [[TopScrollView shareInstance] setButtonUnSelect];
    [TopScrollView shareInstance].scrollViewSelectedChannelID = POSITIONID+100;
    [[TopScrollView shareInstance] setButtonSelect];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
