//
//  OnetooneViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/21.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "OnetooneViewController.h"
#import "CourseListViewController.h"
#import "SGPagingView.h"
#import "MUserDefaultTool.h"
#import "YBPopupMenu.h"

@interface OnetooneViewController ()<YBPopupMenuDelegate, SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@property (nonatomic, weak) UISegmentedControl * titleSegmentedControl;
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;

@end

@implementation OnetooneViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    NSArray * categoryArray = [MUserDefaultTool getCategoryList];
    NSMutableArray *titleTexts = [NSMutableArray array];
    for (NSDictionary * categoryDic in categoryArray) {
        [titleTexts addObject:categoryDic[@"categoryName"]];
    }
    UISegmentedControl * titleSegmentedControl = [[UISegmentedControl alloc] initWithItems:titleTexts];
    self.titleSegmentedControl = titleSegmentedControl;
    titleSegmentedControl.selectedSegmentIndex = 0;
    [titleSegmentedControl addTarget:self action:@selector(titleSegmentedControlDidChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = titleSegmentedControl;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchBarDidClick)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:MBarItemAttDic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"排序" style:UIBarButtonItemStylePlain target:self action:@selector(sortBarDidClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:MBarItemAttDic forState:UIControlStateNormal];
    
    [self addCourseCategoryViewWithIndex:0];
}

- (void)searchBarDidClick
{
    
}

- (void)sortBarDidClick
{
    [YBPopupMenu showAtPoint:CGPointMake(MScreenWidth - 40, MStatusBarH + MNavBarH) titles:@[@"推荐", @"人气", @"近期可约", @"最新发布"] icons:nil menuWidth:120 otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.isShowShadow = NO;
        popupMenu.delegate = self;
    }];
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    
}

- (void)titleSegmentedControlDidChange:(UISegmentedControl *)segmentedControl
{
    for (UIView * subView in self.view.subviews) {
        [subView removeFromSuperview];
    }
    
    [self addCourseCategoryViewWithIndex:segmentedControl.selectedSegmentIndex];
}

- (void)addCourseCategoryViewWithIndex:(NSInteger)index
{
    NSArray * categoryArray = [MUserDefaultTool getCategoryList];
    NSDictionary * categoryDic = categoryArray[index];
    NSMutableArray *titleArr = [NSMutableArray array];
    for (NSDictionary * subCategoryDic in categoryDic[@"list"]) {
        [titleArr addObject:subCategoryDic[@"categoryName"]];
    }
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleFont = [UIFont systemFontOfSize:14];
    configure.titleSelectedFont = [UIFont systemFontOfSize:17];
    configure.indicatorStyle = SGIndicatorStyleDefault;
    configure.titleSelectedColor = MDefaultColor;
    configure.indicatorColor = MDefaultColor;
    configure.showBottomSeparator = NO;
    configure.titleGradientEffect = YES;
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, MScreenWidth, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:self.pageTitleView];
    
    NSMutableArray * childArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i++) {
        CourseListViewController * courseListVC = [[CourseListViewController alloc] init];
        courseListVC.categoryId1 = [NSString stringWithFormat:@"%@", categoryDic[@"id"]];
        NSDictionary * subCategoryDic = categoryDic[@"list"][i];
        courseListVC.categoryId2 = [NSString stringWithFormat:@"%@", subCategoryDic[@"id"]];
        courseListVC.courseType = 3;
        [childArr addObject:courseListVC];
    }
    CGFloat contentViewHeight = MScreenHeight - MStatusBarH - MNavBarH - CGRectGetMaxY(self.pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageTitleView.frame), MScreenWidth, contentViewHeight) parentVC:self childVCs:childArr];
    self.pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:self.pageContentScrollView];
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex
{
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}


@end
