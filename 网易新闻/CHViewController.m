//
//  CHViewController.m
//  网易新闻
//
//  Created by nick on 16/3/28.
//  Copyright © 2016年 nick. All rights reserved.
//

#import "CHViewController.h"

#define CHScreenW [UIScreen mainScreen].bounds.size.width
#define CHScreenH [UIScreen mainScreen].bounds.size.height

@interface CHViewController ()<UIScrollViewDelegate>

/** titleSC*/
@property (nonatomic, weak) UIScrollView *titleSC;
/** contentSC*/
@property (nonatomic, weak) UIScrollView *contentSC;
/** 选中的按钮*/
@property (nonatomic, weak) UIButton *selectBtn;
/** 选中标题按钮*/
@property (nonatomic, strong) NSMutableArray *titleBtnArray;
/** 是否初始化*/
@property (nonatomic, assign) BOOL isInitial;
@end
@implementation CHViewController
//懒加载
- (NSMutableArray *)titleBtnArray{
    if (_titleBtnArray == nil) {
        _titleBtnArray = [NSMutableArray array];
    }
    return _titleBtnArray;
}

//view加载完毕时调用
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建标题的滚动视图
    [self setUpTitleScrollView];
   
    //创建内容的滚动视图
    [self setUpContentScrollView];

    //取消导航控制器中scrollview自动设置额外的滚动区域 64
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - view即将显示时调用
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //不用每次都设置按钮的标题
    if (_isInitial == NO) {

        //创建子控制器对应的按钮标题
        [self setUpAllBtnTitle];
        
        _isInitial = YES;
    }
}

#pragma mark - 标题滚动视图
- (void)setUpTitleScrollView{
    //创建视图
    UIScrollView *titleSC = [[UIScrollView alloc] init];
    
    titleSC.backgroundColor = [UIColor whiteColor];
   
    //判断导航条是否隐藏
    CGFloat y = self.navigationController.navigationBarHidden ? 20 : 64;
   
    titleSC.frame = CGRectMake(0, y, CHScreenW, 44);
    
    [self.view addSubview:titleSC];
   
    _titleSC = titleSC;
}

#pragma mark - 内容滚动视图
- (void)setUpContentScrollView{
    
    UIScrollView *contentSC = [[UIScrollView alloc] init];
    
    CGFloat y = CGRectGetMaxY(_titleSC.frame);
    
    contentSC.frame = CGRectMake(0, y, CHScreenW, CHScreenH - y);
    
    [self.view addSubview:contentSC];
    
    _contentSC = contentSC;
    
    //设置代理
    contentSC.delegate = self;
    
    //禁止弹簧效果
    contentSC.bounces = NO;
}

#pragma mark - 创建所有的按钮标题
- (void)setUpAllBtnTitle{
    
    NSInteger count = self.childViewControllers.count;
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = 100;
    CGFloat btnH = 44;
    
    for (int i = 0; i < count; i++) {
        //创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
       
        //获取下标
        btn.tag = i;
      
        btnX = i * btnW;
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        //获取对应的子控制器
        UIViewController *VC = self.childViewControllers[i];
        
        //设置按钮标题
        [btn setTitle:VC.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //监听按钮点击事件
        [btn addTarget:self action:@selector(titleclick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleSC addSubview:btn];
        
        //默认选中第一个
        if (i == 0) {
            [self titleclick:btn];
        }
        //将按钮添加到数组
        [self.titleBtnArray addObject:btn];
    }
    //标题滚动
    self.titleSC.contentSize = CGSizeMake(count * btnW, 0);
    
    self.titleSC.showsHorizontalScrollIndicator = NO;
    
    //内容滚动
    self.contentSC.contentSize = CGSizeMake(count * CHScreenW, 0);
    
    //分页功能
    self.contentSC.pagingEnabled = YES;
    
    //禁用横向滚动条
    self.contentSC.showsHorizontalScrollIndicator = NO;
    
}
#pragma mark - 监听点击
- (void)titleclick:(UIButton *)btn{
    //选中按钮
    [self selectBtn:btn];
    
    //按钮角标
    NSInteger i = btn.tag;
    
    //添加对应子控制器的view
    [self setUpOneChildrenVC:i];
    
    //让scrollview滚动到对应的位置
    CGFloat x = i *CHScreenW;
    self.contentSC.contentOffset = CGPointMake(x, 0);
}

#pragma mark - 添加子控制器的view
- (void)setUpOneChildrenVC:(NSInteger)i {
    //创建子控制器
    UIViewController *VC = self.childViewControllers[i];
    
    // 判断下有没有父控件contentSC  没有再继续下面的步骤  (不用每次都来调用下面的步骤所以判断一下)
    if (VC.view.superview) return;
    
    //设置view的位置
    CGFloat x = i * CHScreenW;
    VC.view.frame = CGRectMake(x, 0, CHScreenW, self.contentSC.bounds.size.height);
    
    [self.contentSC addSubview:VC.view];
}

#pragma mark - 选中的按钮
- (void)selectBtn:(UIButton *)btn{
    //改变之前选中的标题颜色
    [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //恢复按钮的大小
    _selectBtn.transform = CGAffineTransformIdentity;
    
    //改变现在选中的标题颜色
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    //选中的按钮居中显示  本质是: 设置偏移量
    CGFloat offsetX = btn.center.x - CHScreenW * 0.5;
    
    //向右
    if (offsetX < 0) {
        offsetX = 0;
    }
    //最大偏移量
    CGFloat MaxOffsetX = self.titleSC.contentSize.width - CHScreenW;
    
    //向左
    if (offsetX >MaxOffsetX) {
        offsetX = MaxOffsetX;
    }
    [self.titleSC setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    //改变选中按钮的大小
    btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
    
    //保存现在选中的
    _selectBtn = btn;
}

#pragma mark - UIScrollViewDelegate
//滚动完成时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取角标
    NSInteger i = scrollView.contentOffset.x / CHScreenW;
   
    //获取选中标题按钮
    UIButton *selectBtn = self.titleBtnArray[i];
    
    //选中标题
    [self selectBtn:selectBtn];
    
    //将对应子控制器的view添加
    [self setUpOneChildrenVC:i];
}

//滚动时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取左边的角标
    NSInteger leftI = scrollView.contentOffset.x / CHScreenW;
    
    //对应的标题按钮
    UIButton *leftBtn = self.titleBtnArray[leftI];
    
    //获取右边的角标
    NSInteger rightI = leftI + 1;
    
    //对应的标题按钮
    UIButton *rightBtn;
    
    //判断右边的角标是否小于按钮数组中的数
    if (rightI < self.titleBtnArray.count) {
        rightBtn = self.titleBtnArray[rightI];
    }
    //获取缩放比例
    //右边放大
    CGFloat rightScale = scrollView.contentOffset.x /CHScreenW - leftI;
    
    //左边缩小
    CGFloat leftScale = 1 - rightScale;
    
    //对按钮进行缩放 ( 0 ~ 1 )
    leftBtn.transform = CGAffineTransformMakeScale(leftScale * 0.3 + 1 , leftScale * 0.3 + 1);
    rightBtn.transform = CGAffineTransformMakeScale(rightScale * 0.3 + 1, rightScale * 0.3 + 1);
    
    //颜色渐变
    UIColor *rightColor = [UIColor colorWithRed:rightScale green:0 blue:0 alpha:1];
    [rightBtn setTitleColor:rightColor forState:UIControlStateNormal];
    
    UIColor *leftColor = [UIColor colorWithRed:leftScale green:0 blue:0 alpha:1];
    [leftBtn setTitleColor:leftColor forState:UIControlStateNormal];
}
@end
