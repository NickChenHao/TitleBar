//
//  ViewController.m
//  网易新闻
//
//  Created by nick on 16/3/28.
//  Copyright © 2016年 nick. All rights reserved.
//

#import "ViewController.h"

#import "TopViewController.h"
#import "HotViewController.h"
#import "VideoViewController.h"
#import "ScietyViewController.h"
#import "ScienceViewController.h"
#import "ReaderViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建所有的子控制器
    [self setUpAllChildrenVC];
}

#pragma mark - 添加所有子控制器
- (void)setUpAllChildrenVC{
    //头条
    TopViewController *topVC = [[TopViewController alloc] init];
    topVC.title = @"头条";
    [self addChildViewController:topVC];
    //热点
    HotViewController *hotVC = [[HotViewController alloc] init];
    hotVC.title = @"热点";
    [self addChildViewController:hotVC];
    //视频
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    videoVC.title = @"视频";
    [self addChildViewController:videoVC];
    //社会
    ScietyViewController *scietyVC = [[ScietyViewController alloc] init];
    scietyVC.title = @"社会";
    [self addChildViewController:scietyVC];
    //订阅
    ReaderViewController *readerVC = [[ReaderViewController alloc] init];
    readerVC.title = @"订阅";
    [self addChildViewController:readerVC];
    //科技
    ScienceViewController *scienceVC = [[ScienceViewController alloc] init];
    scienceVC.title = @"科技";
    [self addChildViewController:scienceVC];
}



@end
