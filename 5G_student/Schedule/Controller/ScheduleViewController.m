//
//  ScheduleViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/21.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleListViewController.h"
#import "SGPagingView.h"

@interface ScheduleViewController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

@property (nonatomic, weak) UISegmentedControl * titleSegmentedControl;
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;
@property (nonatomic, strong) ScheduleListViewController * videoScheduleVC;

@end

@implementation ScheduleViewController

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
    UISegmentedControl * titleSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"视频课", @"公开课", @"一对一"]];
    self.titleSegmentedControl = titleSegmentedControl;
    titleSegmentedControl.selectedSegmentIndex = 0;
    [titleSegmentedControl addTarget:self action:@selector(titleSegmentedControlDidChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = titleSegmentedControl;
    
    NSArray *titleArr = @[@"未开始", @"已上课"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleFont = [UIFont systemFontOfSize:14];
    configure.titleSelectedFont = [UIFont systemFontOfSize:17];
    configure.indicatorStyle = SGIndicatorStyleDefault;
    configure.titleSelectedColor = MDefaultColor;
    configure.indicatorColor = MDefaultColor;
    configure.showBottomSeparator = NO;
    configure.titleGradientEffect = YES;
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, MScreenWidth, 44) delegate:self titleNames:titleArr configure:configure];
    self.pageTitleView.hidden = YES;
    [self.view addSubview:self.pageTitleView];
    
    NSMutableArray * childArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i++) {
        ScheduleListViewController * scheduleListVC = [[ScheduleListViewController alloc] init];
        if (i == 0) {
            scheduleListVC.status = 1;
        }else if (i == 1)
        {
            scheduleListVC.status = 4;
        }
        [childArr addObject:scheduleListVC];
    }
    CGFloat contentViewHeight = MScreenHeight - MStatusBarH - MNavBarH - CGRectGetMaxY(self.pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageTitleView.frame), MScreenWidth, contentViewHeight) parentVC:self childVCs:childArr];
    self.pageContentScrollView.delegatePageContentScrollView = self;
    self.pageContentScrollView.hidden = YES;
    [self.view addSubview:self.pageContentScrollView];
    
    self.videoScheduleVC = [[ScheduleListViewController alloc] init];
    self.videoScheduleVC.view.frame = CGRectMake(0, 0, MScreenWidth, MScreenHeight - MStatusBarH - MNavBarH);
    [self.view addSubview:self.videoScheduleVC.view];
    [self addChildViewController:self.videoScheduleVC];
}

- (void)titleSegmentedControlDidChange:(UISegmentedControl *)segmentedControl
{
    self.pageTitleView.hidden = YES;
    self.pageContentScrollView.hidden = YES;
    self.videoScheduleVC.view.hidden = YES;
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.videoScheduleVC.view.hidden = NO;
        self.videoScheduleVC.courseType = VideoCourse;
    }else if (segmentedControl.selectedSegmentIndex == 1)
    {
        self.pageTitleView.hidden = NO;
        self.pageContentScrollView.hidden = NO;
        for (ScheduleListViewController * scheduleListVC in self.pageContentScrollView.childViewControllers) {
            scheduleListVC.courseType = PublicCourse;
        }
    }else if (segmentedControl.selectedSegmentIndex == 2)
    {
        self.pageTitleView.hidden = NO;
        self.pageContentScrollView.hidden = NO;
        for (ScheduleListViewController * scheduleListVC in self.pageContentScrollView.childViewControllers) {
            scheduleListVC.courseType = OnetooneCourse;
        }
    }
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
