//
//  CourseDetailViewController.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/19.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "TeacherDetailViewController.h"
#import "CourseInfoTableViewCell.h"
#import "CouresPeriodTableViewCell.h"
#import "CourseTeacherTableViewCell.h"
#import "CourseHeaderFooterView.h"
#import "BuyCourseView.h"
#import "AppointmentCourseView.h"

@interface CourseDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIButton * applyButton;
@property (nonatomic, strong) CourseModel *courseModel;

@end

@implementation CourseDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self getCourseData];
}

#pragma mark - 请求数据
- (void)getCourseData
{
    NSDictionary *parameters = @{
        @"courseId": self.courseId
    };
    waitingView
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/view" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            CourseModel *courseModel = [CourseModel mj_objectWithKeyValues:json[@"data"]];
            courseModel.periodList = [PeriodModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"periodList"]];
            self.courseModel = courseModel;
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    [self.view addSubview:self.tableView];
    
    //底部
    CGFloat bottomViewH = 60;
    if (IsBangIPhone) {
        bottomViewH = 50 + MSafeBottomMargin;
    }
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MScreenHeight - bottomViewH, MScreenWidth, bottomViewH)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 1)];
    bottomLine.backgroundColor = MWhiteLineColor;
    [bottomView addSubview:bottomLine];
    
    UIButton * consultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    consultButton.frame = CGRectMake(MMargin, 10, 70, 40);
    [consultButton setTitle:@"咨询" forState:UIControlStateNormal];
    [consultButton setTitleColor:MBlackTextColor forState:UIControlStateNormal];
    consultButton.titleLabel.font = [UIFont systemFontOfSize:15];
    consultButton.layer.cornerRadius = consultButton.height / 2;
    consultButton.layer.borderWidth = 1;
    consultButton.layer.borderColor = MGrayLineColor.CGColor;
    [consultButton addTarget:self action:@selector(consultButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:consultButton];
    
    UIButton * applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyButton = applyButton;
    applyButton.frame = CGRectMake(MMargin + 80, 10, MScreenWidth - 2 * MMargin - 80, 40);
    applyButton.backgroundColor = MDefaultColor;
    [applyButton setTitle:@"报名" forState:UIControlStateNormal];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    applyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    applyButton.layer.cornerRadius = applyButton.height / 2;
    applyButton.layer.masksToBounds = YES;
    [applyButton addTarget:self action:@selector(applyButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:applyButton];
    
    //返回
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(MMargin, MStatusBarH + 6, 32, 32);
    [backButton setImage:[UIImage imageNamed:@"gray_background_back_bar"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

#pragma mark - 点击事件
- (void)backButtonDidClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)consultButtonDidClick
{
    
}

- (void)applyButtonDidClick:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"预约"]) {
        AppointmentCourseView * appointmentCourseView = [[AppointmentCourseView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight) courseId:self.courseId];
        [self.view addSubview:appointmentCourseView];
    }else if ([button.currentTitle isEqualToString:@"报名"])
    {
        BuyCourseView * buyCourseView = [[BuyCourseView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight)];
        buyCourseView.courseModel = self.courseModel;
        [self.view addSubview:buyCourseView];
    }
}

#pragma mark - Setting
- (void)setCourseModel:(CourseModel *)courseModel
{
    _courseModel = courseModel;
    
    if (_courseModel.courseType == 3) {//一对一需要预约
        [self.applyButton setTitle:@"预约" forState:UIControlStateNormal];
    }else
    {
        [self.applyButton setTitle:@"报名" forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

#pragma mark - Getting
- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGFloat bottomViewH = 60;
        if (IsBangIPhone) {
            bottomViewH = 50 + MSafeBottomMargin;
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight - bottomViewH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = MBackgroundColor;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return self.courseModel.periodList.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CourseInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CourseInfoTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"CourseInfoTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        }
        cell.courseModel = self.courseModel;
        return cell;
    }else if (indexPath.section == 1)
    {
        CourseTeacherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTeacherTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"CourseTeacherTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        }
        cell.lecturerModel = self.courseModel.lecturer;
        return cell;
    }else if (indexPath.section == 2)
    {
        CouresPeriodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CouresPeriodTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"CouresPeriodTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        }
        cell.index = indexPath.row;
        cell.periodModel = self.courseModel.periodList[indexPath.row];
        return cell;
    }else
    {
        CourseTeacherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTeacherTableViewCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"CourseTeacherTableViewCell" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        }
        cell.lecturerModel = self.courseModel.lecturer;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 3) {
        CourseHeaderFooterView * headerView = [CourseHeaderFooterView headerViewWithTableView:tableView];
        if (section == 2) {
            headerView.titleLabel.text = [NSString stringWithFormat:@"课程大纲·共%ld讲", self.courseModel.periodList.count];
        }else if (section == 3)
        {
            headerView.titleLabel.text = @"课程详情";
        }
        return headerView;
    }else
    {
        CGFloat headerViewH = 9;
        if (section == 0) {
            headerViewH = 0.01;
        }
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, headerViewH)];
        return headerView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MScreenWidth, 0.01)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 305;
    }else if (indexPath.section == 1)
    {
        return 80;
    }else if (indexPath.section == 2)
    {
        return 70;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else if (section == 2 || section == 3)
    {
        return 9 + 45;
    }
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        TeacherDetailViewController * teacherDetailVC = [[TeacherDetailViewController alloc] init];
        teacherDetailVC.teacherId = self.courseModel.lecturer.id;
        [self.navigationController pushViewController:teacherDetailVC animated:YES];
    }
}



@end
