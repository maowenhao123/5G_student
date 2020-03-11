//
//  AppointmentCourseView.m
//  5G_student
//
//  Created by 毛文豪 on 2020/2/27.
//  Copyright © 2020 jiuge. All rights reserved.
//

#import "AppointmentCourseView.h"
#import "PlaceOrderViewController.h"
#import "PeriodModel.h"

@interface AppointmentCourseView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIButton *selDateButton;
@property (strong, nonatomic) NSMutableArray *dateButtons;
@property (nonatomic, weak) UIView *periodView;
@property (nonatomic, weak) UIButton *selPeriodButton;
@property (strong, nonatomic) NSMutableArray *periodButtons;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation AppointmentCourseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 请求数据
- (void)getPeriodDataWithCourseId:(NSInteger)courseId
{
    NSDictionary *parameters = @{
        @"courseId": @(courseId)
    };
    [MBProgressHUD showMessage:@"" toView:self.contentView];
    [[MHttpTool shareInstance] postWithParameters:parameters url:@"/course/auth/course/user/period/list" success:^(id json) {
        [MBProgressHUD hideHUDForView:self.contentView];
        if (SUCCESS) {
            NSArray * dataArray = [PeriodModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
            [self setDateDataWithData:dataArray];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        MLog(@"error:%@",error);
        [MBProgressHUD hideHUDForView:self.contentView];
    }];
}

- (void)setDateDataWithData:(NSArray *)dataList
{
    for (PeriodModel * periodModel in dataList) {
        for (NSMutableDictionary * dateDic in self.dataArray) {
            NSString * date = dateDic[@"date"];
            date = [date stringByReplacingOccurrencesOfString:@"." withString:@"-"];
            if ([periodModel.date containsString:date]) {
                NSMutableArray * list = dateDic[@"list"];
                [list addObject:periodModel];
            }
        }
    }
    [self reloadPeriodView];
}

#pragma mark - Setting
- (void)setCourseId:(NSInteger)courseId
{
    _courseId = courseId;

    [self getPeriodDataWithCourseId:_courseId];
}

#pragma mark - 布局子视图
- (void)setupUI
{
    self.backgroundColor = MColor(0, 0, 0, 0.4);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 500 + MSafeBottomMargin)];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MMargin, 0, 100, 50)];
    titleLabel.text = @"选择课时";
    titleLabel.textColor = MBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [contentView addSubview:titleLabel];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(MScreenWidth - MMargin - 100, 0, 100, 50);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:MGrayTextColor forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancelButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelButton];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) - 1, self.width, 1)];
    line1.backgroundColor = MWhiteLineColor;
    [contentView addSubview:line1];
    
    UIView * weekView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), self.width, 45)];
    weekView.backgroundColor = MBackgroundColor;
    [contentView addSubview:weekView];
    
    UIView * dateView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(weekView.frame), self.width, 45)];
    dateView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:dateView];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    dateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSArray * weeks = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    for (int i = 0; i < 7; i++) {
        if (i > 0) {
            dateComponents.day = dateComponents.day + 1;
        }
        NSDate *date = [calendar dateFromComponents:dateComponents];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM.dd";
        CGFloat buttonW = (self.width - 2 * 5) / 7;
        for (int j = 0; j < 2; j++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.frame = CGRectMake(5 + buttonW * i, 0, buttonW, weekView.height);
            [button setTitleColor:MBlackTextColor forState:UIControlStateNormal];
            [button setTitleColor:MDefaultColor forState:UIControlStateSelected];
            if (j == 0) {
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                NSDateComponents * weekDateComponents = [calendar components:NSCalendarUnitWeekday fromDate:date];
                [button setTitle:[NSString stringWithFormat:@"%@", weeks[weekDateComponents.weekday - 1]] forState:UIControlStateNormal];
                [weekView addSubview:button];
                button.userInteractionEnabled = NO;
            }else if (j == 1)
            {
                button.titleLabel.font = [UIFont systemFontOfSize:16];
                [button setTitle:[dateFormatter stringFromDate:date] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(dateButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
                [dateView addSubview:button];
                [self.dateButtons addObject:button];
                if (i == 0) {
                    button.selected = YES;
                    self.selDateButton = button;
                }else
                {
                    button.selected = NO;
                }
            }
        }
        NSMutableDictionary * dateDic = [NSMutableDictionary dictionary];
        [dateDic setValue:[dateFormatter stringFromDate:date] forKey:@"date"];
        [dateDic setValue:[NSMutableArray array] forKey:@"list"];
        [self.dataArray addObject:dateDic];
    }
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dateView.frame) - 1, self.width, 1)];
    line2.backgroundColor = MWhiteLineColor;
    [contentView addSubview:line2];
    
    UIButton * appointmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IsBangIPhone) {
        appointmentButton.frame = CGRectMake(MMargin, contentView.height - 40 - MSafeBottomMargin, MScreenWidth - 2 * MMargin, 40);
    }else
    {
        appointmentButton.frame = CGRectMake(MMargin, contentView.height - 40 - 10, MScreenWidth - 2 * MMargin, 40);
    }
    appointmentButton.backgroundColor = MDefaultColor;
    [appointmentButton setTitle:@"预约" forState:UIControlStateNormal];
    [appointmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    appointmentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    appointmentButton.layer.cornerRadius = appointmentButton.height / 2;
    appointmentButton.layer.masksToBounds = YES;
    [appointmentButton addTarget:self action:@selector(appointmentButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:appointmentButton];
    
    UIView *periodView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line2.frame), contentView.width, appointmentButton.y - CGRectGetMaxY(line2.frame))];
    self.periodView = periodView;
    [contentView addSubview:periodView];
    [self reloadPeriodView];
    
    //动画
    [UIView animateWithDuration:0.2 animations:^{
        contentView.y = self.height - contentView.height;
    }];
}

