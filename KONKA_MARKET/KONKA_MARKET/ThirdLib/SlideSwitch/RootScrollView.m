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
#import "HYWebBaseViewController.h"

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
@synthesize linkNav;

+ (RootScrollView *)shareInstance:(NSString *)username Password:(NSString *)password Nav:(UINavigationController *)navController{
    static RootScrollView *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion=[[self alloc] initWithFrame:CGRectMake(0, 44, 320, [Globle shareInstance].globleHeight-44) Username:username Password:password Nav:navController];
    });
    return __singletion;
}


- (id)initWithFrame:(CGRect)frame  Username:(NSString *)username Password:(NSString *)password Nav:(UINavigationController *)navController
{
    self.userlogin = [[HYUserLoginModel alloc] init];
    self.userlogin.user_name = username;
    self.userlogin.password = password;
    self.linkNav = navController;
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
        
        tittle_id = nil;
        
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
//    [msg	replaceOccurrencesOfString:(NSString *) withString:(NSString *)]
    
    NSLog(@"msg1 %@",msg);
    
    NSMutableString *msg1 = [[NSMutableString alloc] initWithFormat:@"%@",msg];
    for (int i = 0; i < [msg1 length]; i++)
    {
        
        int asciiCode = [msg1 characterAtIndex:i];
        if (asciiCode == 7)
        {
            NSRange range;
            range.location = i;
            range.length = 1;
            [msg1 replaceCharactersInRange:range withString:@"·"];
        }
    }
    
    JSONDecoder *decoder = [[JSONDecoder alloc] init];
    NSData *data = [msg1 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *json = [decoder objectWithData:data];
    NSLog(@"json count %d",json.count);
    if ( [json count] == 0)
    {
        return;
    }
    [self.tittleList removeAllObjects];
    [self.imageList removeAllObjects];
    [self.summaryList removeAllObjects];
    [self.linkList removeAllObjects];
    for (NSDictionary *dic in json) {
        [self.tittleList addObject:[dic objectForKey:@"title"]];
        [self.imageList addObject: [BaseURL stringByAppendingFormat:@"/%@",[dic objectForKey:@"img_path"]]];
        [self.summaryList addObject:[dic objectForKey:@"summary"]];
        [self.linkList addObject:[dic objectForKey:@"link_out_addr"]];
    }
    if (tittle_id == nil)
    {
        [tabelViewAll reloadData];
    }
    if ([tittle_id isEqualToString:@"1020"])
    {
        [tabelViewImportNews reloadData];
    }
    if ([tittle_id isEqualToString:@"1030"])
    {
        [tabelViewDym reloadData];
    }
    if ([tittle_id isEqualToString:@"1040"])
    {
        [tabelViewNewProduct reloadData];
    }
    if ([tittle_id isEqualToString:@"1050"])
    {
        [tabelViewComp reloadData];
    }
    if ([tittle_id isEqualToString:@"1060"])
    {
        [tabelViewOther reloadData];
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
//    UIImage *image = nil;
    if ([self.tittleList count] !=0 )
    {
        self.uiLabelTittle.text = [self.tittleList objectAtIndex:indexPath.row];
        NSLog(@"[self.tittleList objectAtIndex:indexPath.row] %@",[self.tittleList objectAtIndex:indexPath.row]);
        self.uiLabelSummary.text = [self.summaryList objectAtIndex:indexPath.row];
        NSLog(@"imgPath %@",[self.imageList objectAtIndex:indexPath.row]);
        NSURL *url = [[NSURL alloc] initWithString:[self.imageList objectAtIndex:indexPath.row]];
        [self.uiImagePath setImageWithURL:url];
    }
//    if ([topScrollViewTittle isEqualToString:@"全部"])
//    {
//        if ([self.tittleList count] !=0 )
//        {
//            self.uiLabelTittle.text = [self.tittleList objectAtIndex:indexPath.row];
//            NSLog(@"[self.tittleList objectAtIndex:indexPath.row] %@",[self.tittleList objectAtIndex:indexPath.row]);
//            self.uiLabelSummary.text = [self.summaryList objectAtIndex:indexPath.row];
//            NSLog(@"imgPath %@",[self.imageList objectAtIndex:indexPath.row]);
//            NSURL *url = [[NSURL alloc] initWithString:[self.imageList objectAtIndex:indexPath.row]];
//            [self.uiImagePath setImageWithURL:url];
//        }
//    }
//    if ([topScrollViewTittle isEqualToString:@"要闻"])
//    {
//        image = [UIImage imageNamed:@"setting.png"];
//        cell.imageView.image = image;
//    }
//    if ([topScrollViewTittle isEqualToString:@"动态"])
//    {
//        image = [UIImage imageNamed:@"menu_refresh.png"];
//        cell.imageView.image = image;
//    }
//    if ([topScrollViewTittle isEqualToString:@"新品"])
//    {
//        image = [UIImage imageNamed:@"about.png"];
//        cell.imageView.image = image;
//    }
//    if ([topScrollViewTittle isEqualToString:@"竞品"])
//    {
//        image = [UIImage imageNamed:@"about.png"];
//        cell.imageView.image = image;
//    }
//    if ([topScrollViewTittle isEqualToString:@"其他"])
//    {
//        image = [UIImage imageNamed:@"about.png"];
//        cell.imageView.image = image;
//    }
    return  cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HYWebBaseViewController *webView = [[HYWebBaseViewController alloc] init];
    webView.link_url = [self.linkList objectAtIndex:indexPath.row];
    webView.userLogin = self.userlogin;
    webView.title = @"资讯展示";
    [self.linkNav pushViewController:webView animated:YES];
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

int _currentPage = 0;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    userContentOffsetX = scrollView.contentOffset.x;
    _currentPage = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (userContentOffsetX < scrollView.contentOffset.x) {
        isLeftScroll = YES;
    }
    else {
        isLeftScroll = NO;
    }
}


int _lastPosition = 0;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int indexPage = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    NSLog(@"indexPage %d",indexPage);
    int currentPostion = scrollView.contentOffset.x;
    //调整顶部滑条按钮状态
    if(_currentPage != indexPage){
         [self adjustTopScrollViewButton:scrollView];        
    }
    
    CGFloat pagewidth = self.frame.size.width;
    int page = floor((self.contentOffset.x - pagewidth/([viewNameArray count]+2))/pagewidth)+1;
    NSLog(@"page %d", page);
    switch (page) {
        case 0:
            tittle_id = nil;
            [self loadNewsPlat];
            break;
        case 1:
            tittle_id = @"1020";
            [self loadNewsPlat];
            break;
        case 2:
            tittle_id = @"1030";
            [self loadNewsPlat];
            break;
        case 3:
            tittle_id = @"1040";
            [self loadNewsPlat];
            break;
        case 4:
            tittle_id = @"1050";
            [self loadNewsPlat];
            break;
        case 5:
            tittle_id = @"1060";
            [self loadNewsPlat];
            break;
    }

    
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
    [[TopScrollView shareInstance:self.userlogin.user_name Password:self.userlogin.password Nav:self.linkNav] setButtonUnSelect];
    [TopScrollView shareInstance:self.userlogin.user_name Password:self.userlogin.password Nav:self.linkNav].scrollViewSelectedChannelID = POSITIONID+100;
    [[TopScrollView shareInstance:self.userlogin.user_name Password:self.userlogin.password Nav:self.linkNav] setButtonSelect];
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
