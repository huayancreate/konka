//
//  TopScrollView.m
//  SlideSwitchDemo
//
//  Created by liulian on 13-4-23.
//  Copyright (c) 2013年 liulian. All rights reserved.
//

#import "TopScrollView.h"
#import "Globle.h"
#import "RootScrollView.h"

//按钮空隙
#define BUTTONGAP 3
//按钮长度
#define BUTTONWIDTH 60
//按钮宽度
#define BUTTONHEIGHT 30
//滑条CONTENTSIZEX
#define CONTENTSIZEX 320

#define BUTTONID (sender.tag-100)
#define POSITIONID (int)scrollView.contentOffset.x/320

@implementation TopScrollView

@synthesize nameArray;
@synthesize scrollViewSelectedChannelID;
@synthesize userlogin;
@synthesize linkNav;

+ (TopScrollView *)shareInstance:(NSString *)username Password:(NSString *)password Nav:(UINavigationController *)navController{
    static TopScrollView *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        [Globle shareInstance].globleWidth = screenRect.size.width; //屏幕宽度
        [Globle shareInstance].globleHeight = screenRect.size.height-20;  //屏幕高度（无顶栏）
        [Globle shareInstance].globleAllHeight = screenRect.size.height;  //屏幕高度（有顶栏）
        __singletion=[[self alloc] initWithFrame:CGRectMake(0, 0, CONTENTSIZEX, 44) Username:username Password:password Nav:navController];
    });
    return __singletion;
}

- (id)initWithFrame:(CGRect)frame Username:(NSString *)username Password:(NSString *)password Nav:(UINavigationController *)navController
{
    self.userlogin.user_name = username;
    self.userlogin.password = password;
    self.linkNav = navController;
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.nameArray = [NSArray arrayWithObjects:@"全部", @"动态", @"产品", @"通知", @"其他", nil];
        self.contentSize = CGSizeMake(0, 44);
        
        userSelectedChannelID = 100;
        scrollViewSelectedChannelID = 100;
        
        [self initWithNameButtons];
    }
    return self;
}

- (void)initWithNameButtons
{
    shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 60, 44)];
    [shadowImageView setImage:[UIImage imageNamed:@"red_line_and_shadow.png"]];
    [self addSubview:shadowImageView];
    
    for (int i = 0; i < [self.nameArray count]; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(BUTTONGAP+(BUTTONGAP+BUTTONWIDTH)*i, 9, BUTTONWIDTH, 30)];
        [button setTag:i+100];
        if (i == 0) {
            button.selected = YES;
        }
        [button setTitle:[NSString stringWithFormat:@"%@",[self.nameArray objectAtIndex:i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:20.0];
        [button setTitleColor:[Globle colorFromHexRGB:@"868686"] forState:UIControlStateNormal];
        [button setTitleColor:[Globle colorFromHexRGB:@"bb0b15"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)selectNameButton:(UIButton *)sender
{
    //[self adjustScrollViewContentX:sender];
    
    //如果更换按钮
    if (sender.tag != userSelectedChannelID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self viewWithTag:userSelectedChannelID];
        lastButton.selected = NO;
        //赋值按钮ID
        userSelectedChannelID = sender.tag;
    }
    
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [shadowImageView setFrame:CGRectMake(sender.frame.origin.x, 0, 60, 44)];
            
        } completion:^(BOOL finished) {
            if (finished) {
                
                //设置新闻页出现
                RootScrollView *rootView = [RootScrollView shareInstance:self.userlogin.user_name Password:self.userlogin.password Nav:self.linkNav];
                [rootView setContentOffset:CGPointMake(BUTTONID*320, 0) animated:NO];
                //rootView.tittle_id = @"1030";
                //[rootView loadNewsPlat];
                //赋值滑动列表选择频道ID
                scrollViewSelectedChannelID = sender.tag;
                NSString *title_id = nil;
                switch (sender.tag) {
                    case 100:
                        title_id = nil;
                        break;
                    case 101:
                        title_id = @"1020";
                        break;
//                    case 102:
//                        title_id = @"1030";
//                        break;
                    case 102:
                        title_id = @"1040";
                        break;
                    case 103:
                        title_id = @"-1";
                        break;
                    case 104:
                        title_id = @"1060";
                }
                rootView.tittle_id = title_id;
                [rootView loadNewsPlat];

                //NSLog(@"title_id %@",newString);
            }
        }];
        
    }
    //重复点击选中按钮
    else {
        
    }
}

- (void)adjustScrollViewContentX:(UIButton *)sender
{
    if (sender.frame.origin.x - self.contentOffset.x > CONTENTSIZEX-(BUTTONGAP+BUTTONWIDTH)) {
        [self setContentOffset:CGPointMake((BUTTONID-4)*(BUTTONGAP+BUTTONWIDTH)+45, 0)  animated:YES];
    }
    
    if (sender.frame.origin.x - self.contentOffset.x < 5) {
        [self setContentOffset:CGPointMake(BUTTONID*(BUTTONGAP+BUTTONWIDTH), 0)  animated:YES];
    }
}

- (void)setButtonUnSelect
{
    //滑动撤销选中按钮
    UIButton *lastButton = (UIButton *)[self viewWithTag:scrollViewSelectedChannelID];
    lastButton.selected = NO;
}

- (void)setButtonSelect
{
    //滑动选中按钮
    UIButton *button = (UIButton *)[self viewWithTag:scrollViewSelectedChannelID];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [shadowImageView setFrame:CGRectMake(button.frame.origin.x, 0, 60, 44)];
        
    } completion:^(BOOL finished) {
        if (finished) {
            if (!button.selected) {
                button.selected = YES;
                userSelectedChannelID = button.tag;
            }
        }
    }];
    
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