#pragma mark - 刷新视图
- (void)reloadPeriodView
{
    for (UIView * subView in self.periodView.subviews) {
        [subView removeFromSuperview];
    }
    [self.periodButtons removeAllObjects];
    self.selPeriodButton = nil;
    
    NSArray *periodArray = [NSArray array];
    for (NSMutableDictionary * dateDic in self.dataArray) {
        if ([dateDic[@"date"] isEqualToString:self.selDateButton.currentTitle]) {
            periodArray = dateDic[@"list"];
        }
    }
    
    CGFloat periodButtonW = (MScreenWidth - 4 * MMargin) / 3;
    CGFloat periodButtonH = 32;
    for (int i = 0; i < periodArray.count; i++) {
        PeriodModel * periodModel = periodArray[i];
        UIButton * periodButton = [UIButton buttonWithType:UIButtonTypeCustom];
        periodButton.tag = i;
        periodButton.frame = CGRectMake(MMargin + (periodButtonW + MMargin) * (i % 3), MMargin + (periodButtonH + MMargin) * (i / 3), periodButtonW, periodButtonH);
        NSString * startTime = periodModel.startTime;
        if (startTime.length >= 19) {
            startTime = [startTime substringWithRange:NSMakeRange(11, 5)];
        }
        NSString * endTime = periodModel.endTime;
        if (endTime.length >= 19) {
            endTime = [endTime substringWithRange:NSMakeRange(11, 5)];
        }
        NSString *periodTime = [NSString stringWithFormat:@"%@~%@", startTime, endTime];
        [periodButton setTitle:periodTime forState:UIControlStateNormal];
        [periodButton setTitleColor:MBlackTextColor forState:UIControlStateNormal];
        [periodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [periodButton setTitleColor:MGrayTextColor forState:UIControlStateDisabled];
        periodButton.titleLabel.font = [UIFont systemFontOfSize:15];
        periodButton.layer.cornerRadius = periodButton.height / 2;
        periodButton.layer.masksToBounds = YES;
        if (periodModel.reserveUserId != 0) {//已经有人预约
            periodButton.enabled = NO;
            periodButton.backgroundColor = [UIColor whiteColor];
            periodButton.layer.borderColor = MGrayLineColor.CGColor;
            periodButton.layer.borderWidth = 1;
        }else
        {
            if (i == 0) {
                periodButton.selected = YES;
                periodButton.backgroundColor = MDefaultColor;
                periodButton.layer.borderWidth = 0;
                self.selPeriodButton = periodButton;
            }else
            {
                periodButton.selected = NO;
                periodButton.backgroundColor = [UIColor whiteColor];
                periodButton.layer.borderColor = MGrayLineColor.CGColor;
                periodButton.layer.borderWidth = 1;
            }
        }
        [periodButton addTarget:self action:@selector(periodButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.periodView addSubview:periodButton];
        [self.periodButtons addObject:periodButton];
    }
}

#pragma mark - 点击事件
- (void)dateButtonDidClick:(UIButton *)button
{
    for (UIButton * dateButton in self.dateButtons) {
        if (dateButton.selected && dateButton != button) {
            dateButton.selected = NO;
        }else if (dateButton == button)
        {
            dateButton.selected = YES;
            self.selDateButton = button;
        }
    }
    [self reloadPeriodView];
}

- (void)periodButtonDidClick:(UIButton *)button
{
    for (UIButton * periodButton in self.periodButtons) {
        if (periodButton.selected && periodButton != button) {
            periodButton.selected = NO;
            periodButton.backgroundColor = [UIColor whiteColor];
            periodButton.layer.borderColor = MGrayLineColor.CGColor;
            periodButton.layer.borderWidth = 1;
        }else if (periodButton == button)
        {
            periodButton.selected = YES;
            periodButton.backgroundColor = MDefaultColor;
            periodButton.layer.borderWidth = 0;
            self.selPeriodButton = periodButton;
        }
    }
}

- (void)appointmentButtonDidClick
{
    PeriodModel * selPeriodModel;
    for (NSMutableDictionary * dateDic in self.dataArray) {
        if ([dateDic[@"date"] isEqualToString:self.selDateButton.currentTitle]) {
            NSArray * periodArray = dateDic[@"list"];
            for (int i = 0; i < periodArray.count; i++) {
                PeriodModel * periodModel = periodArray[i];
                NSString * startTime = periodModel.startTime;
                if (startTime.length >= 19) {
                    startTime = [startTime substringWithRange:NSMakeRange(11, 5)];
                }
                NSString * endTime = periodModel.endTime;
                if (endTime.length >= 19) {
                    endTime = [endTime substringWithRange:NSMakeRange(11, 5)];
                }
                NSString *periodTime = [NSString stringWithFormat:@"%@~%@", startTime, endTime];
                if ([self.selPeriodButton.currentTitle isEqualToString:periodTime]) {
                    selPeriodModel = periodModel;
                    break;
                }
            }
        }
    }
    PlaceOrderViewController * placeOrderVC = [[PlaceOrderViewController alloc] init];
    placeOrderVC.courseId = self.courseId;
    placeOrderVC.periodId = selPeriodModel.id;
    [self.viewController.navigationController pushViewController:placeOrderVC animated:YES];
}

#pragma mark - Getting
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)dateButtons
{
    if (!_dateButtons) {
        _dateButtons = [NSMutableArray array];
    }
    return _dateButtons;
}

- (NSMutableArray *)periodButtons
{
    if (!_periodButtons) {
        _periodButtons = [NSMutableArray array];
    }
    return _periodButtons;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.contentView.superview];
        if (CGRectContainsPoint(self.contentView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}

@end
