//
//  CourseCategoryViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/25.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "CourseCategoryViewController.h"
#import "CourseListViewController.h"
#import "SGPagingView.h"
#import "FilterCourseView.h"

@interface CourseCategoryViewController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;

@end

@implementation CourseCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.categoryDic[@"categoryName"];
    [self setupUI];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(filterBarDidClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:MBarItemAttDic forState:UIControlStateNormal];
    
    NSMutableArray *titleArr = [NSMutableArray array];
    for (NSDictionary * subCategoryDic in self.categoryDic[@"list"]) {
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
        courseListVC.categoryId1 = [NSString stringWithFormat:@"%@", self.categoryDic[@"id"]];
        NSDictionary * subCategoryDic = self.categoryDic[@"list"][i];
        courseListVC.categoryId2 = [NSString stringWithFormat:@"%@", subCategoryDic[@"id"]];
        courseListVC.courseType = self.courseType;
        [childArr addObject:courseListVC];
    }
    CGFloat contentViewHeight = MScreenHeight - MStatusBarH - MNavBarH - CGRectGetMaxY(self.pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageTitleView.frame), MScreenWidth, contentViewHeight) parentVC:self childVCs:childArr];
    self.pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:self.pageContentScrollView];
}

- (void)filterBarDidClick
{
    FilterCourseView * filterCourseView = [[FilterCourseView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight)];
    [KEY_WINDOW addSubview:filterCourseView];
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
